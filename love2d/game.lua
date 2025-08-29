local Food = require("food")
local Snake = require("snake")
local Vector2 = require("vector2")

local Game = {}
Game.__index = Game

function Game:new()
    local obj = {}
    setmetatable(obj, self)
    obj.running = false
    obj.snake = Snake:new()
    obj.food = Food:new()
    obj.score = 0
    return obj
end

local last_update_time = 0
local function event_triggered(internal)
    if love.timer.getTime() - last_update_time >= internal then
        last_update_time = love.timer.getTime()
        return true
    end
    return false
end

function Game:check_collision()
    -- Check collision with food
    if self.snake.body[1] == self.food.position then
        self.snake.add_segment = true
        self.food:relocate(self.snake.body)
        self.score = self.score + 1
        _G.eat_sound:play()
        return
    end

    local head = self.snake.body[1]

    -- Check collision with edges
    if head.x >= _G.cell_count or head.y >= _G.cell_count or
       head.x < 0 or head.y < 0 then
       self:over()
       return
   end
    
    -- Check collision with tail
    for i = 2, #self.snake.body do
        if head == self.snake.body[i] then
            self:over()
            return
        end
    end
end

function Game:update()
    if not self.running then return end
    if event_triggered(0.2) then
        self.snake:update()
        self:check_collision()
    end
end

function Game:listen(key)
    if not self.running then
        -- Start the game
        if key == "space" then self.running = true end
    else
        -- Change the direction of snake
        if key == "up" and self.snake.direction.y ~= 1 then
            self.snake.direction = Vector2:new(0, -1)
        end
        if key == "down" and self.snake.direction.y ~= -1 then
            self.snake.direction = Vector2:new(0, 1)
        end
        if key == "left" and self.snake.direction.x ~= 1 then
            self.snake.direction = Vector2:new(-1, 0)
        end
        if key == "right" and self.snake.direction.x ~= -1 then
            self.snake.direction = Vector2:new(1, 0)
        end
    end
end

function Game:draw()
    love.graphics.setColor(unpack(_G.green))
    love.graphics.rectangle(
        "fill", 
        _G.offset,
        _G.offset,
        _G.cell_count * _G.cell_size,
        _G.cell_count * _G.cell_size)
    self.snake:draw()
    self.food:draw()

    love.graphics.setColor(unpack(_G.red))
    love.graphics.setFont(_G.mid_font)
    love.graphics.print(string.format("score: %d", self.score), _G.offset, 0)

    if not self.running then
        local time = love.timer.getTime()
        local alpha = 0.5 + 0.5 * math.sin(time * 3)
        
        local text = "Press <space> to start..."
        local text_width = _G.big_font:getWidth(text)
        local text_height = _G.big_font:getHeight()
        local x = (_G.screen_width - text_width) / 2
        local y = (_G.screen_height - text_height) / 2
        
        love.graphics.setColor(1, 1, 1, alpha)
        love.graphics.setFont(_G.big_font)
        love.graphics.print(text, _G.offset + x, _G.offset + y)
    end
end

function Game:over()
    self.snake:reset()
    self.running = false
    self.score = 0
    _G.over_sound:play()
end

return Game
