---
-- @classmod Field

local middleclass = require("middleclass")
local Size = require("lualife.models.size")
local Point = require("lualife.models.point")

local function to_boolean(value)
  return value and true or false
end

local Field = middleclass("Field")

---
-- @function new
-- @tparam Size size
-- @treturn Field
function Field:initialize(size)
  assert(size:isInstanceOf(Size))

  self.size = size
  self.cells = {}
end

---
-- @tparam Point point
-- @treturn bool
function Field:contains(point)
  assert(point:isInstanceOf(Point))

  local contains = self.cells[tostring(point)]
  return to_boolean(contains)
end

---
-- @tparam Point point
function Field:set(point)
  assert(point:isInstanceOf(Point))

  self.cells[tostring(point)] = true
end

return Field
