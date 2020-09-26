---
-- @classmod GameStatsStorage

local middleclass = require("middleclass")
local types = require("lualife.types")
local Game = require("biohazardcore.game")
local StatsStorage = require("stats.statsstorage")

local GameStatsStorage = middleclass("GameStatsStorage", StatsStorage)

---
-- @table instance
-- @tfield FlatDB _db
-- @tfield biohazardcore.Game _game

---
-- @function new
-- @tparam string path
-- @tparam biohazardcore.Game game
-- @treturn GameStatsStorage
function GameStatsStorage:initialize(path, game)
  assert(type(path) == "string")
  assert(types.is_instance(game, Game))

  local field_size = game.settings.field.size
  StatsStorage.initialize(self, path, field_size.width * field_size.height)

  self._game = game
end

---
-- @treturn Stats
function GameStatsStorage:update()
  local current = self._game:count()
  return StatsStorage.update(self, current)
end

return GameStatsStorage
