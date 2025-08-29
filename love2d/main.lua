local Game = require("game")

local game = Game:new()

function love.load()
    -- screen config
    _G.cell_count = 20
    _G.cell_size = 32
    _G.screen_width = cell_count * cell_size
    _G.screen_height = cell_count * cell_size

    -- color
    _G.white = {255/255, 255/255, 255/255, 255/255}
    _G.green = {173/255, 204/255, 96/255, 255/255}
    _G.dark_green = {43/255, 51/255, 24/255, 255/255}

    love.window.setMode(screen_width, screen_height, {resizable = false})
    love.window.setTitle("Snake Game")
    love.graphics.setBackgroundColor(unpack(_G.green))
end

function love.update()
    game:update()
end

function love.keypressed(key)
    game:listen(key)
end

function love.draw()
    game:draw()
end
