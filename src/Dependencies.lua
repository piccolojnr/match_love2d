--
-- libraries
--
Class = require 'lib/class'

push = require 'lib/push'

-- used for timers and tweening
Timer = require 'lib/knife/timer'


show = require 'lib/show'
find = require 'lib/find'


--
-- our own code
--

-- Utility
require 'src/StateMachine'
require 'src/Util'
require 'src.data'

-- game pieces
require 'src/Board'
require 'src/Tile'

-- game states
require 'src/states/BaseState'
require 'src/states/BeginGameState'
require 'src/states/GameOverState'
require 'src/states/PlayState'
require 'src/states/StartState'
require 'src/states/TestingState'

-- game design
require "src/TextContainer"
require "src/TextContainerGroup"

-- Constants
SAVE_FILE = 'save.lua'


-- Define color sets for different difficulty levels
colorSets = {
    -- Level 1-3: Most distinguishable colors
    {
        '#dfab71', -- peach
        '#34946c', -- teal
        '#78c63c', -- lime
        '#647ee1', -- blue
        '#ce5147', -- red
    },
    -- Level 4-6: Add slightly similar colors
    {
        '#dfab71', -- peach
        '#34946c', -- teal
        '#78c63c', -- lime
        '#647ee1', -- blue
        '#ce5147', -- red
        '#4c4937', -- dark olive
        '#306082', -- navy
    },
    -- Level 7-9: Add more similar colors
    {
        '#dfab71', -- peach
        '#34946c', -- teal
        '#78c63c', -- lime
        '#647ee1', -- blue
        '#ce5147', -- red
        '#4c4937', -- dark olive
        '#306082', -- navy
        '#d28bc6', -- lavender
        '#8f563b', -- brown
    },
    -- Level 10 - 15: Include the most similar colors
    {
        '#dfab71', -- peach
        '#34946c', -- teal
        '#78c63c', -- lime
        '#647ee1', -- blue
        '#ce5147', -- red
        '#4c4937', -- dark olive
        '#306082', -- navy
        '#d28bc6', -- lavender
        '#8f563b', -- brown
        '#595652', -- gray
        '#696a6a', -- dark gray
        '#847e87', -- grayish purple
    },
    -- Level 16-20: Include more similar colors
    {
        '#dfab71',
        '#34946c',
        '#78c63c',
        '#647ee1',
        '#ce5147',
        '#4c4937',
        '#306082',
        '#d28bc6',
        '#8f563b',
        '#595652',
        '#696a6a',
        '#847e87',
        '#d95763',
        '#ac3232',
        '#663931',
        '#df7126',
    },
    -- Level 21-25: Include all colors
    {
        '#dfab71',
        '#8c5f38',
        '#4c4937',
        '#34946c',
        '#78c63c',
        '#647ee1',
        '#306082',
        '#575480',
        '#d28bc6',
        '#ce5147',
        '#d95763',
        '#ac3232',
        '#663931',
        '#8f563b',
        '#df7126',
        '#847e87',
        '#696a6a',
        '#595652',
    }
}


tileColors = {
    ['#dfab71'] = 1,
    ['#8c5f38'] = 2,
    ['#4c4937'] = 3,
    ['#34946c'] = 4,
    ['#78c63c'] = 5,
    ['#647ee1'] = 6,
    ['#306082'] = 7,
    ['#575480'] = 8,
    ['#d28bc6'] = 9,
    ['#ce5147'] = 10,
    ['#d95763'] = 11,
    ['#ac3232'] = 12,
    ['#663931'] = 13,
    ['#8f563b'] = 14,
    ['#df7126'] = 15,
    ['#847e87'] = 16,
    ['#696a6a'] = 17,
    ['#595652'] = 18,
}


tileVarieties = {
    'plain',
    'cross',
    'circle',
    'square',
    'triangle',
    'star',
}


tilePoints         = {
    plain = 40,
    cross = 50,
    circle = 60,
    square = 70,
    triangle = 80,
    star = 100
}

tileVarietyWeights = {
    { variety = 1, weight = 50 }, -- 50 occurrences of plain
    { variety = 2, weight = 25 }, -- 25 occurrences of cross
    { variety = 3, weight = 15 }, -- 15 occurrences of circle
    { variety = 4, weight = 7 },  -- 7 occurrences of square
    { variety = 5, weight = 3 },  -- 3 occurrences of triangle
    { variety = 6, weight = 1 }   -- 1 occurrence of star
}


gSounds   = {
    ['music'] = love.audio.newSource('sounds/music3.mp3', 'static'),
    ['select'] = love.audio.newSource('sounds/select.wav', 'static'),
    ['error'] = love.audio.newSource('sounds/error.wav', 'static'),
    ['match'] = love.audio.newSource('sounds/match.wav', 'static'),
    ['clock'] = love.audio.newSource('sounds/clock.wav', 'static'),
    ['game-over'] = love.audio.newSource('sounds/game-over.wav', 'static'),
    ['next-level'] = love.audio.newSource('sounds/next-level.wav', 'static')
}

gTextures = {
    ['main'] = love.graphics.newImage('graphics/match3.png'),
    ['background'] = love.graphics.newImage('graphics/background.png')
}

gFrames   = {
    -- divided into sets for each tile type in this game, instead of one
    -- table of quads
    ['tiles'] = GenerateTileQuads(gTextures['main'])
}

gFonts    = {
    ['small'] = love.graphics.newFont('fonts/font.ttf', 8),
    ['medium'] = love.graphics.newFont('fonts/font.ttf', 16),
    ['medium-large'] = love.graphics.newFont('fonts/font.ttf', 24),
    ['large'] = love.graphics.newFont('fonts/font.ttf', 32)

}
