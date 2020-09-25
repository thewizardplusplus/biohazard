---
-- @classmod Color

local middleclass = require("middleclass")
local types = require("lualife.types")

local Color = middleclass("Color")

---
-- @table instance
-- @tfield number red [0, 1]
-- @tfield number green [0, 1]
-- @tfield number blue [0, 1]

---
-- @function new
-- @tparam number red [0, 1]
-- @tparam number green [0, 1]
-- @tparam number blue [0, 1]
-- @treturn Color
function Color:initialize(red, green, blue)
  assert(types.is_number_with_limits(red, 0, 1))
  assert(types.is_number_with_limits(green, 0, 1))
  assert(types.is_number_with_limits(blue, 0, 1))

  self.red = red
  self.green = green
  self.blue = blue
end

---
-- @treturn {number,number,number}
--   red, green and blue values in the range [0, 1]
function Color:channels()
  return {self.red, self.green, self.blue}
end

return Color
