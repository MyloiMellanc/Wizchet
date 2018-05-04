ScoreBoard = class()

function ScoreBoard:init()
    self.player_score = {}
    self.player_score[1] = 0 
    self.player_score[2] = 0 
    
    self.player_position = {}
    self.player_position[1] = SUPPORT.SCORE_BOARD_POSITION[1]
    self.player_position[2] = SUPPORT.SCORE_BOARD_POSITION[2]
    
    self.font_size = SUPPORT.SCORE_BOARD_FONT_SIZE
end


function ScoreBoard:clearScore()
    self.player_score[1] = 0
    self.player_score[2] = 0
end


function ScoreBoard:updateScore(game_board)
    
    self:clearScore()
    
    local board = game_board.board
    
    for i = 1, SUPPORT.HEXBOARD_TILE_COUNT do
        if board[i].player == OWNER.PLAYER_1 then
            self.player_score[1] = self.player_score[1] + 1
        elseif board[i].player == OWNER.PLAYER_2 then
            self.player_score[2] = self.player_score[2] + 1
        end
    end
end


function ScoreBoard:draw()
    pushStyle()
    
    for i = 1, 2 do
        fill(255, 255, 255, 255)
        fontSize(self.font_size - 5)
        text("TILE OWNED", self.player_position[i].x, self.player_position[i].y)
        
        fill(255, 0, 0, 255)
        fontSize(self.font_size)
        text(self.player_score[i], self.player_position[i].x, 
                                             self.player_position[i].y - 35)
        
    end
    
    popStyle()
end


function ScoreBoard:touched(touch)

end


