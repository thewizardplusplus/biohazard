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

---
-- @tparam Size size
-- @tparam number filling [0, 1]
-- @tparam int minimal_count [0, size.width * size.height]
-- @tparam int maximal_count [0, size.width * size.height]
-- @treturn Field
function random.generate_with_limits(
  size,
  filling,
  minimal_count,
  maximal_count
)
  assert(size:isInstanceOf(Size))
  assert(type(filling) == "number")
  assert(type(minimal_count) == "number")
  assert(type(maximal_count) == "number")

  local field = Field:new(size)
  while field:count() < minimal_count or field:count() > maximal_count do
    field = random.generate(size, filling)
  end

  return field
end

return random
