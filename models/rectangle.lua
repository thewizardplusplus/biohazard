-- luacheck: no max comment line length

---
-- @classmod Rectangle

local middleclass = require("middleclass")
local assertions = require("luatypechecks.assertions")
local Nameable = require("luaserialization.nameable")
local Stringifiable = require("luaserialization.stringifiable")
local Point = require("lualife.models.point")

local Rectangle = middleclass("Rectangle")
Rectangle:include(Nameable)
Rectangle:include(Stringifiable)

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
  assertions.is_instance(minimum, Point)
  assertions.is_instance(maximum, Point)

  self.minimum = minimum
  self.maximum = maximum
end

---
-- @treturn tab table with instance fields
--   (see the [luaserialization](https://github.com/thewizardplusplus/luaserialization) library)
function Rectangle:__data()
  return {
    minimum = self.minimum,
    maximum = self.maximum,
  }
end

---
-- @function __tostring
-- @treturn string stringified table with instance fields
--   (see the [luaserialization](https://github.com/thewizardplusplus/luaserialization) library)

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
