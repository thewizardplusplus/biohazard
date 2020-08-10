---
-- @classmod Size

local middleclass = require("middleclass")
local Point = require("lualife.models.point")

local Size = middleclass("Size")

---
-- @function new
-- @tparam int width [0, ∞)
-- @tparam int height [0, ∞)
-- @treturn Size
function Size:initialize(width, height)
  assert(type(width) == "number")
  assert(type(height) == "number")

  self.width = width
  self.height = height
end

---
-- @tparam Size other
-- @tparam Point offset
-- @treturn bool
function Size:contains(other, offset)
  assert(other:isInstanceOf(Size))
  assert(offset:isInstanceOf(Point))

  return offset.x >= 0 and offset.x <= self.width - other.width
    and offset.y >= 0 and offset.y <= self.height - other.height
end

return Size
