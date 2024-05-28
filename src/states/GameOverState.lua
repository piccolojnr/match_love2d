--[[
    GD50
    Match-3 Remake

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    - GameOverState Class-

    State that simply shows us our score when we finally lose.
]]

GameOverState = Class { __includes = BaseState }

function GameOverState:init()

end

function GameOverState:enter(params)
    self.score = params.score
end

function GameOverState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('start')
    end
end

function GameOverState:render()
    love.graphics.setColor(0, 0, 0, 128 / 255)
    love.graphics.rectangle('fill', VIRTUAL_WIDTH / 2 - 64, 64, 128, 136, 4)
    love.graphics.setFont(gFonts['medium-large'])
    love.graphics.setColor(56, 56, 56, 234)
    love.graphics.printf('GAME OVER', VIRTUAL_WIDTH / 2 - 64, 74, 128, 'center')
    love.graphics.setFont(gFonts['medium'])
    love.graphics.setColor(99, 155, 255, 125)
    love.graphics.printf('Your Score: ' .. tostring(self.score), VIRTUAL_WIDTH / 2 - 64, 130, 128, 'center')
    love.graphics.printf('Press Enter', VIRTUAL_WIDTH / 2 - 64, 170, 128, 'center')
end
