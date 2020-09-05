---
-- @classmod UiUpdate

local middleclass = require("middleclass")
local types = require("lualife.types")
local Point = require("lualife.models.point")

local UiUpdate = middleclass("UiUpdate")

---
-- @table instance
-- @tfield lualife.models.Point delta_offset
-- @tfield bool new
-- @tfield bool unioned

---
-- @function new
-- @tparam lualife.models.Point delta_offset
-- @tparam bool rotated
-- @tparam bool unioned
-- @treturn UiUpdate
function UiUpdate:initialize(delta_offset, rotated, unioned)
  assert(types.is_instance(delta_offset, Point))
  assert(type(rotated) == "boolean")
  assert(type(unioned) == "boolean")

  self.delta_offset = delta_offset
  self.rotated = rotated
  self.unioned = unioned
end

return UiUpdate
