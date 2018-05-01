


------------------------------------------------------------
--이펙트 함수


--원칙적으로 여기서만 전역변수(setup() 선언된 변수들) 이용을 허용함

function EffectDemo(player, tile_number)
    --텍스트 입력
    local game_text = ""
    game:setGameText(game_text)
    
    --스택용 함수 생성
    local function effect(player, tile_number)
        ---
    end
    
    local ptr = func
    stack:pushStack(ptr)

    --액션 만들기
    local action = {}
    action.sprite = ""
    action.position = vec2()
    stack:pushActionStack(action)
    
    
    return RETURN_TYPE.CONFLICT
end

------------------------------------------------------------


function effect_pillar_1(player, tile_number)
    
    --타일이 점령 가능한 지역이면, 필라 설치
    --점령가능 : 상대방 점령지역이 아님 and 다른 오브젝트가 없음
    local function effect(player, tile_number)
        local tile = game_board:getTileByNumber(tile_number)

        if ((tile.player == OWNER.NEUTRAL) or (tile.player == player)) and 
                    (tile.tile_object_type == TILE_OBJECT_TYPE.NOT_EXIST) then
            
            --tile:ownThisTile(player)
            tile:setTileObject(player, TILE_OBJECT_TYPE.PILLAR, 
                                                        "Pillar - Default 1")
        
            game_player[player]:setPillarSet(true)
            
            local game_text ="Player "..player.." set Pillar on tile "..tile_number.."."
            game:setGameText(game_text)
        end
    end
    
    local ptr = effect
    stack:pushStack(player, ptr, tile_number)
    
    --액션 없음
    
    return RETURN_TYPE.RESOLVE 
end


function effect_pillar_2(player, tile_number)
    
    --타일이 점령 가능한 지역이면, 필라 설치   
    --점령가능 : 상대방 점령지역이 아님 and 다른 오브젝트가 없음
    local function effect(player, tile_number)
        local tile = game_board:getTileByNumber(tile_number)

        if ((tile.player == OWNER.NEUTRAL) or (tile.player == player)) and 
                    (tile.tile_object_type == TILE_OBJECT_TYPE.NOT_EXIST) then
            --tile:ownThisTile(player)
            tile:setTileObject(player, TILE_OBJECT_TYPE.PILLAR, 
                                                        "Pillar - Default 2")
        
            game_player[player]:setPillarSet(true)
            
            local game_text ="Player "..player.." set Pillar on tile "..tile_number.."."
            game:setGameText(game_text)
        end
    end
    
    local ptr = effect
    stack:pushStack(player, ptr, tile_number)
    
    --액션 없음
    
    return RETURN_TYPE.RESOLVE 
end


function effect_attack_1(player, tile_number)
    local game_text = "Player "..player.." is set to attack!"
    game:setGameText(game_text)
    
    local function effect(player, tile_number)
        --해당 타일이 Hexproof이 아닐 경우 클리어하고, 분화구를 1턴동안 남김
        local tile = game_board:getTileByNumber(tile_number)
        if tile.effect.HEXPROOF ~= true then
            tile:clearThisTile()
            tile:setTileObject(OWNER.NEUTRAL, TILE_OBJECT_TYPE.TERRAIN,
                                                    "Terrain - Fire Place 1")
            local game_text = "Player "..player.."'s attack is successfully done."
            game:setGameText(game_text)
        else
            local game_text = "Player "..player.."'s attack is blocked."
            game:setGameText(game_text)
        end
    end
    
    local ptr = effect
    stack:pushStack(player, ptr, tile_number)
    
    --조준경 모양의 마크를 액션스택에 넣을것  
    local action = {}
    action.sprite = "Space Art:Red Explosion"
    action.tile_number = tile_number
    stack:pushActionStack(action)

    
    --CONFLICT 발생
    return RETURN_TYPE.CONFLICT
end


