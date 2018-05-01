


--Custom Object는 능력들로 타일 위에 생성되는 무언가에 대한 라이브러리다.

--토글시 사용가능한 오브젝트는 func 함수포안터를 포함하고있다.

objects = {}


function initPillarObjects()
    local normal_pillar_1 = {} 
    normal_pillar_1.name = "Pillar - Default 1"
    normal_pillar_1.type = TILE_OBJECT_TYPE.PILLAR
    normal_pillar_1.sprite = "Space Art:Part Yellow Hull 2"
    normal_pillar_1.usable = false

    local normal_pillar_2 = {} 
    normal_pillar_2.name = "Pillar - Default 2"
    normal_pillar_2.type = TILE_OBJECT_TYPE.PILLAR
    normal_pillar_2.sprite = "Space Art:Part Red Hull 1"
    normal_pillar_2.usable = false
    
    table.insert(objects, normal_pillar_1)
    table.insert(objects, normal_pillar_2)
    
end


function initSpellObjects()
    --공격으로 생긴 분화구
    local fire_place_1 = {}
    fire_place_1.name = "Terrain - Fire Place 1"
    fire_place_1.type = TILE_OBJECT_TYPE.TERRAIN
    fire_place_1.sprite = "Tyrian Remastered:Explosion Huge"
    fire_place_1.usable = false
    
    table.insert(objects, fire_place_1)
end


function initItemObjects()
    local mimic_item_1 = {}
    mimic_item_1.name = "Item - mimic 1"
    mimic_item_1.type = TILE_OBJECT_TYPE.ITEM
    mimic_item_1.sprite = "Tyrian Remastered:Bad Case"
    mimic_item_1.usable = true
    mimic_item_1.func = activate_mimic_1
    
    table.insert(objects, mimic_item_1)
end


function initObjects()
    initPillarObjects()
    initSpellObjects()
    initItemObjects()
end


function getObject(object_name)
    for k,v in pairs(objects) do
        if v.name == object_name then
            return v
        end
    end
    
    return FAILED
end


------------------------------------------------------------
--타일 위에 있는 오브젝트 효과들

function activate_mimic_1(player, tile_number)
    local function effect(player, tile_number)
        local tile = game_board:getTileByNumber(tile_number)
        
        for i = 1, 6 do
            local near_tile = tile[NEAR_TILE[i]]
            
            if near_tile ~= nil then
                --near_tile:clearThisTile()
                near_tile:ownThisTile(OWNER.NEUTRAL)
            end
        end
        
        tile:clearThisTile()
        
        local game_text = "Mimic is activated."
        game:setGameText(game_text)
    end
    
     
    local ptr = effect
    stack:pushStack(player, ptr, tile_number)
    
    --액션 없음
    
    return RETURN_TYPE.RESOLVE
end

