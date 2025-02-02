---
-- @module ui

local baton = require("baton")
local suit = require("suit")
local assertions = require("luatypechecks.assertions")
local jsonutils = require("jsonutils")
local Rectangle = require("models.rectangle")
local Stats = require("models.stats")
local UiUpdate = require("models.uiupdate")
local Color = require("models.color")

local ui = {}

---
-- @tparam string config_path
-- @treturn baton.Player
-- @error error message
function ui.create_keys(config_path)
  assertions.is_string(config_path)

  local keys_config, err = jsonutils.load_from_json(config_path, {
    type = "object",
    properties = {
      moved_left = {["$ref"] = "#/definitions/source_group"},
      moved_right = {["$ref"] = "#/definitions/source_group"},
      moved_top = {["$ref"] = "#/definitions/source_group"},
      moved_bottom = {["$ref"] = "#/definitions/source_group"},
      rotated = {["$ref"] = "#/definitions/source_group"},
      unioned = {["$ref"] = "#/definitions/source_group"},
    },
    required = {
      "moved_left",
      "moved_right",
      "moved_top",
      "moved_bottom",
      "rotated",
      "unioned",
    },
    definitions = {
      source_group = {
        type = "array",
        items = {type = "string", pattern = "^%a+:%w+$"},
        minItems = 1,
      },
    },
  })
  if not keys_config then
    return nil, "unable to load the keys config: " .. err
  end

  return baton.new({controls = keys_config})
end

---
-- @tparam Rectangle screen
function ui.draw(screen)
  assertions.is_instance(screen, Rectangle)

  local font_size = screen:height() / 20
  love.graphics.setFont(love.graphics.newFont(font_size))

  suit.draw()
end

---
-- @tparam Rectangle screen
-- @tparam Stats stats
-- @tparam baton.Player keys
-- @treturn UiUpdate
function ui.update(screen, stats, keys)
  assertions.is_instance(screen, Rectangle)
  assertions.is_instance(stats, Stats)
  assertions.is_table(keys)

  ui._update_labels(screen, stats)

  local buttons_update = ui._update_buttons(screen)
  local keys_update = ui._update_keys(keys)
  return buttons_update:merge(keys_update)
end

---
-- @tparam Rectangle screen
-- @tparam Stats stats
function ui._update_labels(screen, stats)
  assertions.is_instance(screen, Rectangle)
  assertions.is_instance(stats, Stats)

  local grid_step = screen:height() / 12

  -- current stats
  suit.layout:reset(
    screen.maximum.x - 3 * grid_step,
    screen.minimum.y
  )
  suit.Label(
    "Now:",
    ui._create_label_options(Color:new(0, 0, 0), "left"),
    suit.layout:row(2 * grid_step, grid_step)
  )
  suit.Label(
    tostring(stats.current),
    ui._create_label_options(Color:new(0, 0, 0), "right"),
    suit.layout:col(grid_step, grid_step)
  )

  -- minimal stats
  suit.layout:reset(
    screen.maximum.x - 3 * grid_step,
    screen.minimum.y + grid_step
  )
  suit.Label(
    "Min:",
    ui._create_label_options(Color:new(0, 0.33, 0), "left"),
    suit.layout:row(2 * grid_step, grid_step)
  )
  suit.Label(
    tostring(stats.minimal),
    ui._create_label_options(Color:new(0, 0.33, 0), "right"),
    suit.layout:col(grid_step, grid_step)
  )
end

---
-- @tparam Rectangle screen
-- @treturn UiUpdate
function ui._update_buttons(screen)
  assertions.is_instance(screen, Rectangle)

  local grid_step = screen:height() / 4
  local padding = grid_step / 8

  -- left buttons
  suit.layout:reset(
    screen.minimum.x,
    screen.maximum.y - 1.5 * grid_step - padding,
    padding
  )

  local rotate_button =
    suit.Button("@", suit.layout:row(grid_step + padding, grid_step / 2))
  local to_left_button =
    suit.Button("<", suit.layout:row(grid_step / 2, grid_step))
  local to_right_button =
    suit.Button(">", suit.layout:col())

  -- right buttons
  suit.layout:reset(
    screen.maximum.x - grid_step,
    screen.maximum.y - 1.5 * grid_step - 2 * padding,
    padding
  )

  local union_button =
    suit.Button("+", suit.layout:row(grid_step, grid_step / 2))
  local to_top_button =
    suit.Button("^", suit.layout:row())
  local to_bottom_button =
    suit.Button("v", suit.layout:row())

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
-- @tparam baton.Player keys
-- @treturn UiUpdate
function ui._update_keys(keys)
  assertions.is_table(keys)

  keys:update()

  return UiUpdate:new(
    keys:pressed("moved_left"),
    keys:pressed("moved_right"),
    keys:pressed("moved_top"),
    keys:pressed("moved_bottom"),
    keys:pressed("rotated"),
    keys:pressed("unioned")
  )
end

---
-- @tparam Color color
-- @tparam "left"|"right" align
-- @treturn tab common SUIT widget options
function ui._create_label_options(color, align)
  assertions.is_instance(color, Color)
  assertions.is_enumeration(align, {"left", "right"})

  return {
    color = {normal = {fg = color:channels()}},
    align = align,
    valign = "top",
  }
end

return ui
