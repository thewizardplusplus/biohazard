---
-- @module drawing

local types = require("lualife.types")
local Point = require("lualife.models.point")
local Field = require("lualife.models.field")
local CellClassification = require("biohazardcore.models.cellclassification")
local ClassifiedGame = require("biohazardcore.classifiedgame")
local Rectangle = require("models.rectangle")

local drawing = {}

---
-- @tparam biohazardcore.ClassifiedGame game
-- @tparam Rectangle screen
function drawing.draw_game(game, screen)
  assert(types.is_instance(game, ClassifiedGame))
  assert(types.is_instance(screen, Rectangle))

  local screen_height = screen.maximum.y - screen.minimum.y
  local grid_step = screen_height / game.settings.field.size.height
  local field_offset = screen.minimum
    :translate(Point:new(
      (screen:width() - grid_step * game.settings.field.size.width) / 2,
      0
    ))

  love.graphics.setColor(1, 1, 1)
  love.graphics.rectangle(
    "fill",
    field_offset.x,
    field_offset.y,
    grid_step * game.settings.field.size.width,
    grid_step * game.settings.field.size.height
  )

  local classification = game:classify_cells()
  for _, cell_kind in ipairs(CellClassification:cell_kinds()) do
    drawing._draw_field(classification[cell_kind], field_offset, grid_step, cell_kind)
  end

  local field_part_offset = game:offset()
    :scale(grid_step)
    :translate(field_offset)
  love.graphics.setColor(0.75, 0.75, 0)
  love.graphics.setLineWidth(grid_step / 10)
  love.graphics.rectangle(
    "line",
    field_part_offset.x,
    field_part_offset.y,
    grid_step * game.settings.field_part.size.width,
    grid_step * game.settings.field_part.size.height
  )
end

---
-- @tparam lualife.models.Field field
-- @tparam lualife.models.Point field_offset
-- @tparam int grid_step [0, ∞)
-- @tparam "old"|"new"|"intersection" cell_kind
function drawing._draw_field(
  field,
  field_offset,
  grid_step,
  cell_kind
)
  assert(types.is_instance(field, Field))
  assert(types.is_instance(field_offset, Point))
  assert(types.is_number_with_limits(grid_step, 0))
  assert(CellClassification.is_cell_kind(cell_kind))

  field:map(function(point, contains)
    if contains then
      drawing._draw_cell(point, field_offset, grid_step, cell_kind)
    end
  end)
end

---
-- @tparam lualife.models.Point point
-- @tparam lualife.models.Point field_offset
-- @tparam int grid_step [0, ∞)
-- @tparam "old"|"new"|"intersection" cell_kind
function drawing._draw_cell(
  point,
  field_offset,
  grid_step,
  cell_kind
)
  assert(types.is_instance(point, Point))
  assert(types.is_instance(field_offset, Point))
  assert(types.is_number_with_limits(grid_step, 0))
  assert(CellClassification.is_cell_kind(cell_kind))

  local cell_color
  if cell_kind == "old" then
    cell_color = {0, 0, 1}
  elseif cell_kind == "new" then
    cell_color = {0, 0.66, 0}
  elseif cell_kind == "intersection" then
    cell_color = {0.85, 0, 0}
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
    grid_step / 4
  )
end

return drawing
