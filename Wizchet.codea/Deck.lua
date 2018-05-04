Deck = class()

function Deck:init(player)
    self.player = player
    self.deck_max_contents = 8
    self.deck_contents = {}

end

function Deck:spendItem(item_name)
    for k, v in pairs(self.deck_contents) do
        if (v.content == CONTENT_TYPE.ITEM) and (v.name == item_name) then
            if v.item_count == 1 then
                table.remove(self.deck_contents, k)
            else
                v.item_count = v.item_count - 1
            end
        end
    end
end

function Deck:addContent(content)
    table.insert(self.deck_contents, content)
end


function Deck:checkActivation
                    (turn_player, turn_phase, remain_mana, pillar_is_set, set_count)
    for k,v in pairs(self.deck_contents) do
        v:updateActivation(turn_player, turn_phase, remain_mana, pillar_is_set, set_count)
    end
end


function Deck:draw()
    for i,v in pairs(self.deck_contents) do
        v:draw()
    end
end

function Deck:touched(touch)
    for i,v in pairs(self.deck_contents) do
        v:touched(touch)
    end
end

