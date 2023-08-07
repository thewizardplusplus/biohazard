---
-- @module sets

local assertions = require("luatypechecks.assertions")
local Field = require("lualife.models.field")
local Point = require("lualife.models.point")

local sets = {}

---
-- @tparam Field base
-- @tparam Field additional
-- @treturn Field
function sets.union(base, additional)
  assertions.is_instance(base, Field)
  assertions.is_instance(additional, Field)

  return base:map(function(point, contains)
    assertions.is_instance(point, Point)
    assertions.is_boolean(contains)

    return contains or additional:contains(point)
  end)
end

---
-- @tparam Field base
-- @tparam Field additional
-- @treturn Field
function sets.complement(base, additional)
  assertions.is_instance(base, Field)
  assertions.is_instance(additional, Field)

  return base:map(function(point, contains)
    assertions.is_instance(point, Point)
    assertions.is_boolean(contains)

    return contains and not additional:contains(point)
  end)
end

---
-- @tparam Field base
-- @tparam Field additional
-- @treturn Field
function sets.intersection(base, additional)
  assertions.is_instance(base, Field)
  assertions.is_instance(additional, Field)

  return base:map(function(point, contains)
    assertions.is_instance(point, Point)
    assertions.is_boolean(contains)

    return contains and additional:contains(point)
  end)
end

return sets
