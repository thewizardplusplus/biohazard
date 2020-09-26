---
-- @module factory

local types = require("lualife.types")
local Game = require("biohazardcore.game")
local GameStatsStorage = require("stats.gamestatsstorage")

local factory = {}

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
