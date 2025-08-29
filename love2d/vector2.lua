local Vector2 = {}
Vector2.__index = Vector2

function Vector2:new(x, y)
    local obj = {}
    setmetatable(obj, self)
    obj.x = x or 0
    obj.y = y or 0
    return obj
end

Vector2.__add = function(v1, v2)
    return Vector2:new(v1.x + v2.x, v1.y + v2.y)
end

Vector2.__eq = function(v1, v2)
    return v1.x == v2.x and v1.y == v2.y
end

return Vector2
