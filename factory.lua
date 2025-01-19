---
-- @module factory

local assertions = require("luatypechecks.assertions")
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
  assertions.is_string(config_path)

  local game_config, err = typeutils.load_from_json(config_path, {
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
    return nil, "unable to load the game config: " .. err
  end

  return ClassifiedGame:new(GameSettings:new(
    factory._create_field_config(game_config.field),
    factory._create_field_config(game_config.field_part)
  ))
end

---
-- @tparam string path
-- @tparam biohazardcore.Game game
-- @treturn GameStatsStorage
-- @error error message
function factory.create_stats_storage(path, game)
  assertions.is_string(path)
  assertions.is_instance(game, Game)

  local ok = love.filesystem.createDirectory(path)
  if not ok then
    return nil, "unable to create the stats DB"
  end

  local full_path = love.filesystem.getSaveDirectory() .. "/" .. path
  return GameStatsStorage:new(full_path, game)
end

---
-- @tparam tab field_config
-- @treturn FieldSettings
function factory._create_field_config(field_config)
  assertions.is_table(field_config)

  return FieldSettings:new(
    Size:new(
      field_config.size.width,
      field_config.size.height
    ),
    field_config.initial_offset and Point:new(
      field_config.initial_offset.x,
      field_config.initial_offset.y
    ),
    field_config.filling,
    field_config.minimal_count,
    field_config.maximal_count
  )
end

return factory
