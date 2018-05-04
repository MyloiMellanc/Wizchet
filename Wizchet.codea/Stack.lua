Stack = class()

function Stack:init()
    self.stack = {}
    
    self.action_stack = {}
    
end


function Stack:pushStack(player, effect, tile_number)
    local stack = {}
    stack.player = player
    stack.effect = effect
    stack.tile_number = tile_number
    
    table.insert(self.stack, stack)

end

function Stack:pushActionStack(action)    
    table.insert(self.action_stack, action)
    
end


function Stack:resolve()
    --index가 0이 될 때까지 역순으로 해결
    local index = #self.stack
    
    while index > 0 do
        local effect = self.stack[index].effect
        local player = self.stack[index].player
        local tile_number = self.stack[index].tile_number
        
        effect(player, tile_number)
        
        table.remove(self.stack, index)
        
        index = index - 1
    end
    
    --action_stack 비우기
    index = #self.action_stack
    
    while index > 0 do
        table.remove(self.action_stack, index)
        
        index = index - 1
    end
    
end


function Stack:draw()
    for k,v in pairs(self.action_stack) do
        pushStyle()
        local tile = game_board:getTileByNumber(v.tile_number)
        sprite(v.sprite, tile.x, tile.y)
        popStyle()
    end
end


function Stack:touched(touch)
    
end
