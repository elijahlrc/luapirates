
--[[
Give me a docstring marcell!!!!!!!
--]]


-- Screen Config
_, _, flags = love.window.getMode()
WINDOW_WIDTH, WINDOW_HEIGHT = love.window.getDesktopDimensions(flags.display)
love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {fullscreen=true, resizable=false, vsync=true, minwidth=800, minheight=600})
love.window.setTitle("")

-- Tile Config
TILE_SIZE = 32
MAP_SIZE = 2048
TILES_ACROSS = math.ceil(WINDOW_WIDTH/TILE_SIZE)
TILES_DOWN = math.ceil(WINDOW_HEIGHT/TILE_SIZE)

-- Player Config
SHIP_OFFSET_X = 93
SHIP_OFFSET_Y = 35
START_X = math.floor(WINDOW_WIDTH/2)+1024*TILE_SIZE
START_Y = math.floor(WINDOW_HEIGHT/2)+1024*TILE_SIZE

START_ROTATION = 0
PLAYER_SPEED = 1.5
PLAYER_TURN_SPEED = math.pi*.5
PLAYER_DRAG = .007
PLAYER_VELOCITY = 0
PLAYER_MAX_HP = 100
PLAYER_RELOAD_RATE = .33
-- Math Config
RANDOM_SEED = tonumber(tostring(os.time()):reverse():sub(1,6))

-- Weather Config
WEATHER_SPEED = 10
STARTING_LIGHT = 0
WEATHER_DIRECTION = "down"
