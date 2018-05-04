SupplyButton = class()

function SupplyButton:init(player)
    self.player = player
    self.ability_phase = ABILITY_PHASE.MAIN

    self.position = SUPPORT.PLAYER_SUPPLY_BUTTON_POSITION[self.player]
    self.width = SUPPORT.SUPPLY_BUTTON_WIDTH
    self.height = SUPPORT.SUPPLY_BUTTON_HEIGHT
    self.radius = SUPPORT.SUPPLY_BUTTON_RADIUS
    self.font_size = SUPPORT.SUPPLY_BUTTON_FONT_SIZE
    
    self.mode = SUPPLY_BUTTON.SUPPLY
    
    self.toggle = false
    
end


function SupplyButton:checkActivation(turn_player, turn_phase)
    if self.player ~= turn_player then
        self.activation = false
        return
    end
    
    if turn_phase == TURN_PHASE.MAIN then
        self.mode = SUPPLY_BUTTON.SUPPLY
    elseif turn_phase == TURN_PHASE.CONFLICT then
        self.mode = SUPPLY_BUTTON.RESOLVE
    end
    
    self.activation = true
    
end


function SupplyButton:draw()
    
    pushStyle()
    
    if self.toggle ~= true then
        if self.mode == SUPPLY_BUTTON.SUPPLY then
            fill(255, 255, 0, 255)
        elseif self.mode == SUPPLY_BUTTON.RESOLVE then
            fill(0, 109, 255, 255)
        end
    else
        fill(255, 0, 0, 255)
    end
    
    rectMode(CENTER)
    rect(self.position.x, self.position.y, self.width, self.height)
    
    if self.activation == true then
        fill(0, 0, 0, 255)
        textMode(CENTER)
        fontSize(self.font_size)
        if self.mode == SUPPLY_BUTTON.SUPPLY then
            text("SUPPLY", self.position.x, self.position.y)
        elseif self.mode == SUPPLY_BUTTON.RESOLVE then
            text("RESOLVE", self.position.x, self.position.y)
        end
    end
    
    popStyle()
    
end


function SupplyButton:isTouched(x, y)
    local diff_x = math.abs(self.position.x - x)
    local diff_y = math.abs(self.position.y - y)
        
    local radius = self.radius
       
     
    if(diff_x * diff_x + diff_y * diff_y < radius * radius) then
        return true
    end
    
    return false
end


function SupplyButton:touched(touch)
    if self.activation == true then
        
        if touch.state == BEGAN then
            if self:isTouched(touch.x, touch.y) == true then
                self.toggle = true
            end
            
        elseif touch.state == MOVING then
            if self:isTouched(touch.x, touch.y) == true then
                
            else
                self.toggle = false
            end
            
        elseif touch.state == ENDED then
            if self:isTouched(touch.x, touch.y) == true and
                                                    self.toggle == true then
                --send event to game object
                if self.mode == SUPPLY_BUTTON.SUPPLY then
                    game:pushSupplyEvent("Supply - Default")
                elseif self.mode == SUPPLY_BUTTON.RESOLVE then
                    game:pushSupplyEvent("Resolve - Default")
                end
                
            end
            
            self.toggle = false
            
        end
    end
end
