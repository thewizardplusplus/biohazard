package.path =
  "/sdcard/lovegame/vendor/?.lua;"
  .. "/sdcard/lovegame/vendor/?/init.lua;"
  .. "./vendor/?.lua;"
  .. "./vendor/?/init.lua"

local baton = require("baton")
local Size = require("lualife.models.size")
local Point = require("lualife.models.point")
local FieldSettings = require("biohazardcore.models.fieldsettings")
local GameSettings = require("biohazardcore.models.gamesettings")
local ClassifiedGame = require("biohazardcore.classifiedgame")
local Rectangle = require("models.rectangle")
local UiUpdate = require("models.uiupdate")
local drawing = require("drawing")
local ui = require("ui")
local updating = require("updating")
local StatsStorage = require("statsstorage")

local game = nil -- ClassifiedGame
local screen = nil -- Rectangle
local stats_storage = nil -- StatsStorage
local input = nil -- baton

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
  local padding = height / 20
  screen = Rectangle:new(
    Point:new(x + padding, y + padding),
    Point:new(x + width - padding, y + height - padding)
  )

  local stats_db_name = "biohazard-stats-db"
  ok = love.filesystem.createDirectory(stats_db_name)
  assert(ok, "unable to create the stats DB")

  stats_storage = StatsStorage:new(
    love.filesystem.getSaveDirectory() .. "/" .. stats_db_name,
    game.settings.field.size.width * game.settings.field.size.height
  )

  input = baton.new({
    controls = {
      moved_left = {"key:left", "key:a"},
      moved_right = {"key:right", "key:d"},
      moved_top = {"key:up", "key:w"},
      moved_bottom = {"key:down", "key:s"},
      rotated = {"key:lshift", "key:rshift", "key:r"},
      unioned = {"key:space"},
    },
  })
end

function love.draw()
  drawing.draw_game(screen, game)
  ui.draw(screen)
end

function love.update()
  local stats = stats_storage:update(game:count())
  local update = ui.update(screen, stats)
  updating.update_game(game, update)

  input:update()
  updating.update_game(game, UiUpdate:new(
    input:pressed("moved_left"),
    input:pressed("moved_right"),
    input:pressed("moved_top"),
    input:pressed("moved_bottom"),
    input:pressed("rotated"),
    input:pressed("unioned")
  ))
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end
end
