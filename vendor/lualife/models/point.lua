---
-- @classmod Point

local middleclass = require("middleclass")

local Point = middleclass("Point")

---
-- @function new
-- @tparam int x
-- @tparam int y
-- @treturn Point
function Point:initialize(x, y)
  assert(type(x) == "number")
  assert(type(y) == "number")

  self.x = x
  self.y = y
end

---
-- @treturn string
function Point:__tostring()
  return string.format("(%d, %d)", self.x, self.y)
end

---
-- @tparam Point point
-- @treturn Point
function Point:translate(point)
  assert(point:isInstanceOf(Point))

  return Point:new(self.x + point.x, self.y + point.y)
end

---
-- @tparam Point point
-- @treturn Point
function Point:scale(point)
  assert(point:isInstanceOf(Point))

  return Point:new(self.x * point.x, self.y * point.y)
end

return Point
