local Vector2 = require("vector2")

local Snake = {}
Snake.__index = Snake

function Snake:new()
    local obj = {}
    setmetatable(obj, self)
    obj.direction = Vector2:new(1, 0)
    obj.body = {Vector2:new(6, 9), Vector2:new(5, 9), Vector2:new(4, 9)}
    obj.add_segment = false
    return obj
end

function Snake:draw()
    love.graphics.setColor(unpack(_G.dark_green))
    local offset = 2
    for _, block in ipairs(self.body) do
        love.graphics.rectangle(
            "fill",
            block.x * _G.cell_size + offset,
            block.y * _G.cell_size + offset,
            _G.cell_size - offset * 2,
            _G.cell_size - offset * 2)
    end
end

function Snake:update()
    table.insert(self.body, 1, self.body[1] + self.direction)
    if self.add_segment then
        self.add_segment = false
    else
        table.remove(self.body)
    end
end

function Snake:reset()
    self.direction = Vector2:new(1, 0)
    self.body = {Vector2:new(6, 9), Vector2:new(5, 9), Vector2:new(4, 9)}
    self.add_segment = false
end

return Snake
