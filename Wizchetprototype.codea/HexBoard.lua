HexBoard = class()

function HexBoard:init()
    self.centerpoint = SUPPORT.HEXBOARD_CENTER_POSITION
    self.tilelength = SUPPORT.TILE_LENGTH
    self.tileradius = SUPPORT.TILE_RADIUS
    self.board = {}
    --self.board[0] = nil   문제가 생기면 다시 활성화할것
end

function HexBoard:initBoard()
    
    local tilelen = self.tilelength
    local sinelen = tilelen * math.sin(math.rad(60))
    
    for i = 1, 37 do
        local tile = Tile()
        
        if i <= 4 then
            tile.x = (-1.5 + i - 1) * tilelen
            tile.y = 3 * sinelen
        elseif i >= 5 and i <= 9 then
            tile.x = (-2 + i - 5) * tilelen
            tile.y = 2 * sinelen
        elseif i >= 10 and i <= 15 then
            tile.x = (-2.5 + i - 10) * tilelen
            tile.y = 1 * sinelen
        elseif i >= 16 and i <= 22 then
            tile.x = (-3 + i - 16) * tilelen
            tile.y = 0
        elseif i >= 23 and i <= 28 then
            tile.x = (-2.5 + i - 23) * tilelen
            tile.y = -1 * sinelen
        elseif i >= 29 and i <= 33 then
            tile.x = (-2 + i - 29) * tilelen
            tile.y = -2 * sinelen
        elseif i >= 34 and i <= 37 then
            tile.x = (-1.5 + i - 34) * tilelen
            tile.y = -3 * sinelen
        end
        tile.x = tile.x + self.centerpoint.x
        tile.y = tile.y + self.centerpoint.y
        tile.number = i
        --tile.toggle = false
        tile.radius = self.tileradius
        
        
        table.insert(self.board,tile)
    end
    
    self:ReferenceInit()
    
end

function HexBoard:ReferenceInit()
    --leftup, rightup, left, right, leftdown, rightdown
    local ref = {{0,0,0,2,5,6},{0,0,1,3,6,7},{0,0,2,4,7,8},{0,0,3,0,8,9},{0,1,0,6,10,11},{1,2,5,7,11,12},{2,3,6,8,12,13},{3,4,7,9,13,14},{4,0,8,0,14,15},{0,5,0,11,16,17},{5,6,10,12,17,18},{6,7,11,13,18,19},{7,8,12,14,19,20},{8,9,13,15,20,21},{9,0,14,0,21,22},{0,10,0,17,0,23},{10,11,16,18,23,24},{11,12,17,19,24,25},{12,13,18,20,25,26},{13,14,19,21,26,27},{14,15,20,22,27,28},{15,0,21,0,28,0},{16,17,0,24,0,29},{17,18,23,25,29,30},{18,19,24,26,30,31},{19,20,25,27,31,32},{20,21,26,28,32,33},{21,22,27,0,33,0},{23,24,0,30,0,34},{24,25,29,31,34,35},{25,26,30,32,35,36},{26,27,31,33,36,37},{27,28,32,0,37,0},{29,30,0,35,0,0},{30,31,34,36,0,0},{31,32,35,37,0,0},{32,33,36,0,0,0}} 
    
    for i = 1, 37 do
            self.board[i].leftup = self.board[ref[i][1]]
            self.board[i].rightup = self.board[ref[i][2]]
            self.board[i].left = self.board[ref[i][3]]
            self.board[i].right = self.board[ref[i][4]]
            self.board[i].leftdown = self.board[ref[i][5]]
            self.board[i].rightdown = self.board[ref[i][6]]
    end
end


function HexBoard:getTileByNumber(tile_number)
    return self.board[tile_number]
end


function HexBoard:getToggledTileNumber()
    for k, v in pairs(self.board) do
        if v:isToggled() == true then
            return k
        end
    end
    
    return FAILED
end


function HexBoard:ownNearNeutralTile(player, tile)
    local tiles = {}
    for i = 1, 6 do
        local near_tile = tile[NEAR_TILE[i]]
        if (near_tile ~= nil) and (near_tile.player == OWNER.NEUTRAL) then
            table.insert(tiles, near_tile)
        end
    end
    
    if #tiles > 0 then
        local selected_tile = tiles[math.random(1, #tiles)]
        selected_tile:ownThisTile(player)
    end
end


function HexBoard:updateTileOwner(current_player)
    --필라의 보드타일 점령에 관한 알고리즘을 작성
    for k, v in pairs(self.board) do
        if v.tile_object_type == TILE_OBJECT_TYPE.PILLAR then
            if v.tile_object_player == current_player then
                if v.player ~= v.tile_object_player then
                    v:ownThisTile(v.tile_object_player)
                elseif v.player == v.tile_object_player then
                    self:ownNearNeutralTile(v.player, v)
                end
            end
        end
    end
end


function HexBoard:updateTileEffect()
    for k, v in pairs(self.board) do
        if v.effect.HEXPROOF == true then
            v.effect.HEXPROOF = nil
        end
        if v.tile_object_name == "Terrain - Fire Place 1" then
            v:clearThisTileObject()
        end
    end
end


function HexBoard:draw()
    for k, v in pairs(self.board) do
        v:draw()
    end
end


function HexBoard:touched(touch)
    for k, v in pairs(self.board) do
        v:touched(touch)
    end
end
