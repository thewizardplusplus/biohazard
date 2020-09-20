---
-- @classmod UiUpdate

local middleclass = require("middleclass")
local Point = require("lualife.models.point")

local UiUpdate = middleclass("UiUpdate")

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
  assert(type(moved_left) == "boolean")
  assert(type(moved_right) == "boolean")
  assert(type(moved_top) == "boolean")
  assert(type(moved_bottom) == "boolean")
  assert(type(rotated) == "boolean")
  assert(type(unioned) == "boolean")

  self.moved_left = moved_left
  self.moved_right = moved_right
  self.moved_top = moved_top
  self.moved_bottom = moved_bottom
  self.rotated = rotated
  self.unioned = unioned
end

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

return UiUpdate
