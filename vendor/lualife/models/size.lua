---
-- @classmod Size

local middleclass = require("middleclass")

local Size = middleclass("Size")

---
-- @function new
-- @tparam int width
-- @tparam int height
-- @treturn Size
function Size:initialize(width, height)
  assert(type(width) == "number")
  assert(type(height) == "number")

  self.width = width
  self.height = height
end

return Size
