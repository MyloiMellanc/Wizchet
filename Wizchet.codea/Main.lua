
function setup()

    displayMode(FULLSCREEN)
    
    --Support
    SUPPORT = Support()
    
    --Library
    initLibrary()
    --Objects for tile
    initObjects()
    
    --Game Board
    game_board = HexBoard()
    game_board:initBoard()
    
    --Turn State
    turn_state = TurnState(MAX_TURN)
    
    --Player2개
    local player_1 = Player(1)
    player_1:initPlayer1Deck()
    local player_2 = Player(2)
    player_2:initPlayer2Deck()


    --실제 Player 테이블
    game_player = {}
    table.insert(game_player, player_1)
    table.insert(game_player, player_2)
    
    --Stack
    stack = Stack()
    
    --Game
    game = Game(game_board, game_player, turn_state, stack)
    
    game:startGame()
end


function draw()
    background(SUPPORT.BACKGROUND_COLOR)
    
    game:draw()
    game_board:draw()
    
    turn_state:draw()
    
    game_player[1]:draw()
    game_player[2]:draw()
    
    stack:draw()
    
    drawLength()
    
end


function touched(touch)
    --print("touched "..touch.x..", "..touch.y)
    
    
    --작성요망
    --touched function of SubScreen
    
    
    --touched function of current player
    game_player[turn_state:getCurrentPlayer()]:touched(touch)
    
    
    
    --touched function of game board
    --이벤트 처리에 토글된 타일정보가 필요하기 때문에
    --언토글 처리를 하는 게임보드 터치함수를 가장 나중에 실행한다.
    
    game_board:touched(touch)
end
