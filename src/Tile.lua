Tile = Class {}

function Tile:init(x, y, color, variety)
    -- board positions
    self.gridX = x
    self.gridY = y

    -- coordinate positions
    self.x = (self.gridX - 1) * 32
    self.y = (self.gridY - 1) * 32

    -- tile appearance/points
    self.color = color
    self.variety = variety
    self.points = tilePoints[tileVarieties[variety]]

    self.shiny = math.random(100) == 1 and true or false
    self.tileFrame = gFrames['tiles'][self.color][self.variety]
end

function Tile:render(x, y)
    -- draw shadow
    love.graphics.setColor(34, 32, 52, 122)
    love.graphics.draw(gTextures['main'], self.tileFrame,
        self.x + x + 2, self.y + y + 2)

    -- draw tile itself
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.draw(gTextures['main'], self.tileFrame,
        self.x + x, self.y + y)
end
