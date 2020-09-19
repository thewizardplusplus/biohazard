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
local Stats = require("models.stats")
local drawing = require("drawing")
local ui = require("ui")
local StatsStorage = require("statsstorage")

local game = nil -- ClassifiedGame
local screen = nil -- Rectangle
local stats_storage = nil -- StatsStorage

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

  local save_directory = love.filesystem.getSaveDirectory()
  local stats_db_path = save_directory .. "/" .. stats_db_name
  local initial_minimal_stats = game.settings.field.size.width
    * game.settings.field.size.height
  stats_storage = StatsStorage:new(stats_db_path, initial_minimal_stats)
end

function love.draw()
  drawing.draw_game(screen, game)
  ui.draw(screen)
end

function love.update()
  local stats = stats_storage:update(game:count())
  local update = ui.update(screen, stats)
  game:move(update.delta_offset)
  if update.rotated then
    game:rotate()
  end
  if update.unioned then
    game:union()
  end
end
