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
local Rectangle = require("models.rectangle")
local drawing = require("drawing")
local ui = require("ui")

local game = nil -- ClassifiedGame
local global_padding = 0
local screen = nil -- Rectangle
local cell_size = 0
local button_size = 0
local left_buttons_offset = 0
local right_buttons_offset = 0

function love.load()
  math.randomseed(os.time())
  love.setDeprecationOutput(true)
  love.graphics.setBackgroundColor(0.5, 0.5, 0.5)

  local ok = love.window.setFullscreen(true)
  assert(ok, "unable to enter fullscreen")

  game = ClassifiedGame:new(GameSettings:new(
    FieldSettings:new(Size:new(10, 10), Point:new(0, 0), 0.2),
    FieldSettings:new(Size:new(3, 3), Point:new(0, 0), 0.5, 5, 5)
  ))

  local x, y, width, height = love.window.getSafeArea()
  global_padding = height / 20
  screen = Rectangle:new(
    Point:new(x + global_padding, y + global_padding),
    Point:new(x + width - global_padding, y + height - global_padding)
  )
  cell_size = (height - 2 * global_padding) / game._settings.field.size.height
  button_size = height / 4

  local button_padding = button_size / 8  
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
  drawing.draw_game(game, screen, cell_size)
  ui.draw()
end

function love.update()
  local update = ui.update(left_buttons_offset, right_buttons_offset, button_size)
  game:move(update.delta_offset)
  if update.rotated then
    game:rotate()
  end
  if update.unioned then
    game:union()
  end
end
