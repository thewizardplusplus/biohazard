---
-- @module factory

local types = require("lualife.types")
local typeutils = require("typeutils")
local Size = require("lualife.models.size")
local Point = require("lualife.models.point")
local FieldSettings = require("biohazardcore.models.fieldsettings")
local GameSettings = require("biohazardcore.models.gamesettings")
local Game = require("biohazardcore.game")
local ClassifiedGame = require("biohazardcore.classifiedgame")
local GameStatsStorage = require("stats.gamestatsstorage")

local factory = {}

---
-- @tparam string config_path
-- @treturn biohazardcore.ClassifiedGame
-- @error error message
function factory.create_game(config_path)
  assert(type(config_path) == "string")

  local game_config, loading_err = typeutils.load_json(config_path, {
    type = "object",
    properties = {
      field = {["$ref"] = "#/definitions/field_config"},
      field_part = {["$ref"] = "#/definitions/field_config"},
    },
    required = {"field", "field_part"},
    definitions = {
      field_config = {
        type = "object",
        properties = {
          size = {
            type = "object",
            properties = {
              width = {["$ref"] = "#/definitions/positive_integer"},
              height = {["$ref"] = "#/definitions/positive_integer"},
            },
            required = {"width", "height"},
          },
          initial_offset = {
            type = "object",
            properties = {
              x = {["$ref"] = "#/definitions/positive_integer"},
              y = {["$ref"] = "#/definitions/positive_integer"},
            },
            required = {"x", "y"},
          },
          filling = {
            type = "number",
            minimum = 0,
            maximum = 1,
          },
          minimal_count = {["$ref"] = "#/definitions/positive_integer"},
          maximal_count = {["$ref"] = "#/definitions/positive_integer"},
        },
        required = {"size"},
      },
      positive_integer = {
        type = "number",
        minimum = 0,
        multipleOf = 1,
      },
    },
  })
  if not game_config then
    return nil, "unable to load the game config: " .. loading_err
  end

  return ClassifiedGame:new(GameSettings:new(
    FieldSettings:new(
      Size:new(
        game_config.field.size.width,
        game_config.field.size.height
      ),
      game_config.field.initial_offset and Point:new(
        game_config.field.initial_offset.x,
        game_config.field.initial_offset.y
      ),
      game_config.field.filling,
      game_config.field.minimal_count,
      game_config.field.maximal_count
    ),
    FieldSettings:new(
      Size:new(
        game_config.field_part.size.width,
        game_config.field_part.size.height
      ),
      game_config.field_part.initial_offset and Point:new(
        game_config.field_part.initial_offset.x,
        game_config.field_part.initial_offset.y
      ),
      game_config.field_part.filling,
      game_config.field_part.minimal_count,
      game_config.field_part.maximal_count
    )
  ))
end

---
-- @tparam string path
-- @tparam biohazardcore.Game game
-- @treturn GameStatsStorage
-- @error error message
function factory.create_stats_storage(path, game)
  assert(type(path) == "string")
  assert(types.is_instance(game, Game))

  local ok = love.filesystem.createDirectory(path)
  if not ok then
    return nil, "unable to create the stats DB"
  end

  local full_path = love.filesystem.getSaveDirectory() .. "/" .. path
  return GameStatsStorage:new(full_path, game)
end

return factory
