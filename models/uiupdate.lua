-- luacheck: no max comment line length

---
-- @classmod UiUpdate

local middleclass = require("middleclass")
local assertions = require("luatypechecks.assertions")
local Nameable = require("luaserialization.nameable")
local Stringifiable = require("luaserialization.stringifiable")
local Point = require("lualife.models.point")

local UiUpdate = middleclass("UiUpdate")
UiUpdate:include(Nameable)
UiUpdate:include(Stringifiable)

---
-- @table instance
-- @tfield bool moved_left
-- @tfield bool moved_right
-- @tfield bool moved_top
-- @tfield bool moved_bottom
-- @tfield bool rotated
-- @tfield bool unioned

---
-- @function new
-- @tparam bool moved_left
-- @tparam bool moved_right
-- @tparam bool moved_top
-- @tparam bool moved_bottom
-- @tparam bool rotated
-- @tparam bool unioned
-- @treturn UiUpdate
function UiUpdate:initialize(
  moved_left,
  moved_right,
  moved_top,
  moved_bottom,
  rotated,
  unioned
)
  assertions.is_boolean(moved_left)
  assertions.is_boolean(moved_right)
  assertions.is_boolean(moved_top)
  assertions.is_boolean(moved_bottom)
  assertions.is_boolean(rotated)
  assertions.is_boolean(unioned)

  self.moved_left = moved_left
  self.moved_right = moved_right
  self.moved_top = moved_top
  self.moved_bottom = moved_bottom
  self.rotated = rotated
  self.unioned = unioned
end

---
-- @treturn tab table with instance fields
--   (see the [luaserialization](https://github.com/thewizardplusplus/luaserialization) library)
function UiUpdate:__data()
  return {
    moved_left = self.moved_left,
    moved_right = self.moved_right,
    moved_top = self.moved_top,
    moved_bottom = self.moved_bottom,
    rotated = self.rotated,
    unioned = self.unioned,
  }
end

---
-- @function __tostring
-- @treturn string stringified table with instance fields
--   (see the [luaserialization](https://github.com/thewizardplusplus/luaserialization) library)

---
-- @treturn lualife.models.Point
function UiUpdate:delta_offset()
  local delta_offset = Point:new(0, 0)
  if self.moved_left then
    delta_offset.x = -1
  end
  if self.moved_right then
    delta_offset.x = 1
  end
  if self.moved_top then
    delta_offset.y = -1
  end
  if self.moved_bottom then
    delta_offset.y = 1
  end

  return delta_offset
end

---
-- @tparam UiUpdate other
-- @treturn UiUpdate
function UiUpdate:merge(other)
  assertions.is_instance(other, UiUpdate)

  return UiUpdate:new(
    self.moved_left or other.moved_left,
    self.moved_right or other.moved_right,
    self.moved_top or other.moved_top,
    self.moved_bottom or other.moved_bottom,
    self.rotated or other.rotated,
    self.unioned or other.unioned
  )
end

return UiUpdate
