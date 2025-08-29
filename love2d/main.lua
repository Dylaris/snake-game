local Game = require("game")

local game = Game:new()

function love.load()
    -- screen
    _G.cell_count    = 20
    _G.cell_size     = 32
    _G.screen_width  = cell_count * cell_size
    _G.screen_height = cell_count * cell_size
    _G.offset        = _G.cell_size

    -- font
    _G.big_font = love.graphics.newFont(32)
    _G.mid_font = love.graphics.newFont(24)
    _G.sml_font = love.graphics.newFont(12)

    -- sound
    _G.eat_sound  = love.audio.newSource("assets/eat.mp3", "static") 
    _G.over_sound = love.audio.newSource("assets/over.mp3", "static") 

    -- color
    _G.white      = {255/255, 255/255, 255/255, 255/255}
    _G.red        = {255/255,   0/255,   0/255, 255/255}
    _G.gray       = { 32/255,  32/255,  32/255, 255/255}
    _G.green      = {173/255, 204/255,  96/255, 255/255}
    _G.dark_green = { 43/255,  51/255,  24/255, 255/255}

    love.window.setMode(
        _G.screen_width+2*_G.offset,
        _G.screen_height+2*_G.offset,
        {resizable = false})
    love.window.setTitle("Snake Game")
    love.graphics.setBackgroundColor(unpack(_G.gray))
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
