package.path =
  "/sdcard/lovegame/vendor/?.lua;"
  .. "/sdcard/lovegame/vendor/?/init.lua;"
  .. "./vendor/?.lua;"
  .. "./vendor/?/init.lua"

local Size = require("lualife.models.size")
local Point = require("lualife.models.point")
local FieldSettings = require("biohazardcore.models.fieldsettings")
local GameSettings = require("biohazardcore.models.gamesettings")
local ClassifiedGame = require("biohazardcore.classifiedgame")
local drawing = require("drawing")
local ui = require("ui")
local suit = require("suit")

local game = ClassifiedGame:new(GameSettings:new(
  FieldSettings:new(Size:new(10, 10), Point:new(0, 0), 0.2),
  FieldSettings:new(Size:new(3, 3), Point:new(0, 0), 0.5, 5, 5)
))
local global_padding = 0
local cell_size = 0
local field_offset = Point:new(0, 0)
local button_size = 0
local button_padding = 0
local left_buttons_offset = 0
local right_buttons_offset = 0

function love.load()
  math.randomseed(os.time())
  love.setDeprecationOutput(true)
  love.graphics.setBackgroundColor(0.5, 0.5, 0.5)

  local ok = love.window.setFullscreen(true)
  assert(ok, "unable to enter fullscreen")

  local x, y, width, height = love.window.getSafeArea()
  global_padding = height / 20
  cell_size = (height - 2 * global_padding) / game._settings.field.size.height
  field_offset = Point
    :new(x, y)
    :translate(Point:new(
      (width - cell_size * game._settings.field.size.width) / 2,
      global_padding
    ))
  button_size = height / 4
  button_padding = button_size / 8
  left_buttons_offset = Point:new(
    x + global_padding,
    y + height - global_padding - 1.5 * button_size - button_padding
  )
  right_buttons_offset = Point:new(
    x + width - global_padding - button_size,
    y + height - global_padding - 1.5 * button_size - 2 * button_padding
  )
end

function love.draw()
  drawing.draw_game(game, field_offset, cell_size)
  ui.draw()
end

function love.update()
  suit.layout:reset(left_buttons_offset.x, left_buttons_offset.y, button_padding)
  local rotate_button = suit.Button("@", suit.layout:row(button_size + button_padding, button_size / 2))
  local to_left_button = suit.Button("<", suit.layout:row(button_size / 2, button_size))
  local to_right_button = suit.Button(">", suit.layout:col())

  suit.layout:reset(right_buttons_offset.x, right_buttons_offset.y, button_padding)
  local union_button = suit.Button("+", suit.layout:row(button_size, button_size / 2))
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
  game:move(delta_offset)

  if rotate_button.hit then
    game:rotate()
  end

  if union_button.hit then
    game:union()
  end
end
