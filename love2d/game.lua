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

function check_collision_with_food()
    if snake.body[1] == food.position then
        snake.add_segment = true
        food:relocate(snake)
    end
end

local function check_collision_with_edges()
end

local function check_collision_with_tail()
end

function Game:check_collision()
    -- Check collision with food
    if self.snake.body[1] == self.food.position then
        self.snake.add_segment = true
        self.food:relocate(self.snake.body)
    end

    local head = self.snake.body[1]

    -- Check collision with edges
    if head.x > _G.cell_count - 1 or head.y > _G.cell_count - 1 or
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
    -- Start the game
    if key == "space" then self.running = true end

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

function Game:draw()
    self.snake:draw()
    self.food:draw()
end

function Game:over()
    self.snake:reset()
    self.running = false
end

return Game
