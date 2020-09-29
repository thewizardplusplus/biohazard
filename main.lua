package.path =
  "/sdcard/lovegame/vendor/?.lua;"
  .. "/sdcard/lovegame/vendor/?/init.lua;"
  .. "./vendor/?.lua;"
  .. "./vendor/?/init.lua"

local factory = require("factory")
local drawing = require("drawing")
local ui = require("ui")
local updating = require("updating")
require("compat52")

local game = nil -- biohazardcore.ClassifiedGame
local screen = nil -- models.Rectangle
local stats_storage = nil -- stats.StatsStorage
local keys = nil -- baton.Player

function love.load()
  math.randomseed(os.time())
  love.setDeprecationOutput(true)
  love.graphics.setBackgroundColor(0.5, 0.5, 0.5)

  local is_mobile_os = love.system.getOS() == "Android"
    or love.system.getOS() == "iOS"
  if is_mobile_os then
    local ok = love.window.setFullscreen(true, "desktop")
    assert(ok, "unable to enter fullscreen")
  end

  game = assert(factory.create_game("game_config.json"))
  stats_storage = assert(factory.create_stats_storage("stats-db", game))
  keys = assert(ui.create_keys("keys_config.json"))
end

function love.draw()
  drawing.draw_game(screen, game)
  ui.draw(screen)
end

function love.update()
  screen = updating.update_screen()

  local stats = stats_storage:update()
  local update = ui.update(screen, stats, keys)
  updating.update_game(game, update)
end

function love.keypressed(key)
  -- can't use the baton library here
  -- because the love.keyboard.isDown() function
  -- doesn't support the escape key
  if key == "escape" then
    love.event.quit()
  end
end
