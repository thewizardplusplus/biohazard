---
-- @classmod Stats

local middleclass = require("middleclass")
local assertions = require("luatypechecks.assertions")

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
  assertions.is_integer(current)
  assertions.is_integer(minimal)

  self.current = current
  self.minimal = minimal
end

return Stats
