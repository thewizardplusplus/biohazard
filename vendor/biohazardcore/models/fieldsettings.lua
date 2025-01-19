-- luacheck: no max comment line length

---
-- @classmod FieldSettings

local middleclass = require("middleclass")
local assertions = require("luatypechecks.assertions")
local Nameable = require("luaserialization.nameable")
local Stringifiable = require("luaserialization.stringifiable")
local Size = require("lualife.models.size")
local Point = require("lualife.models.point")

local FieldSettings = middleclass("FieldSettings")
FieldSettings:include(Nameable)
FieldSettings:include(Stringifiable)

---
-- @table instance
-- @tfield lualife.models.Size size
-- @tfield lualife.models.Point initial_offset
-- @tfield number filling [0, 1]
-- @tfield int minimal_count [0, size.width * size.height]
-- @tfield int maximal_count [minimal_count, ∞)

---
-- @function new
-- @tparam lualife.models.Size size
-- @tparam[opt=(0 0)] lualife.models.Point initial_offset
-- @tparam[optchain=0.5] number filling [0, 1]
-- @tparam[optchain=0] int minimal_count [0, size.width * size.height]
-- @tparam[optchain=math.huge] int maximal_count [minimal_count, ∞)
-- @treturn FieldSettings
function FieldSettings:initialize(
  size,
  initial_offset,
  filling,
  minimal_count,
  maximal_count
)
  initial_offset = initial_offset or Point:new(0, 0)
  filling = filling or 0.5
  minimal_count = minimal_count or 0
  maximal_count = maximal_count or math.huge

  assertions.is_instance(size, Size)
  assertions.is_instance(initial_offset, Point)
  assertions.is_number(filling)
  assertions.is_integer(minimal_count)
  assertions.is_integer(maximal_count)

  self.size = size
  self.initial_offset = initial_offset
  self.filling = filling
  self.minimal_count = minimal_count
  self.maximal_count = maximal_count
end

---
-- @treturn tab table with instance fields
--   (see the [luaserialization](https://github.com/thewizardplusplus/luaserialization) library)
function FieldSettings:__data()
  return {
    size = self.size,
    initial_offset = self.initial_offset,
    filling = self.filling,
    minimal_count = self.minimal_count,
    maximal_count = self.maximal_count,
  }
end

---
-- @function __tostring
-- @treturn string stringified table with instance fields
--   (see the [luaserialization](https://github.com/thewizardplusplus/luaserialization) library)

return FieldSettings
