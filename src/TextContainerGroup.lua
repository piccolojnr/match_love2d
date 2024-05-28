TextContainerGroup = Class {}

function TextContainerGroup:init(args)
    self.justifyContent = args.justifyContent or
        "center"                                  -- center, start, end, space-between, space-around, space-evenly
    self.alignItems = args.alignItems or "center" -- center, start, end
    self.direction = args.direction or "row"      -- row, column
    self.wrap = args.wrap or "wrap"               -- nowrap, wrap

    self.width = args.width or VIRTUAL_WIDTH
    self.height = args.height or VIRTUAL_HEIGHT

    self.x = args.x or 0
    self.y = args.y or 0

    self.gap = args.gap or 0

    self.textContainers = {}

    self.currentTextContainer = nil
end

function TextContainerGroup:addTextContainer(args)
    local textContainer = TextContainer(args)
    table.insert(self.textContainers, textContainer)
    self:updateTextContainers()
    if not self.currentTextContainer then
        self.currentTextContainer = textContainer
    end
    return textContainer
end

function TextContainerGroup:updateTextContainers()
    local totalWidth = 0
    local totalHeight = 0

    local maxWith = 0
    local maxHeight = 0

    local widths = {}
    local heights = {}

    for _, textContainer in ipairs(self.textContainers) do
        local width = textContainer.font:getWidth(textContainer.text)

        textContainer.width = math.min(width, self.width)

        totalWidth = totalWidth + textContainer.width + self.gap
        table.insert(widths, textContainer.width)

        textContainer.height = textContainer.font:getHeight() *
            math.ceil(width / textContainer.width)

        totalHeight = totalHeight + textContainer.height + self.gap
        table.insert(heights, textContainer.height)

        if textContainer.width > maxWith then
            maxWith = textContainer.width
        end
        if textContainer.height > maxHeight then
            maxHeight = textContainer.height
        end
    end

    totalWidth = totalWidth - self.gap   -- remove last gap
    totalHeight = totalHeight - self.gap -- remove last gap


    local xOffset = self:calculateOffset(self.width, ternary(self.direction == "column", maxWith, totalWidth),
        self.justifyContent)
    local yOffset = self:calculateOffset(self.height, ternary(self.direction == "row", maxHeight, totalHeight),
        self.alignItems)


    for i, textContainer in ipairs(self.textContainers) do
        textContainer.color = self.currentTextContainer == textContainer and textContainer.selectedColor or
            textContainer.unselectedColor
        if self.direction == "row" then
            textContainer.x = xOffset
            textContainer.y = yOffset
            textContainer.width = widths[i]
            xOffset = xOffset + widths[i] + self.gap
        elseif self.direction == "column" then
            textContainer.x = xOffset
            textContainer.y = yOffset
            textContainer.height = heights[i]
            yOffset = yOffset + heights[i] + self.gap
        end
    end
end

function TextContainerGroup:calculateOffset(totalSize, contentSize, alignment)
    if alignment == "start" then
        return 0
    elseif alignment == "center" then
        return (totalSize - contentSize) / 2
    elseif alignment == "end" then
        return totalSize - contentSize
    elseif alignment == "space-between" then
        -- handle specific logic for space-between, space-around, space-evenly if needed
        return 0 -- placeholder, you might need to implement specific logic here
    elseif alignment == "space-around" then
        -- handle specific logic for space-between, space-around, space-evenly if needed
        return 0 -- placeholder, you might need to implement specific logic here
    elseif alignment == "space-evenly" then
        -- handle specific logic for space-between, space-around, space-evenly if needed
        return 0 -- placeholder, you might need to implement specific logic here
    end
end

function TextContainerGroup:textinput(text)
    if text == "a" or text == "j" then
        return
    end
    self.currentTextContainer.text = self.currentTextContainer.text .. text
    self:updateTextContainers()
end

function TextContainerGroup:update(dt)
    for _, textContainer in ipairs(self.textContainers) do
        textContainer:update(dt)
    end

    if love.keyboard.wasPressed("backspace") then
        self.currentTextContainer.text = self.currentTextContainer.text:sub(1, -2)
        self:updateTextContainers()
    end

    if love.keyboard.wasPressed("tab") then
        local index = table.find(self.textContainers, self.currentTextContainer) or 1
        index = index + 1
        if index > #self.textContainers then
            index = 1
        end
        self.currentTextContainer = self.textContainers[index]
        self:updateTextContainers()
    end
end

function TextContainerGroup:render(x, y)
    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.rectangle("fill", x + self.x, y + self.y, self.width, self.height)

    for _, textContainer in ipairs(self.textContainers) do
        textContainer:render(x + self.x, y + self.y)
    end
end
