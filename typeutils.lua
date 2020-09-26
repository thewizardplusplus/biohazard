---
-- @module typeutils

local types = require("lualife.types")
local Size = require("lualife.models.size")

local typeutils = {}

---
-- @tparam lualife.models.Size size
-- @tparam int factor
-- @treturn lualife.models.Size
function typeutils.scale_size(size, factor)
  assert(types.is_instance(size, Size))
  assert(types.is_number_with_limits(factor))

  return Size:new(factor * size.width, factor * size.height)
end

return typeutils
