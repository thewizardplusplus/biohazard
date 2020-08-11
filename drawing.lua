---
-- @module drawing

local Point = require("lualife.models.point")
local Field = require("lualife.models.field")

local CELL_RADIUS_FACTOR = 0.25

local drawing = {}

---
-- @tparam Field field
-- @tparam Point field_offset
-- @tparam int cell_size
-- @tparam {number, number, number} cell_color
function drawing.draw_field(
  field,
  field_offset,
  cell_size,
  cell_color
)
  assert(field:isInstanceOf(Field))
  assert(field_offset:isInstanceOf(Point))
  assert(type(cell_size) == "number")
  assert(type(cell_color) == "table")

  local cell_radius = CELL_RADIUS_FACTOR * cell_size
  field:map(function(point, contains)
    if not contains then
      return
    end

    local cell_point = point
      :scale(cell_size)
      :translate(field_offset)

    love.graphics.setColor(cell_color)
    love.graphics.rectangle(
      "fill",
      cell_point.x,
      cell_point.y,
      cell_size,
      cell_size,
      cell_radius
    )
  end)
end

return drawing
