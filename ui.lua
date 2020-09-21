---
-- @module ui

local suit = require("suit")
local types = require("lualife.types")
local Point = require("lualife.models.point")
local Rectangle = require("models.rectangle")
local Stats = require("models.stats")
local UiUpdate = require("models.uiupdate")

local ui = {}

---
-- @function draw
-- @tparam Rectangle screen
function ui.draw(screen)
  assert(types.is_instance(screen, Rectangle))

  local font_size = screen:height() / 20
  love.graphics.setFont(love.graphics.newFont(font_size))

  suit.draw()
end

---
-- @tparam Rectangle screen
-- @tparam Stats stats
-- @treturn UiUpdate
function ui._update_buttons(screen, stats)
  assert(types.is_instance(screen, Rectangle))
  assert(types.is_instance(stats, Stats))

  local grid_step = screen:height() / 4
  local padding = grid_step / 8
  local left_buttons_offset = Point:new(
    screen.minimum.x,
    screen.maximum.y - 1.5 * grid_step - padding
  )
  local right_buttons_offset = Point:new(
    screen.maximum.x - grid_step,
    screen.maximum.y - 1.5 * grid_step - 2 * padding
  )

  local labels_grid_step = grid_step / 3
  local labels_offset = Point:new(
    screen.maximum.x - 3 * labels_grid_step,
    screen.minimum.y
  )

  suit.layout:reset(left_buttons_offset.x, left_buttons_offset.y, padding)
  local rotate_button =
    suit.Button("@", suit.layout:row(grid_step + padding, grid_step / 2))
  local to_left_button =
    suit.Button("<", suit.layout:row(grid_step / 2, grid_step))
  local to_right_button = suit.Button(">", suit.layout:col())

  suit.layout:reset(right_buttons_offset.x, right_buttons_offset.y, padding)
  local union_button =
    suit.Button("+", suit.layout:row(grid_step, grid_step / 2))
  local to_top_button = suit.Button("^", suit.layout:row())
  local to_bottom_button = suit.Button("v", suit.layout:row())

  suit.layout:reset(labels_offset.x, labels_offset.y)
  suit.Label(
    "Now:",
    ui._make_label_options({0, 0, 0}, "left"),
    suit.layout:row(2 * labels_grid_step, labels_grid_step)
  )
  suit.Label(
    tostring(stats.current),
    ui._make_label_options({0, 0, 0}, "right"),
    suit.layout:col(labels_grid_step, labels_grid_step)
  )

  suit.layout:reset(labels_offset.x, labels_offset.y + labels_grid_step)
  suit.Label(
    "Min:",
    ui._make_label_options({0, 0.33, 0}, "left"),
    suit.layout:row(2 * labels_grid_step, labels_grid_step)
  )
  suit.Label(
    tostring(stats.minimal),
    ui._make_label_options({0, 0.33, 0}, "right"),
    suit.layout:col(labels_grid_step, labels_grid_step)
  )

  return UiUpdate:new(
    to_left_button.hit,
    to_right_button.hit,
    to_top_button.hit,
    to_bottom_button.hit,
    rotate_button.hit,
    union_button.hit
  )
end

---
-- @tparam {number,number,number} color
--   red, green and blue values in the range [0, 1]
-- @tparam "left"|"right" align
-- @treturn tab common SUIT widget options
function ui._make_label_options(color, align)
  assert(align == "left" or align == "right")
  assert(type(color) == "table" and #color == 3)
  for _, color_channel in ipairs(color) do
    assert(types.is_number_with_limits(color_channel, 0, 1))
  end

  return {
    color = {normal = {fg = color}},
    align = align,
    valign = "top",
  }
end

return ui
