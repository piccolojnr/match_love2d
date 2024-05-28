function saveGame()
    love.filesystem.write(SAVE_FILE, table.show(data, 'data'))
end

function loadGame()
    if love.filesystem.getInfo(SAVE_FILE) ~= nil then
        local data = love.filesystem.load(SAVE_FILE)
        data()
    else
        startFresh()
    end
end

function startFresh()
    data = {
        players = {
        },
        current_player = 1,
        leaderboard = {
        },
    }
    saveGame()
end

function addPlayer(name)
    table.insert(data.players, { name = name, highscore = 0 })
    saveGame()
end

function removePlayer(name)
    for i, player in ipairs(data.players) do
        if player.name == name then
            table.remove(data.players, i)
            saveGame()
            break
        end
    end
end

function updateHighscore(score)
    if score > data.players[data.current_player].highscore then
        data.players[data.current_player].highscore = score
        saveGame()
    end
end

function updateLeaderboard(score)
    table.insert(data.leaderboard, { name = data.players[data.current_player].name, score = score })
    table.sort(data.leaderboard, function(a, b) return a.score > b.score end)
    saveGame()
end
