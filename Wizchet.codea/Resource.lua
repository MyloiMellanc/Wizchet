Resource = class()

function Resource:init(player)
    self.player = player
    
    self.position = SUPPORT.PLAYER_RESOURCE_POSITION[self.player]
    self.font_size = SUPPORT.RESOURCE_FONT_SIZE
    
    self.max_mana = DEFAULT_MAX_MANA
    self.current_mana = DEFAULT_STARTING_MANA
    
end


function Resource:getCurrentMana()
    return self.current_mana
end


function Resource:spendMana(mana)
    if self.current_mana < mana then
        print("MANA SYSTEM ERROR!!")
        self.current_mana = 0
    else
        self.current_mana = self.current_mana - mana
    end
end


function Resource:addMana(mana)
    if self.current_mana + mana >= self.max_mana then
        self.current_mana = self.max_mana
    else
        self.current_mana = self.current_mana + mana
    end
end


function Resource:draw()

    pushStyle()
    
    fontSize(self.font_size)
    textMode(CENTER)
    
    fill(0, 39, 255, 255)
    text("MANA : "..self.current_mana.." / "..self.max_mana, 
                                        self.position.x, self.position.y)
    
    popStyle()
    
end


function Resource:touched(touch)
    --not used
end
