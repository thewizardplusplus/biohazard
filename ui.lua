---
-- @module ui

local suit = require("suit")
local types = require("lualife.types")
local Point = require("lualife.models.point")
local ClassifiedGame = require("biohazardcore.classifiedgame")
local Rectangle = require("models.rectangle")
local Stats = require("models.stats")
local UiUpdate = require("models.uiupdate")

-- @tparam {number,number,number} color
--   red, green and blue values in the range [0, 1] 
-- @tparam "left"|"right" align
-- @treturn tab common suit widget options
local function make_options(color, align)
  assert(type(color) == "table" and #color == 3)
  for _, channel in ipairs(color) do
    assert(types.is_number_with_limits(channel, 0, 1))
  end
  assert(align == "left" or align == "right")

  return {
    color = {normal = {fg = color}},
    align = align,
    valign = "top",
  }
end

local ui = {}

---
-- @function draw
function ui.draw()
  suit.draw()
end

---
-- @tparam Rectangle screen
-- @tparam Stats stats
-- @treturn UiUpdate
function ui.update(screen, stats)
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
  local labels_offset = Point:new(
    screen.maximum.x - grid_step - padding,
    screen.minimum.y
  )

  suit.layout:reset(left_buttons_offset.x, left_buttons_offset.y, padding)
  local rotate_button = suit.Button("@", suit.layout:row(grid_step + padding, grid_step / 2))
  local to_left_button = suit.Button("<", suit.layout:row(grid_step / 2, grid_step))
  local to_right_button = suit.Button(">", suit.layout:col())

  suit.layout:reset(right_buttons_offset.x, right_buttons_offset.y, padding)
  local union_button = suit.Button("+", suit.layout:row(grid_step, grid_step / 2))
  local to_top_button = suit.Button("^", suit.layout:row())
  local to_bottom_button = suit.Button("v", suit.layout:row())

  suit.layout:reset(labels_offset.x, labels_offset.y, padding)
  local current_title_options = make_options({0, 0, 0}, "left")
  suit.Label("Now:", current_title_options, suit.layout:row(2 * grid_step / 3, grid_step / 3))
  local current_value_options = make_options({0, 0, 0}, "right")
  suit.Label(tostring(stats.current), current_value_options, suit.layout:col(grid_step / 3, grid_step / 3))

  suit.layout:reset(labels_offset.x, labels_offset.y + grid_step / 3 + padding, padding)
  local minimal_title_options = make_options({0, 0.33, 0}, "left")
  suit.Label("Min:", minimal_title_options, suit.layout:row(2 * grid_step / 3, grid_step / 3))
  local minimal_value_options = make_options({0, 0.33, 0}, "right")
  suit.Label(tostring(stats.minimal), minimal_value_options, suit.layout:col(grid_step / 3, grid_step / 3))

  local delta_offset = Point:new(0, 0)
  if to_left_button.hit then
    delta_offset.x = -1
  end
  if to_right_button.hit then
    delta_offset.x = 1
  end
  if to_top_button.hit then
    delta_offset.y = -1
  end
  if to_bottom_button.hit then
    delta_offset.y = 1
  end

  return UiUpdate:new(delta_offset, rotate_button.hit, union_button.hit)
end

return ui
