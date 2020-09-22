package.path =
  "/sdcard/lovegame/vendor/?.lua;"
  .. "/sdcard/lovegame/vendor/?/init.lua;"
  .. "./vendor/?.lua;"
  .. "./vendor/?/init.lua"

local baton = require("baton")
local json = require("json")
local jsonschema = require("jsonschema")
local Size = require("lualife.models.size")
local Point = require("lualife.models.point")
local FieldSettings = require("biohazardcore.models.fieldsettings")
local GameSettings = require("biohazardcore.models.gamesettings")
local ClassifiedGame = require("biohazardcore.classifiedgame")
local Rectangle = require("models.rectangle")
local drawing = require("drawing")
local ui = require("ui")
local updating = require("updating")
local StatsStorage = require("statsstorage")

local game = nil -- biohazardcore.ClassifiedGame
local screen = nil -- models.Rectangle
local stats_storage = nil -- StatsStorage
local keys = nil -- baton.Player

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

  local controls_in_json = love.filesystem.read("controls.json")
  assert(controls_in_json, "unable to read the controls configuration")

  local controls = json.decode(controls_in_json)
  local controls_validator = jsonschema.generate_validator({
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
  local valid, err = controls_validator(controls)
  assert(valid, "incorrect controls configuration: " .. tostring(err))

  keys = baton.new({controls = controls})
end

function love.draw()
  drawing.draw_game(screen, game)
  ui.draw(screen)
end

function love.update()
  local stats = stats_storage:update(game:count())
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
