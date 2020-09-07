---
-- @classmod Rectangle

local middleclass = require("middleclass")
local types = require("lualife.types")
local Point = require("lualife.models.point")

local Rectangle = middleclass("Rectangle")

---
-- @table instance
-- @tfield lualife.models.Point minimum
-- @tfield lualife.models.Point maximum

---
-- @function new
-- @tparam lualife.models.Point minimum
-- @tparam lualife.models.Point maximum
-- @treturn Rectangle
function Rectangle:initialize(minimum, maximum)
  assert(types.is_instance(minimum, Point))
  assert(types.is_instance(maximum, Point))

  self.minimum = minimum
  self.maximum = maximum
end

---
-- @treturn number
function Rectangle:width()
  return self.maximum.x - self.minimum.x
end

---
-- @treturn number
function Rectangle:height()
  return self.maximum.y - self.minimum.y
end

return Rectangle
