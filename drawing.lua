---
-- @module drawing

local types = require("lualife.types")
local Point = require("lualife.models.point")
local Field = require("lualife.models.field")
local ClassifiedGame = require("biohazardcore.classifiedgame")
local Rectangle = require("models.rectangle")
local DrawingSettings = require("models.drawingsettings")
require("compat52")

local drawing = {}

---
-- @tparam Rectangle screen
-- @tparam biohazardcore.ClassifiedGame game
function drawing.draw_game(screen, game)
  assert(types.is_instance(screen, Rectangle))
  assert(types.is_instance(game, ClassifiedGame))

  local grid_step = screen:height() / game.settings.field.size.height
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
  for cell_kind, cells in pairs(classification) do
    drawing._draw_field(cells, DrawingSettings:new(field_offset, grid_step, cell_kind))
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
-- @tparam DrawingSettings settings
function drawing._draw_field(field, settings)
  assert(types.is_instance(field, Field))
  assert(types.is_instance(settings, DrawingSettings))

  field:map(function(point, contains)
    if contains then
      drawing._draw_cell(point, settings)
    end
  end)
end

---
-- @tparam lualife.models.Point point
-- @tparam DrawingSettings settings
function drawing._draw_cell(point, settings)
  assert(types.is_instance(point, Point))
  assert(types.is_instance(settings, DrawingSettings))

  local cell_color
  if settings.cell_kind == "old" then
    cell_color = {0, 0, 1}
  elseif settings.cell_kind == "new" then
    cell_color = {0, 0.66, 0}
  elseif settings.cell_kind == "intersection" then
    cell_color = {0.85, 0, 0}
  end

  local cell_point = point
    :scale(settings.grid_step)
    :translate(settings.field_offset)

  love.graphics.setColor(cell_color)
  love.graphics.rectangle(
    "fill",
    cell_point.x,
    cell_point.y,
    settings.grid_step,
    settings.grid_step,
    settings.grid_step / 4
  )
end

return drawing
