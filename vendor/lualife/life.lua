---
-- @module life

local Point = require("lualife.models.point")
local Field = require("lualife.models.field")

local life = {}

---
-- @tparam Field field
-- @tparam Point point
-- @treturn int
function life.neighbors(field, point)
  assert(field:isInstanceOf(Field))
  assert(point:isInstanceOf(Point))

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

---
-- @tparam Field field
-- @treturn Field
function life.populate(field)
  assert(field:isInstanceOf(Field))

  local next_field = Field:new(field.size)
  for y = 0, field.size.height - 1 do
    for x = 0, field.size.width - 1 do
      local point = Point:new(x, y)
      local neighbors = life.neighbors(field, point)
      local alive = field:contains(point)
      if neighbors == 3 or (neighbors == 2 and alive) then
        next_field:set(point)
      end
    end
  end

  return next_field
end

return life
