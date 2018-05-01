Player = class()

function Player:init(player)
    self.player = player
    
    self.pillar_is_set = false
    
    self.supply_button = SupplyButton(player)
    self.resource = Resource(player)
    self.deck = Deck(player)
    
end


function Player:setPillarSet(pillar_is_set)
    self.pillar_is_set = pillar_is_set
end


function Player:isPillarSet()
    return self.pillar_is_set
end

function Player:spendItem(item_name)
    self.deck:spendItem(item_name)
end


-- 반드시 매 행동마다 실행되어야함
function Player:checkActivation(turn_player, turn_phase)
    self.supply_button:checkActivation(turn_player, turn_phase)
    
    local remain_mana = self.resource:getCurrentMana()
    self.deck:checkActivation
                    (turn_player, turn_phase, remain_mana, self.pillar_is_set)
end


function Player:draw()
    self.supply_button:draw()
    self.resource:draw()
    self.deck:draw()
end


function Player:touched(touch)
    self.supply_button:touched(touch)
    self.deck:touched(touch)
end



--------------------------------------------------

function Player:pushAbilityOnDeck(content_type, ability_name, position)
    if content_type == CONTENT_TYPE.PILLAR then
        local pillar = Pillar(self.player, ability_name)
        pillar:setPosition(position)
        self.deck:addContent(pillar)
        
    elseif content_type == CONTENT_TYPE.SPELL then
        local spell = Spell(self.player, ability_name)
        spell:setPosition(position)
        self.deck:addContent(spell)
        
    elseif content_type == CONTENT_TYPE.ITEM then
        local item = Item(self.player, ability_name)
        item:setPosition(position)
        self.deck:addContent(item)
        
    end
    
end






---------------------------------------------------------


function Player:initPlayer1Deck()
    local ability_position = {}
    ability_position.x = SUPPORT.PLAYER_DECK_FIRST_POSITION[1].x
    ability_position.y = SUPPORT.PLAYER_DECK_FIRST_POSITION[1].y
    local diff = SUPPORT.DECK_ABILITY_DIFF
    
    self:pushAbilityOnDeck(CONTENT_TYPE.PILLAR, "Pillar - Default 1", 
                                                ability_position)
    
    ability_position.x = ability_position.x + diff.x
    self:pushAbilityOnDeck(CONTENT_TYPE.SPELL, "Spell - Attack 1", 
                                                ability_position)
    
    ability_position.x = ability_position.x + diff.x
    self:pushAbilityOnDeck(CONTENT_TYPE.SPELL, "Spell - Moving 1 : Main", 
                                                ability_position)
    
    ability_position.x = ability_position.x + diff.x
    self:pushAbilityOnDeck(CONTENT_TYPE.SPELL, "Spell - Moving 2 : Counter", 
                                                ability_position)
    
    
    ability_position.x = SUPPORT.PLAYER_DECK_FIRST_POSITION[1].x
    ability_position.y = SUPPORT.PLAYER_DECK_FIRST_POSITION[1].y
    ability_position.y = ability_position.y + diff.y
    self:pushAbilityOnDeck(CONTENT_TYPE.SPELL, "Spell - Hexproof 1", 
                                                ability_position)
    
    ability_position.x = ability_position.x + diff.x
    self:pushAbilityOnDeck(CONTENT_TYPE.SPELL, "Spell - Purify 1", 
                                                ability_position)
    
end


function Player:initPlayer2Deck()
    local ability_position = {}
    ability_position.x = SUPPORT.PLAYER_DECK_FIRST_POSITION[2].x
    ability_position.y = SUPPORT.PLAYER_DECK_FIRST_POSITION[2].y
    local diff = SUPPORT.DECK_ABILITY_DIFF
    
    self:pushAbilityOnDeck(CONTENT_TYPE.PILLAR, "Pillar - Default 2", 
                                                ability_position)
    
    ability_position.x = ability_position.x + diff.x
    self:pushAbilityOnDeck(CONTENT_TYPE.SPELL, "Spell - Attack 1",
                                                ability_position)

    ability_position.x = ability_position.x + diff.x
    self:pushAbilityOnDeck(CONTENT_TYPE.SPELL, "Spell - Moving 1 : Main",
                                                ability_position)
    
    ability_position.x = ability_position.x + diff.x
    self:pushAbilityOnDeck(CONTENT_TYPE.SPELL, "Spell - Moving 2 : Counter",
                                                ability_position)
    
    ability_position.x = SUPPORT.PLAYER_DECK_FIRST_POSITION[2].x
    ability_position.y = SUPPORT.PLAYER_DECK_FIRST_POSITION[2].y
    ability_position.y = ability_position.y + diff.y
    self:pushAbilityOnDeck(CONTENT_TYPE.SPELL, "Spell - Hexproof 1",
                                                ability_position)
    
    ability_position.x = ability_position.x + diff.x
    self:pushAbilityOnDeck(CONTENT_TYPE.SPELL, "Spell - Purify 1", 
                                                ability_position)
    
    
    ability_position.x = ability_position.x + diff.x
    self:pushAbilityOnDeck(CONTENT_TYPE.ITEM, "Item - Mimic 1",
                                                ability_position)
end

