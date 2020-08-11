---
-- @module drawing

local Point = require("lualife.models.point")
local Field = require("lualife.models.field")

local CELL_RADIUS_FACTOR = 0.25

local drawing = {}

---
-- @tparam lualife.models.Field field
-- @tparam lualife.models.Point field_offset
-- @tparam int cell_size [0, ∞)
-- @tparam {number,number,number} cell_color
--   red, green and blue values in the range [0, 1]
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
