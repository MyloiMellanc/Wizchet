
--검색 함수에서 리턴하는 실패값
FAILED = -1

--used in SupplyEvent
TILE_IS_NOT_TOGGLED = -1

--used in Turn State
MAX_TURN = -1

--Turn State
--턴 페이즈 상태
TURN_PHASE = {MAIN = 1,
              CONFLICT = 2 }

--플레이어별 최대 마나 보유량 및 초기량
DEFAULT_MAX_MANA = 100
DEFAULT_STARTING_MANA = 10



----------------------------------------------------
--수급 버튼의 사용 용도
SUPPLY_BUTTON = {SUPPLY = 1,
                 RESOLVE = 2 }


----------------------------------------------------
--어빌리티 속성

--Ability Phase
--어빌리티 사용가능한 턴 상태
ABILITY_PHASE = {MAIN = 1,
                 CONFLICT = 2 }
                 --MAIN_AND_CONFLICT = 3 
                    --걍 나중에 오브젝트 속성을 배열로 만들어...


--Ability Return Type
--스펠 함수포인터에서 리턴하는 타입
RETURN_TYPE = {RESOLVE = 1,     --턴 계속 진행
               NEXT_TURN = 2,   --턴 넘기기
               CONFLICT = 3 }   --갈등상태로 돌입


--Content Type
--컨텐츠 타입 - 게임에 사용되는 컨텐츠 유형
CONTENT_TYPE = {PILLAR = 1,
                SPELL = 2,
                ITEM = 3,
                SUPPLY = 4 }    --수급 버튼 전용



--Ability Type
--어빌리티의 타입 - 턴 진행에 관련된 색상을 표현한다.
ABILITY_TYPE = {PILLAR = 1, 
                MAIN = 2, 
                COUNTER = 3, 
                CONFLICT = 4 }


--Ability Color
--어빌리티 색상
ABILITY_COLOR = {PILLAR = color(0, 255, 0, 255)   ,
                 MAIN = color(255, 255, 0, 255)   ,
                 COUNTER = color(0, 0, 255, 255)   ,
                 CONFLICT = color(255, 0, 0, 255)   }



--타입에 맞는 타일컬러 리턴
function setTypeColor(ability_type)
    
    local type_color = color(0,0,0,0)
    
    if ability_type == ABILITY_TYPE.PILLAR then
        type_color = ABILITY_COLOR.PILLAR
    elseif ability_type == ABILITY_TYPE.MAIN then
        type_color = ABILITY_COLOR.MAIN
    elseif ability_type == ABILITY_TYPE.COUNTER then
        type_color = ABILITY_COLOR.COUNTER
    elseif ability_type == ABILITY_TYPE.CONFLICT then
        type_color = ABILITY_COLOR.CONFLICT
    end
    
    return type_color
    
end


----------------------------------------------------
--타일관련 속성

--타일의 주변타일 검색용 배열
NEAR_TILE = {"leftup", "left", "leftdown", "rightup", "right", "rightdown"}


--타일 점령자 - 다른 곳에도 사용 가능
OWNER = {NEUTRAL = 0,
         PLAYER_1 = 1,
         PLAYER_2 = 2 }


--타일 위에 있는 오브젝트의 타입
TILE_OBJECT_TYPE = {NOT_EXIST = 0,
                    PILLAR = 1,
                    ITEM = 2,
                    TERRAIN = 3 }


--점령자에 따른 색상값
TILE_COLOR = {NEUTRAL = color(187, 187, 187, 255)  ,
              PLAYER_1 = color(255, 255, 0, 100)  ,
              PLAYER_2 = color(225, 0, 0, 100)   }


----------------------------------------------------
--드로잉 서포트용 클래스

Support = class()

function Support:init()
    
    --Background Color
    self.BACKGROUND_COLOR = color(26, 26, 26, 255)
    
    --Check Length
    self.LENGTH_DRAWING = false
    
    --HexBoard
    self.HEXBOARD_CENTER_POSITION = vec2(WIDTH / 2, HEIGHT / 2 + 180)
    self.HEXBOARD_TILE_COUNT = 37
    
    --Tile
    self.TILE_LENGTH = 110
    self.TILE_RADIUS = 75
    self.TILE_NUMBERING = true
    
    --Game
    --Game Text
    self.GAME_TEXT_POSITION = vec2(WIDTH / 2, 310)
    
    --Score Board
    self.SCORE_BOARD_POSITION = {vec2(70,940), vec2(700,940)}
    self.SCORE_BOARD_FONT_SIZE = 23
    
    --Turn State
    self.TURN_STATE_POSITION = vec2(WIDTH / 2, 340)
    self.TURN_STATE_FONT_SIZE = 24
    self.TURN_STATE_TEXT_DIFF = 150
    
    --Player
    --Supply Button
    self.PLAYER_SUPPLY_BUTTON_POSITION = {vec2(50, 500), vec2(720, 500)}
    self.SUPPLY_BUTTON_WIDTH = 80
    self.SUPPLY_BUTTON_HEIGHT = 80
    self.SUPPLY_BUTTON_RADIUS = 40
    self.SUPPLY_BUTTON_FONT_SIZE = 15
    
    
    --Resource
    self.PLAYER_RESOURCE_POSITION = {vec2(80, 430), vec2(690, 430)}
    self.RESOURCE_FONT_SIZE = 20
    
    --Deck
    self.PLAYER_DECK_FIRST_POSITION = {vec2(50,250), vec2(440,250)}
    self.DECK_ABILITY_DIFF = {x = 90, y = -100}
    
    --Ability
    self.ABILITY_RADIUS = 65
    self.ABILITY_RECT_WIDTH = 80
    self.ABILITY_RECT_HEIGHT = 80
    
    
    
end

function Support:draw()
    --not used
end

function Support:touched(touch)
    --not used
end


----------------------------------------------------

--화면에 격자 그리기
function drawLength()
    if SUPPORT.LENGTH_DRAWING == true then
        local y = 30
        local x = 50
        
        while x < WIDTH do
            fontSize(10)
            fill(127, 127, 127, 255)
            text(x, x,y)
            
            x = x + 50
        end
        
        
        y = 50
        
        while y < HEIGHT do
            
            fontSize(10)
            fill(127, 127, 127, 255)
            text(y, WIDTH/2, y)
            
            y = y + 50
        end
    end
end


