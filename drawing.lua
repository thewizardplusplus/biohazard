---
-- @module drawing

local types = require("lualife.types")
local Point = require("lualife.models.point")
local Field = require("lualife.models.field")
local ClassifiedGame = require("biohazardcore.classifiedgame")

local CELL_RADIUS_FACTOR = 0.25

local drawing = {}

---
-- @tparam biohazardcore.ClassifiedGame game
-- @tparam lualife.models.Point field_offset
-- @tparam int grid_step [0, ∞)
function drawing.draw_game(
  game,
  field_offset,
  grid_step
)
  assert(types.is_instance(game, ClassifiedGame))
  assert(types.is_instance(field_offset, Point))
  assert(types.is_number_with_limits(grid_step, 0))

  love.graphics.setColor(1, 1, 1)
  love.graphics.rectangle(
    "fill",
    field_offset.x,
    field_offset.y,
    grid_step * game._settings.field.size.width,
    grid_step * game._settings.field.size.height
  )

  local classification = game:classify_cells()
  drawing.draw_field(classification.old, field_offset, grid_step, {0, 0, 1})
  drawing.draw_field(classification.new, field_offset, grid_step, {0, 0.66, 0})
  drawing.draw_field(classification.intersection, field_offset, grid_step, {0.85, 0, 0})

  love.graphics.setColor(0.75, 0.75, 0)
  love.graphics.setLineWidth(grid_step / 10)
  love.graphics.rectangle(
    "line",
    field_offset.x + grid_step * game._field_part.offset.x,
    field_offset.y + grid_step * game._field_part.offset.y,
    grid_step * game._settings.field_part.size.width,
    grid_step * game._settings.field_part.size.height
  )
end

---
-- @tparam lualife.models.Field field
-- @tparam lualife.models.Point field_offset
-- @tparam int grid_step [0, ∞)
-- @tparam {number,number,number} cell_color
--   red, green and blue values in the range [0, 1]
function drawing.draw_field(
  field,
  field_offset,
  grid_step,
  cell_color
)
  assert(types.is_instance(field, Field))
  assert(types.is_instance(field_offset, Point))
  assert(types.is_number_with_limits(grid_step, 0))
  assert(type(cell_color) == "table" and #cell_color == 3)
  for index in ipairs(cell_color) do
    assert(types.is_number_with_limits(cell_color[index], 0, 1))
  end

  field:map(function(point, contains)
    if contains then
      drawing.draw_cell(point, field_offset, grid_step, cell_color)
    end
  end)
end

---
-- @tparam lualife.models.Point point
-- @tparam lualife.models.Point field_offset
-- @tparam int grid_step [0, ∞)
-- @tparam {number,number,number} cell_color
--   red, green and blue values in the range [0, 1]
function drawing.draw_cell(
  point,
  field_offset,
  grid_step,
  cell_color
)
  assert(types.is_instance(point, Point))
  assert(types.is_instance(field_offset, Point))
  assert(types.is_number_with_limits(grid_step, 0))
  assert(type(cell_color) == "table" and #cell_color == 3)
  for index in ipairs(cell_color) do
    assert(types.is_number_with_limits(cell_color[index], 0, 1))
  end

  local cell_point = point
    :scale(grid_step)
    :translate(field_offset)

  love.graphics.setColor(cell_color)
  love.graphics.rectangle(
    "fill",
    cell_point.x,
    cell_point.y,
    grid_step,
    grid_step,
    CELL_RADIUS_FACTOR * grid_step
  )
end

return drawing
