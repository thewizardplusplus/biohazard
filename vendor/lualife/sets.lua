---
-- @module sets

local Point = require("lualife.models.point")
local Field = require("lualife.models.field")

local sets = {}

---
-- @tparam Field base
-- @tparam Field additional
-- @tparam Point offset
-- @treturn Field
function sets.union(base, additional, offset)
  assert(base:isInstanceOf(Field))
  assert(additional:isInstanceOf(Field))
  assert(offset:isInstanceOf(Point))

  local inverted_offset = offset:scale(-1)
  return base:map(function(point, contains)
    if contains then
      return true
    end

    local shifted_point = point:translate(inverted_offset)
    return additional:contains(shifted_point)
  end)
end

return sets