function effect_moving_1(player, tile_number)
    --해당 타일로 주변 6타일 중 임의의 자신 필라 하나를 이동시킴
    local function effect(player, tile_number)
        local tiles = {}
        local target_tile = game_board:getTileByNumber(tile_number)
        
        if target_tile.tile_object_type == TILE_OBJECT_TYPE.NOT_EXIST then
            for i = 1, 6 do
                local near_tile = target_tile[NEAR_TILE[i]]
                if (near_tile ~= nil) and 
                   (near_tile.tile_object_player == player) and
                   (near_tile.tile_object_type == TILE_OBJECT_TYPE.PILLAR) then
                    table.insert(tiles, near_tile)
                end
            end
                
            if #tiles > 0 then
                local selected_tile = tiles[math.random(1, #tiles)]
                local selected_tile_object_type = selected_tile.tile_object_type
                local selected_tile_object_name = selected_tile.tile_object_name
                
                target_tile:setTileObject(player, selected_tile_object_type,
                                                    selected_tile_object_name)
                selected_tile:clearThisTileObject()
            end
        end
        
        local game_text = "Player "..player.." is activate Moving Spell."
        game:setGameText(game_text)
    end
    
    local ptr = effect
    stack:pushStack(player, ptr, tile_number)
    
    --액션 없음
    
    return RETURN_TYPE.RESOLVE
    
end


function effect_moving_2(player, tile_number)
    --해당 타일로 주변 6타일 중 임의의 자신 필라 하나를 이동시킴(타겟이 된 필라 우선)
    local function effect(player, tile_number)
        local tiles = {}
        local target_tile = game_board:getTileByNumber(tile_number)
        local selected_tile = nil
        
        if target_tile.tile_object_type == TILE_OBJECT_TYPE.NOT_EXIST then
            for i = 1, 6 do
                local near_tile = target_tile[NEAR_TILE[i]]
                if (near_tile ~= nil) and 
                   (near_tile.tile_object_player == player) and
                   (near_tile.tile_object_type == TILE_OBJECT_TYPE.PILLAR) then
                    table.insert(tiles, near_tile)
                end
            end
                
            --타겟 걸린 필라 우선으로 선정 - 스택 마지막 내용물 이용
            --추후에 이 알고리즘은 바뀔 수 있음
            local conflict_tile_number = 
                                    stack.stack[#stack.stack - 1].tile_number
            for k,v in pairs(tiles) do
                if v.number == conflict_tile_number then
                    selected_tile = v
                end
            end
            
            --주변에 타겟잡힌 필라가 없을시, 인접한 것 중 선별
            if selected_tile == nil then
                if #tiles > 0 then
                    selected_tile = tiles[math.random(1, #tiles)]
                end
            end 
            
            
            if selected_tile ~= nil then
                local selected_tile_object_type = 
                                            selected_tile.tile_object_type
                local selected_tile_object_name = 
                                            selected_tile.tile_object_name
                
                target_tile:setTileObject(player, selected_tile_object_type,
                                                    selected_tile_object_name)
                selected_tile:clearThisTileObject()
                
                local game_text = "Player "..player.." moved pillar."
                game:setGameText(game_text)
            end
        end
        
    end
    
    local ptr = effect
    stack:pushStack(player, ptr, tile_number)
    
    
    
    --액션 없음
    
    return RETURN_TYPE.RESOLVE
    
end


function effect_hexproof_1(player, tile_number)
    --해당 타일에 한 턴동안 HEXPROOF를 부여한다
    local function effect(player, tile_number)
        local tile = game_board:getTileByNumber(tile_number)
        tile.effect.HEXPROOF = true
        
        local game_text = "Tile "..tile_number.." is hexproofed."
        game:setGameText(game_text)
    end
    
    local ptr = effect
    stack:pushStack(player, ptr, tile_number)
    
    
    --액션 없음
    
    return RETURN_TYPE.RESOLVE
end


function effect_purify_1(player, tile_number)
    local function effect(player, tile_number)
        local tile = game_board:getTileByNumber(tile_number)
        
        for i = 1, 6 do
            local near_tile = tile[NEAR_TILE[i]]
            
            if near_tile ~= nil then
                near_tile:ownThisTile(OWNER.NEUTRAL)
            end
        end
        
        tile:ownThisTile(OWNER.NEUTRAL)
        
        local game_text = "Purify Spell is on tile "..tile_number
        game:setGameText(game_text)
    end
    
     
    local ptr = effect
    stack:pushStack(player, ptr, tile_number)
    
    --액션 없음
    
    return RETURN_TYPE.RESOLVE
end


function effect_mimic_1(player, tile_number)
    
    --타일의 점령과 관계없이, 비어있다면 그 위에 해당 플레이어 소유의 미믹을 남김.
    --effect func : 주변의 6타일을 클리어한다 (마나소모 0)
    local function effect(player, tile_number)
        local tile = game_board:getTileByNumber(tile_number)
        if tile.tile_object_type == TILE_OBJECT_TYPE.NOT_EXIST then
            tile:setTileObject(player, TILE_OBJECT_TYPE.ITEM, "Item - mimic 1")
        
            local game_text = "Player "..player.." set Mimic on tile "..tile_number.."."
            game:setGameText(game_text) 
        end   
    end
    
    local ptr = effect
    stack:pushStack(player, ptr, tile_number)
    
    --액션 없음
    
    return RETURN_TYPE.RESOLVE
end


--기본 수급 버튼
function effect_default_supply_1(player, tile_number)
    
    local function effect(player, tile_number)
        local pillar_counter = 0
        for k, v in pairs(game_board.board) do
            if (v.tile_object_type == TILE_OBJECT_TYPE.PILLAR) and 
                                        (v.tile_object_player == player) then
                pillar_counter = pillar_counter + 1
            end
        end
        
        local scrab_mana = pillar_counter * 6
        game_player[player].resource:addMana(scrab_mana)
        
        local game_text = "Player "..player.." scrab "..scrab_mana.." mana from Pillar."
        game:setGameText(game_text)
    end
    
    local ptr = effect
    stack:pushStack(player, ptr, tile_number)
    
    --액션 없음
    
    return RETURN_TYPE.NEXT_TURN
end

--기본 해결 버튼
function effect_default_resolve_1(player, tile_number)
    
    local game_text = "Player "..player.." didn't countered."
    game:setGameText(game_text)
    
    return RETURN_TYPE.RESOLVE
end




