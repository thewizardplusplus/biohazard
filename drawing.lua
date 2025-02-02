---
-- @module drawing

local assertions = require("luatypechecks.assertions")
local mathutils = require("mathutils")
local Size = require("lualife.models.size")
local Point = require("lualife.models.point")
local Field = require("lualife.models.field")
local ClassifiedGame = require("biohazardcore.classifiedgame")
local Rectangle = require("models.rectangle")
local DrawingSettings = require("models.drawingsettings")
local Color = require("models.color")

local drawing = {}

---
-- @tparam Rectangle screen
-- @tparam biohazardcore.ClassifiedGame game
function drawing.draw_game(screen, game)
  assertions.is_instance(screen, Rectangle)
  assertions.is_instance(game, ClassifiedGame)

  local grid_step =
    math.floor(screen:height() / game.settings.field.size.height)
  local field_offset = screen.minimum
    :translate(Point:new(
      (screen:width() - grid_step * game.settings.field.size.width) / 2,
      0
    ))
  drawing._draw_rectangle(
    "fill",
    field_offset,
    mathutils.scale_size(game.settings.field.size, grid_step),
    0,
    Color:new(1, 1, 1)
  )

  local classification = game:classify_cells()
  for cell_kind, cells in pairs(classification) do
    local settings = DrawingSettings:new(field_offset, grid_step, cell_kind)
    drawing._draw_field(cells, settings)
  end

  drawing._draw_rectangle(
    "line",
    DrawingSettings:new(field_offset, grid_step)
      :map_point(game:offset()),
    mathutils.scale_size(game.settings.field_part.size, grid_step),
    math.floor(grid_step / 10),
    Color:new(0.75, 0.75, 0)
  )
end

---
-- @tparam lualife.models.Field field
-- @tparam DrawingSettings settings
function drawing._draw_field(field, settings)
  assertions.is_instance(field, Field)
  assertions.is_instance(settings, DrawingSettings)

  field:map(function(point, contains)
    assertions.is_instance(point, Point)
    assertions.is_boolean(contains)

    if contains then
      drawing._draw_cell(point, settings)
    end
  end)
end

---
-- @tparam lualife.models.Point point
-- @tparam DrawingSettings settings
function drawing._draw_cell(point, settings)
  assertions.is_instance(point, Point)
  assertions.is_instance(settings, DrawingSettings)

  local cell_color
  if settings.cell_kind == "old" then
    cell_color = Color:new(0, 0, 1)
  elseif settings.cell_kind == "new" then
    cell_color = Color:new(0, 0.66, 0)
  elseif settings.cell_kind == "intersection" then
    cell_color = Color:new(0.85, 0, 0)
  end

  drawing._draw_rectangle(
    "fill",
    settings:map_point(point),
    Size:new(settings.grid_step, settings.grid_step),
    math.floor(settings.grid_step / 4),
    cell_color
  )
end

---
-- @tparam "line"|"fill" rectangle_kind
-- @tparam lualife.models.Point position
-- @tparam lualife.models.Size size
-- @tparam int border [0, ∞) width (for the line rectangle kind)
--   / radius (for the fill rectangle kind)
-- @tparam Color color
function drawing._draw_rectangle(
  rectangle_kind,
  position,
  size,
  border,
  color
)
  assertions.is_enumeration(rectangle_kind, {"line", "fill"})
  assertions.is_instance(position, Point)
  assertions.is_instance(size, Size)
  assertions.is_integer(border)
  assertions.is_instance(color, Color)

  local border_width, border_radius = 0, 0
  if rectangle_kind == "line" then
    border_width = border
  elseif rectangle_kind == "fill" then
    border_radius = border
  end

  love.graphics.setLineWidth(border_width)
  love.graphics.setColor(color:channels())
  love.graphics.rectangle(
    rectangle_kind,
    position.x,
    position.y,
    size.width,
    size.height,
    border_radius
  )
end

return drawing
