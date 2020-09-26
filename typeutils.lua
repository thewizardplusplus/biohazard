---
-- @module typeutils

local types = require("lualife.types")
local Size = require("lualife.models.size")

local typeutils = {}

---
-- @tparam func handler func(): any; function that raises an error
-- @tparam[opt] {any,...} ... handler arguments
-- @treturn any successful handler result
-- @error raised handler error
function typeutils.catch_error(handler, ...)
  assert(type(handler) == "function")

  local arguments = table.pack(...)
  local ok, result = pcall(function()
    return handler(table.unpack(arguments))
  end)
  if not ok then
    return nil, result
  end

  return result
end

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
