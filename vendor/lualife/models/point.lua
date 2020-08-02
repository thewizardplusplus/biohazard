---
-- @classmod Point

local middleclass = require("middleclass")

local Point = middleclass("Point")

---
-- @function new
-- @tparam number x
-- @tparam number y
-- @treturn Point
function Point:initialize(x, y)
  assert(type(x) == "number")
  assert(type(y) == "number")

  self.x = x
  self.y = y
end

---
-- @treturn string e.g. "(23, 42)"
function Point:__tostring()
  return string.format("(%g, %g)", self.x, self.y)
end

---
-- @tparam Point point
-- @treturn Point
function Point:translate(point)
  assert(point:isInstanceOf(Point))

  return Point:new(self.x + point.x, self.y + point.y)
end

---
-- @tparam number factor
-- @treturn Point
function Point:scale(factor)
  assert(type(factor) == "number")

  return Point:new(self.x * factor, self.y * factor)
end

return Point
