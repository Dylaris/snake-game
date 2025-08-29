local Vector2 = require("vector2")

local Food = {}
Food.__index = Food

function Food:new()
    local obj = {}
    setmetatable(obj, self)
    obj.position = Vector2:new(5, 6)
    obj.image = love.graphics.newImage("assets/food.png")
    return obj
end

function Food:draw()
    love.graphics.setColor(unpack(_G.white))
    love.graphics.draw(
        self.image,
        self.position.x * _G.cell_size,
        self.position.y * _G.cell_size)
end

local function generate_random_cell()
    local x = math.random(0, _G.cell_count - 1)
    local y = math.random(0, _G.cell_count - 1)
    return Vector2:new(x, y)
end

local function position_in_vectors(pos, vectors)
    for vec in ipairs(vectors) do
        if vec == position then
            return true
        end
    end
    return false
end

function Food:relocate(vectors)
    local position = generate_random_cell()
    while position_in_vectors(position, vectors) do
        position = generate_random_cell()
    end
    self.position = position
end

return Food
