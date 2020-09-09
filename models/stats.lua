---
-- @classmod Stats

local middleclass = require("middleclass")
local types = require("lualife.types")

local Stats = middleclass("Stats")

---
-- @table instance
-- @tfield int current
-- @tfield int minimal

---
-- @function new
-- @tparam int current
-- @tparam int minimal
-- @treturn Stats
function Stats:initialize(current, minimal)
  assert(types.is_number_with_limits(current, 0))
  assert(types.is_number_with_limits(minimal, 0))

  self.current = current
  self.minimal = minimal
end

return Stats
