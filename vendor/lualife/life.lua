---
-- @module life

local assertions = require("luatypechecks.assertions")
local Point = require("lualife.models.point")
local Field = require("lualife.models.field")

local life = {}

---
-- @tparam Field field
-- @treturn Field
function life.populate(field)
  assertions.is_instance(field, Field)

  return field:map(function(point, contains)
    assertions.is_instance(point, Point)
    assertions.is_boolean(contains)

    local neighbors = life._neighbors(field, point)
    return neighbors == 3 or (neighbors == 2 and contains)
  end)
end

---
-- @tparam Field field
-- @tparam Point point
-- @treturn int [0, 8]
function life._neighbors(field, point)
  assertions.is_instance(field, Field)
  assertions.is_instance(point, Point)

  local neighbors = 0
  for dy = -1, 1 do
    for dx = -1, 1 do
      local translated_point = point:translate(Point:new(dx, dy))
      local alive = field:contains(translated_point)
      local central = dx == 0 and dy == 0
      if alive and not central then
        neighbors = neighbors + 1
      end
    end
  end

  return neighbors
end

return life
