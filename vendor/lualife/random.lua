---
-- @module random

local Size = require("lualife.models.size")
local Field = require("lualife.models.field")

local random = {}

---
-- @tparam Size size
-- @tparam number filling [0, 1]
-- @treturn Field
function random.generate(size, filling)
  assert(size:isInstanceOf(Size))
  assert(type(filling) == "number")

  return Field
    :new(size)
    :map(function()
      return math.random() < filling
    end)
end

return random
