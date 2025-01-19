-- luacheck: no max comment line length

---
-- @classmod Stats

local middleclass = require("middleclass")
local assertions = require("luatypechecks.assertions")
local Nameable = require("luaserialization.nameable")
local Stringifiable = require("luaserialization.stringifiable")

local Stats = middleclass("Stats")
Stats:include(Nameable)
Stats:include(Stringifiable)

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

---
-- @treturn tab table with instance fields
--   (see the [luaserialization](https://github.com/thewizardplusplus/luaserialization) library)
function Stats:__data()
  return {
    current = self.current,
    minimal = self.minimal,
  }
end

---
-- @function __tostring
-- @treturn string stringified table with instance fields
--   (see the [luaserialization](https://github.com/thewizardplusplus/luaserialization) library)

return Stats
