local positions = {}

StartState = Class { __includes = BaseState }

function StartState:init()
    -- currently selected menu item
    self.currentMenuItem = 1

    self.stopTimers      = false

    -- colors we'll use to change the title text
    self.colors          = {
        [1] = { 217 / 255, 87 / 255, 99 / 255, 1 },
        [2] = { 95 / 255, 205 / 255, 228 / 255, 1 },
        [3] = { 251 / 255, 242 / 255, 54 / 255, 1 },
        [4] = { 118 / 255, 66 / 255, 138 / 255, 1 },
        [5] = { 153 / 255, 229 / 255, 80 / 255, 1 },
        [6] = { 223 / 255, 113 / 255, 38 / 255, 1 },
    }

    -- letters of MATCH 3 and their spacing relative to the center
    self.letterTable     = {
        { 'M', -108 },
        { 'A', -64 },
        { 'T', -28 },
        { 'C', 2 },
        { 'H', 40 },
        { '3', 112 },
    }

    -- time for a color change if it's been half a second
    self.colorTimer      = Timer.every(0.25, function()
        if self.stopTimers then
            return false
        end
        -- shift every color to the next, looping the last to front
        -- assign it to 0 do the loop below moves it to 1, default start
        self.colors[0] = self.colors[6]

        for i = 6, 1, -1 do
            self.colors[i] = self.colors[i - 1]
        end
    end)

    -- generate full table of tiles just for display
    for i = 1, 64 do
        table.insert(positions, gFrames['tiles'][math.random(18)][math.random(6)])
    end

    -- tile that will be moving accros the scree
    self.movingTileTimer = self:animateMovingTile()


    -- used to animate our fullscreen transition rect
    self.transitionAlpha = 0

    -- if we've selected an option, we need to pause input while we animate out
    self.pauseInput      = false
end

function StartState:update(dt)
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end

    -- as long as can still input, i.e., we're not in a transition...
    if not self.pauseInput then
        -- change menu selection
        if love.keyboard.wasPressed('up') or love.keyboard.wasPressed('down') then
            self.currentMenuItem = self.currentMenuItem == 1 and 2 or 1
            gSounds['select']:play()
        end

        -- switch to another state via one of the menu options
        if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
            if self.currentMenuItem == 1 then
                -- tween, using time, the transition rect's alpha to 1, then
                -- transition to the BeginGame state after the animation is over
                Timer.tween(1, {
                    [self] = { transitionAlpha = 1 }
                }):finish(function()
                    -- remove color timer and movingTile timer  from Timer
                    self.stopTimers = true

                    gStateMachine:change('begin-game', {
                        level = 1
                    })
                end)
            else
                love.event.quit()
            end

            -- turn off input during transition
            self.pauseInput = false
        end
    end
    -- update our Timer, which will be used for our fade transitions
    Timer.update(dt)
end

function StartState:render()
    -- render all tiles and their drop shadows
    for y = 1, 8 do
        for x = 1, 8 do
            local tile = positions[(y - 1) * x + x]
            if self.movingTile_x ~= x or self.movingTile_y ~= y then
                love.graphics.setColor(0, 0, 0, 1)
                love.graphics.draw(gTextures['main'], tile,
                    (x - 1) * 32 + 128 + 3, (y - 1) * 32 + 16 + 3)

                -- render tiles
                love.graphics.setColor(1, 1, 1, 1)
                love.graphics.draw(gTextures['main'], tile,
                    (x - 1) * 32 + 128, (y - 1) * 32 + 16)
            end
        end
    end

    -- render moving tile
    love.graphics.draw(gTextures['main'], self.movingTile, self.movingTileX, self.movingTileY)

    -- keep the background and tiles a little darker than normal
    love.graphics.setColor(0, 0, 0, 128 / 255)
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)

    self:drawMatch3Text(-60)
    self:drawOptions(12)

    -- draw our transition rect; is normally fully transparent, unless we're moving to a new state
    love.graphics.setColor(1, 1, 1, self.transitionAlpha)
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
end

function StartState:drawMatch3Text(y)
    -- draw semi-transparent rect behind Match 3
    love.graphics.setColor(1, 1, 1, 128 / 255)
    love.graphics.rectangle("fill", VIRTUAL_WIDTH / 2 - 76, VIRTUAL_HEIGHT / 2 + y - 15, 150, 58, 6)

    -- draw MATCH 3 text shadows
    love.graphics.setFont(gFonts['large'])
    self:drawTextShadow('MATCH 3', VIRTUAL_HEIGHT / 2 + y)

    -- print MATCH 3 letters in their corresponding current colors
    for i = 1, 6 do
        love.graphics.setColor(self.colors[i])
        love.graphics.printf(self.letterTable[i][1], 0, VIRTUAL_HEIGHT / 2 + y,
            VIRTUAL_WIDTH + self.letterTable[i][2], "center")
    end
