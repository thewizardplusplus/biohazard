---
-- @classmod Stringifiable

local inspect = require("inspect")
local assertions = require("luatypechecks.assertions")

local Stringifiable = {}

---
-- @treturn string stringified result of the __data() metamethod
function Stringifiable:__tostring()
  assertions.has_metamethods(self, {"__data"})

  return inspect(self:__data(), {
    indent = "",
    newline = "",
  })
end

return Stringifiable
