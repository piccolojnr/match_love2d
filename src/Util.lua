function ternary(cond, T, F)
    if cond then return T else return F end
end

--- Calculates the score goal for a given level.
-- @param level The level for which to calculate the score goal.
-- @return The score goal for the given level.
function calculateScoreGoalForLevel(level)
    local baseScore = 1000 -- Base score goal for level 1
    local multiplier = 1.2 -- Multiplier for score goal increase per level

    return baseScore * (multiplier ^ (level - 1))
end

-- Calculates the time allowed for a given level.
-- @param level The level for which to calculate the time.
-- @return The calculated time in seconds.
function calculateTimeForLevel(level)
    local baseTime = 60  -- Base time for level 1 (in seconds)
    local increment = 10 -- Additional time per level

    return baseTime + (increment * (level - 1))
end

-- Returns the color set corresponding to the given level.
-- @param level The level for which to retrieve the color set.
-- @return The color set corresponding to the given level.
function getColorSetForLevel(level)
    if level <= 3 then
        return colorSets[1]
    elseif level <= 6 then
        return colorSets[2]
    elseif level <= 9 then
        return colorSets[3]
    elseif level <= 15 then
        return colorSets[4]
    elseif level <= 20 then
        return colorSets[5]
    else
        return colorSets[6]
    end
end

-- Computes the cumulative weights for a given set of weights.
-- @param weights The array of weight information.
-- @return cumulativeWeights The array of cumulative weights.
-- @return totalWeight The total weight of all the weight information.
-- Author: piccolo
function computeCumulativeWeights(weights)
    local cumulativeWeights = {}
    local totalWeight = 0

    for i, weightInfo in ipairs(weights) do
        totalWeight = totalWeight + weightInfo.weight
        table.insert(cumulativeWeights, { variety = weightInfo.variety, cumulativeWeight = totalWeight })
    end

    return cumulativeWeights, totalWeight
end

-- Selects a variety from a list of weighted options based on their cumulative weights.
-- @param cumulativeWeights A table containing the cumulative weights of each variety.
--                          Each entry should have a 'cumulativeWeight' field and a 'variety' field.
-- @param totalWeight The total weight of all the varieties.
-- @return The selected variety.
-- Author: piccolo
function weightedRandomSelection(cumulativeWeights, totalWeight)
    local randomValue = math.random() * totalWeight

    for i, weightInfo in ipairs(cumulativeWeights) do
        if randomValue <= weightInfo.cumulativeWeight then
            return weightInfo.variety
        end
    end
end

--[[
    GD50
    Match-3 Remake

    -- StartState Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Helper functions for writing Match-3.
]]

--[[
    Given an "atlas" (a texture with multiple sprites), as well as a
    width and a height for the tiles therein, split the texture into
    all of the quads by simply dividing it evenly.
]]
function GenerateQuads(atlas, tilewidth, tileheight)
    local sheetWidth = atlas:getWidth() / tilewidth
    local sheetHeight = atlas:getHeight() / tileheight

    local sheetCounter = 1
    local spritesheet = {}

    for y = 0, sheetHeight - 1 do
        for x = 0, sheetWidth - 1 do
            spritesheet[sheetCounter] =
                love.graphics.newQuad(x * tilewidth, y * tileheight, tilewidth,
                    tileheight, atlas:getDimensions())
            sheetCounter = sheetCounter + 1
        end
    end

    return spritesheet
end

--[[
    Given an "atlas" (a texture with multiple sprites), generate all of the
    quads for the different tiles therein, divided into tables for each set
    of tiles, since each color has 6 varieties.
]]
function GenerateTileQuads(atlas)
    local tiles = {}

    local x = 0
    local y = 0

    local counter = 1

    -- 9 rows of tiles
    for row = 1, 9 do
        -- two sets of 6 cols, different tile varietes
        for i = 1, 2 do
            tiles[counter] = {}

            for col = 1, 6 do
                table.insert(tiles[counter], love.graphics.newQuad(
                    x, y, 32, 32, atlas:getDimensions()
                ))
                x = x + 32
            end

            counter = counter + 1
        end
        y = y + 32
        x = 0
    end

    return tiles
end

--[[
    Recursive table printing function.
    https://coronalabs.com/blog/2014/09/02/tutorial-printing-table-contents/
]]
function print_r(t)
    local print_r_cache = {}

    local function sub_print_r(t, indent)
        if (print_r_cache[tostring(t)]) then
            print(indent .. "*" .. tostring(t))
        else
            print_r_cache[tostring(t)] = true

            if (type(t) == "table") then
                for pos, val in pairs(t) do
                    if (type(val) == "table") then
                        print(indent .. "[" .. pos .. "] => " .. tostring(t) .. " {")
                        sub_print_r(val, indent .. string.rep(" ", string.len(pos) + 8))
                        print(indent .. string.rep(" ", string.len(pos) + 6) .. "}")
                    elseif (type(val) == "string") then
                        print(indent .. "[" .. pos .. '] => "' .. val .. '"')
                    else
                        print(indent .. "[" .. pos .. "] => " .. tostring(val))
                    end
                end
            else
                print(indent .. tostring(t))
            end
        end
    end
    if (type(t) == "table") then
        print(tostring(t) .. " {")
        sub_print_r(t, "  ")
        print("}")
    else
        sub_print_r(t, "  ")
    end
    print()
end
