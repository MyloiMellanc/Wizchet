Tile = class()

function Tile:init()
    self.number = nil
    self.x = nil
    self.y = nil
    self.radius = nil
    
    self.leftup = 0
    self.rightup = 0
    self.left = 0
    self.right = 0
    self.leftdown = 0
    self.rightdown = 0
    
    
    self.toggle = false
    self.object_toggle = false
    
    self.player = OWNER.NEUTRAL
    self.tile_color = TILE_COLOR.NEUTRAL
    
    self.tile_object_type = TILE_OBJECT_TYPE.NOT_EXIST
    self.tile_object_name = nil
    self.tile_object_player = OWNER.NEUTRL
    self.tile_object_usable = false
    
    --타일 오브젝트의 스프라이트
    self.sprite = nil
    
    self.effect = {} -- 현재는 Hexproof만 사용
end


function Tile:clearThisTile()
    self.player = OWNER.NEUTRAL
    self.tile_color = TILE_COLOR.NEUTRAL
    self.effect = {}
    
    self:clearThisTileObject()
end


function Tile:clearThisTileObject()
    self.tile_object_type = TILE_OBJECT_TYPE.NOT_EXIST
    self.tile_object_name = nil
    self.tile_object_player = OWNER.NEUTRAL
    self.tile_object_usable = false
    self.sprite = nil
end


function Tile:ownThisTile(player)
    self.player = player
    if self.player == OWNER.NEUTRAL then
        self.tile_color = TILE_COLOR.NEUTRAL
    elseif self.player == OWNER.PLAYER_1 then
        self.tile_color = TILE_COLOR.PLAYER_1
    elseif self.player == OWNER.PLAYER_2 then
        self.tile_color = TILE_COLOR.PLAYER_2
    end
end


function Tile:setTileObject(player, tile_object_type, tile_object_name)
    self.tile_object_player = player
    self.tile_object_type = tile_object_type
    self.tile_object_name = tile_object_name
    
    local object = getObject(self.tile_object_name)
    self.tile_object_usable = object.usable
    self.sprite = object.sprite
end





function Tile:draw()
    
    pushStyle()
    
    
    if self.toggle == false then
        fill(self.tile_color)
        ellipse(self.x,self.y,self.radius)
    else
        fill(255, 0, 224, 255)
        ellipse(self.x,self.y,self.radius)
    end
    
    if SUPPORT.TILE_NUMBERING == true then
        fill(85, 85, 85, 255)
        fontSize(15)
        text(self.number, self.x,self.y)
    end
    

    if self.sprite ~= nil then
        sprite(self.sprite, self.x, self.y)
    end
    
    
    
    if self.effect.HEXPROOF == true then
        fill(0, 1, 255, 114)
        ellipse(self.x, self.y, self.radius)
    end
    
        
    popStyle()
end

function Tile:isToggled()
    return self.toggle
end

function Tile:toggleTile()
    self.toggle = true
end

function Tile:untoggleTile()
    self.toggle = false
end

function Tile:isTouched(x, y)
    local diff_x = math.abs(self.x - x)
    local diff_y = math.abs(self.y - y)
    
    --중복 토글 방지차원에서 반지름 값 낮춤
    local radius = self.radius - 20
    
    if(diff_x * diff_x + diff_y * diff_y < radius * radius) then
        return true
    else
        return false
    end
end

function Tile:touched(touch)
    
    if touch.state == BEGAN then
        if self:isTouched(touch.x, touch.y) == true then
            self.toggle = true
            --발동 가능한 오브젝트가 있으면 object toggle on.
            if self.tile_object_usable == true then
                self.object_toggle = true
            end
        else
            self.toggle = false
        end
         
    elseif touch.state == MOVING then
        if self:isTouched(touch.x, touch.y) == true then
            self.toggle = true
        else
            self.toggle = false
            self.object_toggle = false
        end
        
    elseif touch.state == ENDED then
        if self:isTouched(touch.x, touch.y) == true then
            if (self.toggle == true) and (self.object_toggle == true) then
                game:pushTileEvent(self.tile_object_name)
            end
            
            self.toggle = false
            self.object_toggle = false
        end
        
    end
    
    
end



