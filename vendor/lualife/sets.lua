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

---
-- @tparam Field base
-- @tparam Field additional
-- @tparam Point offset
-- @treturn Field
function sets.complement(base, additional, offset)
  assert(base:isInstanceOf(Field))
  assert(additional:isInstanceOf(Field))
  assert(offset:isInstanceOf(Point))

  local inverted_offset = offset:scale(-1)
  return base:map(function(point, contains)
    if not contains then
      return false
    end

    local shifted_point = point:translate(inverted_offset)
    return not additional:contains(shifted_point)
  end)
end

---
-- @tparam Field base
-- @tparam Field additional
-- @tparam Point offset
-- @treturn Field
function sets.intersection(base, additional, offset)
  assert(base:isInstanceOf(Field))
  assert(additional:isInstanceOf(Field))
  assert(offset:isInstanceOf(Point))

  local inverted_offset = offset:scale(-1)
  return base:map(function(point, contains)
    local shifted_point = point:translate(inverted_offset)
    return contains and additional:contains(shifted_point)
  end)
end

return sets
