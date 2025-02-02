---
-- @module mathutils

local assertions = require("luatypechecks.assertions")
local Size = require("lualife.models.size")

local mathutils = {}

---
-- @tparam lualife.models.Size size
-- @tparam int factor [0, ∞)
-- @treturn lualife.models.Size
function mathutils.scale_size(size, factor)
  assertions.is_instance(size, Size)
  assertions.is_integer(factor)

  return Size:new(factor * size.width, factor * size.height)
end

return mathutils
