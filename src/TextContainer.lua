TextContainer = Class {}

-- Initializes a new instance of the TextContainer class.
-- @param args (table) A table containing the initialization arguments.
function TextContainer:init(args)
    self.x = args.x or 0
    self.y = args.y or 0
    self.text = args.text or ""
    self.font = args.font or love.graphics.getFont()
    self.width = args.width or self.font:getWidth(self.text)
    self.height = args.height or self.font:getHeight() * math.ceil(self.font:getWidth(self.text) / self.width)
    self.color = args.color or { 1, 1, 1, 1 }
    self.selectedColor = args.selectedColor or { 1, 0, 0, 1 }
    self.unselectedColor = args.color or { 1, 1, 1, 1 }
    self.align = args.align or "center"
    self.shadowColor = args.shadowColor or nil
    self.shadowOffsetX = args.shadowOffsetX or 1
    self.shadowOffsetY = args.shadowOffsetY or 1
    self.display = args.display or "relative"
    self.backgroundColor = args.backgroundColor or { 0, 0, 0, 128 / 255 }
    self.padding = args.padding or 0
end

-- Updates the text container.
-- @param dt (number) The time that has passed since the last frame.
function TextContainer:update(dt)
    -- Placeholder for any update logic
end

-- Renders the text within the container.
-- @param x (number) The x-coordinate offset for rendering.
-- @param y (number) The y-coordinate offset for rendering.
function TextContainer:render(x, y)
    -- Draw the background
    love.graphics.setColor(self.backgroundColor)
    love.graphics.rectangle("fill", x + self.x, y + self.y, self.width, self.height)

    -- Set the font for rendering
    love.graphics.setFont(self.font)

    -- Draw shadow if applicable
    if self.shadowColor then
        self:drawTextShadow(self.text, x + self.x, y + self.y)
    end

    -- Draw the text
    love.graphics.setColor(self.color)
    love.graphics.printf(self.text, x + self.x + self.padding, y + self.y + self.padding, self.width - 2 * self.padding,
        self.align)
end

-- Draws the text shadow.
-- @param text (string) The text to be rendered with a shadow.
-- @param x (number) The x-coordinate offset for rendering.
-- @param y (number) The y-coordinate offset for rendering.
function TextContainer:drawTextShadow(text, x, y)
    love.graphics.setColor(self.shadowColor)
    love.graphics.printf(text, x + self.shadowOffsetX + self.padding, y + self.shadowOffsetY + self.padding,
        self.width - 2 * self.padding, self.align)
end
