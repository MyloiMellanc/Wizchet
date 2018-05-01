


--데모 플레이용 덱 및 구성물들
--순서 : name, sprite, content, type, phase, func, item count(아이템만 해당), cost


library = {}


function initPillarLibrary()
    local normal_pillar_1 = {} 
    normal_pillar_1.name = "Pillar - Default 1"
    normal_pillar_1.sprite = "Space Art:Part Yellow Hull 2"
    normal_pillar_1.content = CONTENT_TYPE.PILLAR
    normal_pillar_1.type = ABILITY_TYPE.PILLAR
    normal_pillar_1.phase = ABILITY_PHASE.MAIN
    normal_pillar_1.func = effect_pillar_1
    normal_pillar_1.cost = 0
    
    local normal_pillar_2 = {} 
    normal_pillar_2.name = "Pillar - Default 2"
    normal_pillar_2.sprite = "Space Art:Part Red Hull 1"
    normal_pillar_2.content = CONTENT_TYPE.PILLAR
    normal_pillar_2.type = ABILITY_TYPE.PILLAR
    normal_pillar_2.phase = ABILITY_PHASE.MAIN
    normal_pillar_2.func = effect_pillar_2
    normal_pillar_2.cost = 0
    
    table.insert(library, normal_pillar_1)
    table.insert(library, normal_pillar_2)
end


function initSpellLibrary()
    local attack_spell_1 = {}
    attack_spell_1.name = "Spell - Attack 1"
    attack_spell_1.sprite = "Space Art:Red Explosion"
    attack_spell_1.content = CONTENT_TYPE.SPELL
    attack_spell_1.type = ABILITY_TYPE.CONFLICT
    attack_spell_1.phase = ABILITY_PHASE.MAIN
    attack_spell_1.func = effect_attack_1
    attack_spell_1.cost = 30
    
    local moving_spell_1 = {}
    moving_spell_1.name = "Spell - Moving 1 : Main"
    moving_spell_1.sprite = "Platformer Art:Battor Flap 1"
    moving_spell_1.content = CONTENT_TYPE.SPELL
    moving_spell_1.type = ABILITY_TYPE.MAIN
    moving_spell_1.phase = ABILITY_PHASE.MAIN
    moving_spell_1.func = effect_moving_1
    moving_spell_1.cost = 40
    
    local moving_spell_2 = {}
    moving_spell_2.name = "Spell - Moving 2 : Counter"
    moving_spell_2.sprite = "Platformer Art:Battor Dead"
    moving_spell_2.content = CONTENT_TYPE.SPELL
    moving_spell_2.type = ABILITY_TYPE.COUNTER
    moving_spell_2.phase = ABILITY_PHASE.CONFLICT
    moving_spell_2.func = effect_moving_2
    moving_spell_2.cost = 50
    
    local hexproof_spell_1 = {}
    hexproof_spell_1.name = "Spell - Hexproof 1"
    hexproof_spell_1.sprite = "Space Art:Green Explosion"
    hexproof_spell_1.content = CONTENT_TYPE.SPELL
    hexproof_spell_1.type = ABILITY_TYPE.COUNTER
    hexproof_spell_1.phase = ABILITY_PHASE.CONFLICT
    hexproof_spell_1.func = effect_hexproof_1
    hexproof_spell_1.cost = 50
    
    local purify_spell_1 = {}
    purify_spell_1.name = "Spell - Purify 1"
    purify_spell_1.sprite = "Tyrian Remastered:Evil Orb"
    purify_spell_1.content = CONTENT_TYPE.SPELL
    purify_spell_1.type = ABILITY_TYPE.MAIN
    purify_spell_1.phase = ABILITY_PHASE.MAIN
    purify_spell_1.func = effect_purify_1
    purify_spell_1.cost = 15
    
    table.insert(library, attack_spell_1)
    table.insert(library, moving_spell_1)
    table.insert(library, moving_spell_2)
    table.insert(library, hexproof_spell_1)
    table.insert(library, purify_spell_1)
    
end


function initItemLibrary()
    local mimic_item_1 = {}
    mimic_item_1.name = "Item - Mimic 1"
    mimic_item_1.sprite = "Tyrian Remastered:Bad Case"
    mimic_item_1.content = CONTENT_TYPE.ITEM
    mimic_item_1.type = ABILITY_TYPE.MAIN
    mimic_item_1.phase = ABILITY_PHASE.MAIN
    mimic_item_1.func = effect_mimic_1
    mimic_item_1.count = 1
    mimic_item_1.cost = 0
    
    table.insert(library, mimic_item_1)
    
end

function initSupplyLibrary()
    local default_supply_1 = {}
    default_supply_1.name = "Supply - Default"
    default_supply_1.content = CONTENT_TYPE.SUPPLY
    default_supply_1.type = ABILITY_TYPE.MAIN
    default_supply_1.phase = ABILITY_PHASE.MAIN
    default_supply_1.func = effect_default_supply_1
    
    local default_resolve_1 = {}
    default_resolve_1.name = "Resolve - Default"
    default_resolve_1.content = CONTENT_TYPE.SUPPLY
    default_resolve_1.type = ABILITY_TYPE.RESOLVE
    default_resolve_1.phase = ABILITY_PHASE.CONFLICT
    default_resolve_1.func = effect_default_resolve_1
    
    table.insert(library, default_supply_1)
    table.insert(library, default_resolve_1)
    
end


function initLibrary()
    initPillarLibrary()
    initSpellLibrary()
    initItemLibrary()
    initSupplyLibrary()
end


function getAbility(ability_name)
    for k, v in pairs(library) do
        if v.name == ability_name then
            return v
        end
    end
    
    return FAILED
end





