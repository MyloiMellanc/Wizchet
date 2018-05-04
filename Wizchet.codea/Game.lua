Game = class()

function Game:init(gameboard, gameplayer, turnstate, stack)
    self.game_board = gameboard
    self.game_player = gameplayer
    self.turn_state = turnstate
    self.stack = stack
    
    self.score_board = ScoreBoard()
    
    self.game_text = "Game started."
    self.game_text_position = SUPPORT.GAME_TEXT_POSITION
    
end

function Game:startGame()
    self.game_player[1]:checkActivation(1, TURN_PHASE.MAIN)
end

function Game:updateScore()
    self.score_board:updateScore(self.game_board)
    
end

function Game:checkAbilityEvent(ability_name)
    
    --타일 토글여부 확인
    local toggled_tile = self.game_board:getToggledTileNumber()
    if toggled_tile == FAILED then
        return false
    end
    
    
    --이벤트가 필라설치일 경우
    --플레이어 필라 사용여부 확인
    local ability = getAbility(ability_name)
    
    if ability.content == CONTENT_TYPE.PILLAR then
        local current_player = self.turn_state:getCurrentPlayer()
        local pillar_is_set = self.game_player[current_player]:isPillarSet()
        if pillar_is_set == true then
            return false
        end
    end
    
    
    return true
end



function Game:activateAbility(ability_name)
    --유효 판단된 어빌리티를 실행
    --라이브러리를 뒤져서 해당 함수포인터를 실행할것
    --라이브러리에 있는 모든 이벤트 함수는 턴과 관련된 리턴타입을 넘긴다.
    --그 리턴타입을 받아, 턴 제어를 할것.
    
    local ability = getAbility(ability_name)
    if ability == FAILED then
        print("Ability Name Error.")
        return FAILED
    end
    
    
    local current_player = self.turn_state:getCurrentPlayer()
    local tile_number = self.game_board:getToggledTileNumber()
    
    --마나 코스트 지불
    self.game_player[current_player].resource:spendMana(ability.cost)
    
    
    --아이템일 경우, 카운트 낮춤, 0일경우 제거
    self.game_player[current_player]:spendItem(ability_name)
    
    
    --발동 및 리턴타입 받기
    local return_type = ability.func(current_player, tile_number)
    
    --필라 설치일 경우에는 플레이어 카운트를 증가
    if ability.type == ABILITY_TYPE.PILLAR then
        self.game_player[current_player]:changePillarCount(1)
    end
    
    return return_type
    
end


function Game:finishEvent(return_type)
    
    local current_player = self.turn_state:getCurrentPlayer()
    
    --리턴타입 처리
    
    --Conflict 해결
    if return_type == RETURN_TYPE.RESOLVE then
        self.stack:resolve()
        self.turn_state:resolve()
        
    --턴 전환은 Conflict 없이 턴 넘기기    
    elseif return_type == RETURN_TYPE.NEXT_TURN then
        self.stack:resolve()
        self.game_player[1]:setPillarSet(false)
        self.game_player[2]:setPillarSet(false)
        self.game_board:updateTileOwner(current_player)
        self.game_board:updateTileEffect()
        self.turn_state:goNextTurn(false)
    
    --Conflict 발생    
    elseif return_type == RETURN_TYPE.CONFLICT then
        self.game_player[1]:setPillarSet(false)
        self.game_player[2]:setPillarSet(false)
        self.game_board:updateTileOwner(current_player)
        self.game_board:updateTileEffect()
        self.turn_state:goNextTurn(true)
    end
    
    
    --현재 점수 계산
    self:updateScore()
    
    
    --게임 종료 판단
    if self.turn_state:isEnded() == true then
        self.game_text = "GAME OVER"
        self.game_player[1]:endGame()
        self.game_player[2]:endGame()
        return
    end
    
    
    --플레이어의 Activation Check 수행
    local current_player = self.turn_state:getCurrentPlayer()
    local current_phase = self.turn_state:getCurrentPhase()

    self.game_player[1]:checkActivation(current_player, current_phase)
    self.game_player[2]:checkActivation(current_player, current_phase)

end



function Game:pushAbilityEvent(ability_name)
    --유효여부 판단
    local available = self:checkAbilityEvent(ability_name)
    
    if available == false then
        print("Unavailable Tile.")
        return
    end
    
    --효과 삽입
    local return_type = self:activateAbility(ability_name)
    if return_type == FAILED then
        print("Return Type Error.")
        return
    end
    
    --실제 효과 수행
    self:finishEvent(return_type)
    
end


function Game:pushTileEvent(object_name)
    local turn_player = self.turn_state:getCurrentPlayer()
    local tile_number = self.game_board:getToggledTileNumber()
    local tile = self.game_board:getTileByNumber(tile_number)
    
    if tile.tile_object_player == turn_player then
        local object = getObject(object_name)
        if object == FAILED then
            print("Object Name Error.")
            return
        end
        
        local return_type = object.func(turn_player, tile_number)
        
        
        self:finishEvent(return_type)
    end
end


function Game:pushSupplyEvent(ability_name)
    local turn_player = self.turn_state:getCurrentPlayer()
    
    local ability = getAbility(ability_name)
    if ability == FAILED then
        print("Ability Name Error.")
        return
    end
    
    local return_type = ability.func(turn_player, TILE_IS_NOT_TOGGLED)
    
    
    self:finishEvent(return_type)

end




function Game:setGameText(game_text)
    self.game_text = game_text
end


function Game:draw()
    
    self.score_board:draw()
    
    pushStyle()
    fill(200, 200, 200, 255)
    textMode(CENTER)
    text(self.game_text, self.game_text_position.x, self.game_text_position.y)
    popStyle()
end


function Game:touched(touch)

end

