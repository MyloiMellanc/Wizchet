Item = class()

function Item:init(player, item_name)
    self.player = player
    self.name = item_name
    
    self:initAbility()
    
    -------------------------------------
    --터치용 변수
    
    self.activation = false
    self.toggle = false
    
    -------------------------------------
    --드로잉용 변수
    
    self.radius = SUPPORT.ABILITY_RADIUS
    self.rect_width = SUPPORT.ABILITY_RECT_WIDTH
    self.rect_height = SUPPORT.ABILITY_RECT_HEIGHT
    
end


function Item:initAbility()
    local item = getAbility(self.name)
    
    self.sprite = item.sprite
    self.content = item.content
    self.ability_type = item.type
    self.ability_phase = item.phase
    
    self.item_count = item.count
    self.cost = item.cost
    
    self.ability_color = setTypeColor(self.ability_type)
end


function Item:setPosition(position)
    self.natural_position_x = position.x
    self.natural_position_y = position.y
    self.position_x = position.x
    self.position_y = position.y
end


function Item:updateActivation(turn_player, turn_phase, remain_mana, pillar_is_set, set_count)
    if self.player ~= turn_player then
        self.activation = false
        return
    elseif self.ability_phase ~= turn_phase then
        self.activation = false
        return
    elseif self.cost > remain_mana then
        self.activation = false
        return
    end
    
    
    self.activation = true
    
end


function Item:draw()
    --배경 컬러 드로잉은 내츄럴 포지션으로 할것
    
    pushStyle()
    
    if self.activation == true then
        fill(self.ability_color)
    else
        fill(0, 0, 0, 255)
    end
    
    rectMode(CENTER)
    rect(self.natural_position_x, self.natural_position_y, 
                                            self.rect_width, self.rect_height)
    
    
    spriteMode(CENTER)
    sprite(self.sprite, self.position_x,self.position_y)
    
    fill(255, 8, 0, 255)
    fontSize(30)
    text(self.item_count, self.natural_position_x, self.natural_position_y - 20)
    
    popStyle()
    
end


function Item:isTouched(x, y)
    local diff_x = math.abs(self.position_x - x)
    local diff_y = math.abs(self.position_y - y)
        
    --중복 토글 방지차원에서 반지름 값 낮춤
    local radius = self.radius - 20
       
     
    if(diff_x * diff_x + diff_y * diff_y < radius * radius) then
        return true
    end
    
    return false
end


function Item:touched(touch)
    --BEGAN : 범위 파악, 토글 온
    --MOVING : 토글되어있을시 포지션 움직임
    --ENDED : 토글 오프, 내추럴 포지션으로 돌리기
    
    if self.activation == true then
        
        if touch.state == BEGAN then
            if self:isTouched(touch.x, touch.y) == true then
                self.toggle = true
            end     
            
        elseif touch.state == MOVING then
            if self.toggle == true then
                self.position_x = touch.x
                self.position_y = touch.y
            end      
            
        elseif touch.state == ENDED then
            if self.toggle == true then
                --send event to game object
                game:pushAbilityEvent(self.name)
            end
            
            self.toggle = false
            self.position_x = self.natural_position_x
            self.position_y = self.natural_position_y
            
        end
    end
end
