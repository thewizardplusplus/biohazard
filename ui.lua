---
-- @module ui

local suit = require("suit")
local types = require("lualife.types")
local Point = require("lualife.models.point")
local Rectangle = require("models.rectangle")
local UiUpdate = require("models.uiupdate")

local ui = {}

---
-- @function draw
function ui.draw()
  suit.draw()
end

---
-- @tparam Rectangle screen
-- @treturn UiUpdate
function ui.update(screen)
  assert(types.is_instance(screen, Rectangle))

  local screen_height = screen.maximum.y - screen.minimum.y
  local grid_step = screen_height / 4
  local padding = grid_step / 8
  local left_buttons_offset = Point:new(
    screen.minimum.x,
    screen.maximum.y - 1.5 * grid_step - padding
  )
  local right_buttons_offset = Point:new(
    screen.maximum.x - grid_step,
    screen.maximum.y - 1.5 * grid_step - 2 * padding
  )

  suit.layout:reset(left_buttons_offset.x, left_buttons_offset.y, padding)
  local rotate_button = suit.Button("@", suit.layout:row(grid_step + padding, grid_step / 2))
  local to_left_button = suit.Button("<", suit.layout:row(grid_step / 2, grid_step))
  local to_right_button = suit.Button(">", suit.layout:col())

  suit.layout:reset(right_buttons_offset.x, right_buttons_offset.y, padding)
  local union_button = suit.Button("+", suit.layout:row(grid_step, grid_step / 2))
  local to_top_button = suit.Button("^", suit.layout:row())
  local to_bottom_button = suit.Button("v", suit.layout:row())

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
