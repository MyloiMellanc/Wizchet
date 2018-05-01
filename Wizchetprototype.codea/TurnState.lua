TurnState = class()

function TurnState:init(max_turn)
    
    self.position = SUPPORT.TURN_STATE_POSITION
    self.font_size = SUPPORT.TURN_STATE_FONT_SIZE
    self.text_diff = SUPPORT.TURN_STATE_TEXT_DIFF
    
    self.max_turn = max_turn
    self.current_turn = 1
    self.current_phase = TURN_PHASE.MAIN
    self.current_player = 1
    
end


function TurnState:isEnded()
    if self.current_turn == self.max_turn then
        return true
    end
    
    return false
end


function TurnState:setConflict(conflicted)
    if conflicted == true then
        self.current_phase = TURN_PHASE.CONFLICT
    elseif conflicted == false then
        self.current_phase = TURN_PHASE.MAIN
    end
end


function TurnState:resolve()
    self:setConflict(false)
end


function TurnState:changePlayer()
    if self.current_player == 1 then
        self.current_player = 2
    elseif self.current_player == 2 then
        self.current_player = 1
    end
end


function TurnState:goNextTurn(conflicted)
    self.current_turn = self.current_turn + 1
    
    self:setConflict(conflicted)
    
    self:changePlayer()
end


function TurnState:getCurrentPlayer()
    return self.current_player
end


function TurnState:getCurrentTurn()
    return self.current_turn
end


function TurnState:getCurrentPhase()
    return self.current_phase
end


function TurnState:setPosition(position)
    self.position = position
end


function TurnState:draw()
    
    pushStyle()
    
    
    fill(255, 255, 255, 255)
    
    textMode(CENTER)
    text("TURN", self.position.x, self.position.y + 20)
    text(self.current_turn.." / "..self.max_turn, 
                                            self.position.x, self.position.y)
    
    local player_position_x = self.position.x
    local player_position_y = self.position.y
    
    if self.current_player == 1 then
        player_position_x = player_position_x - self.text_diff
    elseif self.current_player == 2 then
        player_position_x = player_position_x + self.text_diff
    end
    
    if self.current_phase == TURN_PHASE.MAIN then
        fill(255, 255, 0, 255)
        text("YOUR TURN", player_position_x, player_position_y)
    elseif self.current_phase == TURN_PHASE.CONFLICT then
        fill(255, 0, 0, 255)
        text("CONFLICT!", player_position_x, player_position_y)
    end
    popStyle()
end


function TurnState:touched(touch)
    --not used
end
