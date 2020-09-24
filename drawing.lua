---
-- @module drawing

local types = require("lualife.types")
local Size = require("lualife.models.size")
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

  local field_size = game.settings.field.size
  local grid_step = screen:height() / field_size.height
  local field_offset = screen.minimum:translate(Point:new(screen:width() / 2 - grid_step * field_size.width / 2, 0))
  drawing._draw_rectangle(
    "fill",
    field_offset,
    drawing._scale_size(field_size, grid_step),
    0,
    {1, 1, 1}
  )

  local classification = game:classify_cells()
  for cell_kind, cells in pairs(classification) do
    drawing._draw_field(cells, DrawingSettings:new(field_offset, grid_step, cell_kind))
  end

  drawing._draw_rectangle(
    "line",
    DrawingSettings:new(field_offset, grid_step):map_point(game:offset()),
    drawing._scale_size(game.settings.field_part.size, grid_step),
    grid_step / 10,
    {0.75, 0.75, 0}
  )
end

---
-- @tparam lualife.models.Field field
-- @tparam DrawingSettings settings
function drawing._draw_field(field, settings)
  assert(types.is_instance(field, Field))
  assert(types.is_instance(settings, DrawingSettings) and settings.cell_kind)

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
  assert(types.is_instance(settings, DrawingSettings) and settings.cell_kind)

  local cell_color
  if settings.cell_kind == "old" then
    cell_color = {0, 0, 1}
  elseif settings.cell_kind == "new" then
    cell_color = {0, 0.66, 0}
  elseif settings.cell_kind == "intersection" then
    cell_color = {0.85, 0, 0}
  end

  drawing._draw_rectangle(
    "fill",
    settings:map_point(point),
    Size:new(settings.grid_step, settings.grid_step),
    settings.grid_step / 4,
    cell_color
  )
end

---
-- @tparam "line"|"fill" rectangle_kind
-- @tparam lualife.models.Point position
-- @tparam lualife.models.Size size
-- @tparam int border [0, ∞) width (for the line rectangle kind)
--   / radius (for the fill rectangle kind)
-- @tparam {number,number,number} color
--   red, green and blue values in the range [0, 1]
function drawing._draw_rectangle(
  rectangle_kind,
  position,
  size,
  border,
  color
)
  assert(rectangle_kind == "line" or rectangle_kind == "fill")
  assert(types.is_instance(position, Point))
  assert(types.is_instance(size, Size))
  assert(types.is_number_with_limits(border, 0))
  assert(type(color) == "table" and #color == 3)
  for _, color_channel in ipairs(color) do
    assert(types.is_number_with_limits(color_channel, 0, 1))
  end

  local border_width, border_radius = 0, 0
  if rectangle_kind == "line" then
    border_width = border
  elseif rectangle_kind == "fill" then
    border_radius = border
  end

  love.graphics.setLineWidth(border_width)
  love.graphics.setColor(color)
  love.graphics.rectangle(
    rectangle_kind,
    position.x,
    position.y,
    size.width,
    size.height,
    border_radius
  )
end

---
-- @tparam lualife.models.Size size
-- @tparam int factor
-- @treturn lualife.models.Size
function drawing._scale_size(size, factor)
  assert(types.is_instance(size, Size))
  assert(types.is_number_with_limits(factor))

  return Size:new(factor * size.width, factor * size.height)
end

return drawing
