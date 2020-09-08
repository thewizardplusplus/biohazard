---
-- @module ui

local suit = require("suit")
local types = require("lualife.types")
local Point = require("lualife.models.point")
local ClassifiedGame = require("biohazardcore.classifiedgame")
local Rectangle = require("models.rectangle")
local UiUpdate = require("models.uiupdate")

local ui = {}

---
-- @function draw
function ui.draw()
  suit.draw()
end

---
-- @tparam biohazardcore.ClassifiedGame game
-- @tparam Rectangle screen
-- @treturn UiUpdate
function ui.update(game, screen)
  assert(types.is_instance(game, ClassifiedGame))
  assert(types.is_instance(screen, Rectangle))

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

  local black_color = {normal = {fg = {0, 0, 0}}}
  suit.layout:reset(labels_offset.x, labels_offset.y, padding)
  suit.Label("Now:", {color = black_color}, suit.layout:row(grid_step / 2, grid_step / 2))
  suit.Label(tostring(game._field:count()), {color = black_color}, suit.layout:col())

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