end

--[[
    Draws "Start" and "Quit Game" text over semi-transparent rectangles.
]]
function StartState:drawOptions(y)
    -- draw rect behind start and quit game text
    love.graphics.setColor(1, 1, 1, 128 / 255)
    love.graphics.rectangle('fill', VIRTUAL_WIDTH / 2 - 76, VIRTUAL_HEIGHT / 2 + y, 150, 120, 6)

    -- draw Start text
    love.graphics.setFont(gFonts['medium'])
    self:drawTextShadow('Start', VIRTUAL_HEIGHT / 2 + y + 8 + 62)

    if self.currentMenuItem == 1 then
        love.graphics.setColor(99 / 255, 155 / 255, 1, 1)
    else
        love.graphics.setColor(48 / 255, 96 / 255, 130 / 255, 1)
    end

    love.graphics.printf('Start', 0, VIRTUAL_HEIGHT / 2 + y + 8 + 62, VIRTUAL_WIDTH, 'center')

    -- draw Quit Game text
    love.graphics.setFont(gFonts['medium'])
    self:drawTextShadow('Quit Game', VIRTUAL_HEIGHT / 2 + y + 33 + 62)

    if self.currentMenuItem == 2 then
        love.graphics.setColor(99 / 255, 155 / 255, 1, 1)
    else
        love.graphics.setColor(48 / 255, 96 / 255, 130 / 255, 1)
    end

    love.graphics.printf('Quit Game', 0, VIRTUAL_HEIGHT / 2 + y + 33 + 62, VIRTUAL_WIDTH, 'center')
end

function StartState:drawTextShadow(text, y)
    love.graphics.setColor(34 / 255, 32 / 255, 52 / 255, 1)
    love.graphics.printf(text, 2, y + 1, VIRTUAL_WIDTH, "center")
    love.graphics.printf(text, 1, y + 1, VIRTUAL_WIDTH, "center")
    love.graphics.printf(text, 0, y + 1, VIRTUAL_WIDTH, "center")
    love.graphics.printf(text, 1, y + 2, VIRTUAL_WIDTH, "center")
end

function StartState:animateMovingTile()
    tolerance              = 4
    self.movingTile_x      = math.random(8)
    self.movingTile_y      = math.random(8)
    self.movingTile        = positions[(self.movingTile_y - 1) * self.movingTile_x + self.movingTile_x]
    self.movingTile_OGX    = (self.movingTile_x - 1) * 32 + 128
    self.movingTileX       = (self.movingTile_x - 1) * 32 + 128 + tolerance
    self.movingTile_OGY    = (self.movingTile_y - 1) * 32 + 16
    self.movingTileY       = (self.movingTile_y - 1) * 32 + 16 + tolerance
    self.movingTileX_speed = 1.5
    self.movingTileY_speed = 2

    return Timer.every(0.01, function()
        if self.stopTimers then
            return false
        end
        speedx = self.movingTileX_speed
        speedy = self.movingTileY_speed

        -- Check if the tile is at the right or left edge, and reverse its horizontal speed
        if self.movingTileX >= VIRTUAL_WIDTH - 32 then
            self.movingTileX_speed = -math.abs(speedx)
        elseif self.movingTileX <= 0 then
            self.movingTileX_speed = math.abs(speedx)
        end

        -- Check if the tile is at the top or bottom edge, and reverse its vertical speed
        if self.movingTileY >= VIRTUAL_HEIGHT - 32 then
            self.movingTileY_speed = -math.abs(speedy)
        elseif self.movingTileY <= 0 then
            self.movingTileY_speed = math.abs(speedy)
        end

        -- Update x
        x = self.movingTileX + self.movingTileX_speed
        self.movingTileX = x

        -- Update y
        y = self.movingTileY + self.movingTileY_speed
        self.movingTileY = y

        if math.abs(self.movingTileX - self.movingTile_OGX) <= tolerance and
            math.abs(self.movingTileY - self.movingTile_OGY) <= tolerance then
            -- Stop the animation by returning false
            self.movingTileX = self.movingTile_OGX
            self.movingTileY = self.movingTile_OGY
            self:animateMovingTile()
            return false
        end
    end)
end
