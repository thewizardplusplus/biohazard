-- luacheck: no max comment line length

---
-- @classmod Size

local middleclass = require("middleclass")
local assertions = require("luatypechecks.assertions")
local Nameable = require("luaserialization.nameable")
local Stringifiable = require("luaserialization.stringifiable")
local Point = require("lualife.models.point")

local Size = middleclass("Size")
Size:include(Nameable)
Size:include(Stringifiable)

---
-- @table instance
-- @tfield int width [0, ∞)
-- @tfield int height [0, ∞)

---
-- @function new
-- @tparam int width [0, ∞)
-- @tparam int height [0, ∞)
-- @treturn Size
function Size:initialize(width, height)
  assertions.is_integer(width)
  assertions.is_integer(height)

  self.width = width
  self.height = height
end

---
-- @treturn tab table with instance fields
--   (see the [luaserialization](https://github.com/thewizardplusplus/luaserialization) library)
function Size:__data()
  return {
    width = self.width,
    height = self.height,
  }
end

---
-- @function __tostring
-- @treturn string stringified table with instance fields
--   (see the [luaserialization](https://github.com/thewizardplusplus/luaserialization) library)

---
-- @tparam Point point
-- @treturn bool
function Size:_contains(point)
  assertions.is_instance(point, Point)

  return point.x >= 0 and point.x <= self.width - 1
    and point.y >= 0 and point.y <= self.height - 1
end

---
-- @tparam Size other
-- @tparam[opt=(0 0)] Point self_offset
-- @treturn bool
function Size:_fits(other, self_offset)
  self_offset = self_offset or Point:new(0, 0)

  assertions.is_instance(other, Size)
  assertions.is_instance(self_offset, Point)

  return self_offset.x >= 0 and self_offset.x <= other.width - self.width
    and self_offset.y >= 0 and self_offset.y <= other.height - self.height
end

return Size
