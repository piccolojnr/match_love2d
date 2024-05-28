TestingState = Class { __includes = BaseState }

function TestingState:init()
    self.container = TextContainerGroup({
        direction = "column",
        justifyContent = "center",
        alignItems = "center",
        x = 16,
        y = 16,
        width = VIRTUAL_WIDTH - 16 * 2,
        height = VIRTUAL_HEIGHT - 16 * 2,
        gap = 16,
    })

    self.texts = {}
    table.insert(self.texts, self.container:addTextContainer({
        text = "Hello World!",
        font = gFonts['medium'],
        color = { 1, 1, 1, 1 },
        selectedColor = { 0, 1, 0, 1 },
        shadowColor = { 0, 0, 0, 1 },
        shadowOffsetX = 2,
        shadowOffsetY = 2,
        backgroundColor = { 1, 0, 0, 1 },
    }))
    for i = 1, 3 do
        table.insert(self.texts, self.container:addTextContainer({
            text = "Hello World!",
            font = gFonts['medium'],
            color = { 1, 1, 1, 1 },
            selectedColor = { 0, 1, 0, 1 },
            shadowColor = { 0, 0, 0, 1 },
            shadowOffsetX = 2,
            shadowOffsetY = 2,
            backgroundColor = { 1, 0, 0, 1 },
        }))
    end
end

function TestingState:enter(params)

end

function TestingState:textinput(text)
    self.container:textinput(text)
end

function TestingState:update(dt)
    self.container:update(dt)
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
    local alignments = {
        "start",
        "center",
        "end",
        -- "space-between",
        -- "space-around",
        -- "space-evenly",
    }
    if love.keyboard.wasPressed('a') then
        -- change container alignItems
        local index = table.find(alignments, self.container.alignItems) or 1
        index = index + 1
        if index > #alignments then
            index = 1
        end
        self.container.alignItems = alignments[index]
        self.container:updateTextContainers()
    end

    if love.keyboard.wasPressed('j') then
        -- change container justifyContent
        local index = table.find(alignments, self.container.justifyContent) or 1

        index = index + 1
        if index > #alignments then
            index = 1
        end
        self.container.justifyContent = alignments[index]
        self.container:updateTextContainers()
    end

    if love.keyboard.wasPressed('return') then
        -- change container direction
        if self.container.direction == "row" then
            self.container.direction = "column"
        else
            self.container.direction = "row"
        end
        self.container:updateTextContainers()
    end
end

function TestingState:render()
    self.container:render(0, 0)
end
