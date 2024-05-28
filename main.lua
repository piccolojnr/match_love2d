-- initialize our nearest-neighbour filter
love.graphics.setDefaultFilter('nearest', "nearest")

-- dependencies
require 'src/Dependencies'

-- physical screen dimensions
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- virtual resolution dimensions
VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

-- speed at which our background texture will scroll
BACKGROUND_SCROLL_SPEED = 80

function love.load()
    --window bar title
    love.window.setTitle('Match 3')

    -- seed the RNG
    math.randomseed(os.time())

    -- initialize our virtual resolution
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true,
        canvas = true
    })

    -- set music to loop and start
    gSounds['music']:setLooping(true)
    gSounds['music']:play()

    loadGame()

    -- initialize state machine with all state-returning functions
    gStateMachine = StateMachine {
        ['start'] = function() return StartState() end,
        ['begin-game'] = function() return BeginGameState() end,
        ['play'] = function() return PlayState() end,
        ['game-over'] = function() return GameOverState() end,
        ['testing'] = function() return TestingState() end
    }
    gStateMachine:change('start')

    --keep track of scrollong our background on the X axis
    backgroundX = 0

    -- inialize input table
    love.keyboard.keysPressed = {}
end

-- function love.resize(w, h)
--     love.resize(w, h)
-- end

function love.textinput(text)
    gStateMachine:textinput(text)
end

function love.keypressed(key)
    -- add to our table of keys pressed this frame
    love.keyboard.keysPressed[key] = true
end

function love.keyboard.wasPressed(key)
    if love.keyboard.keysPressed[key] then
        return true
    else
        return false
    end
end

function love.update(dt)
    --scroll background, used across all states
    backgroundX = backgroundX - BACKGROUND_SCROLL_SPEED * dt


    -- if we've scrolled the entire image, reset it to 0
    if backgroundX <= -1024 + VIRTUAL_WIDTH - 4 + 51 then
        backgroundX = 0
    end

    gStateMachine:update(dt)

    love.keyboard.keysPressed = {}
end

function love.draw()
    push:start()

    --scrolling background drawn behind every state
    love.graphics.draw(gTextures['background'], backgroundX, 0)

    gStateMachine:render()

    push:finish()
end
