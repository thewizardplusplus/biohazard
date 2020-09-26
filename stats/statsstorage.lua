---
-- @classmod StatsStorage

local middleclass = require("middleclass")
local flatdb = require("flatdb")
local types = require("lualife.types")
local Stats = require("models.stats")

local StatsStorage = middleclass("StatsStorage")

---
-- @table instance
-- @tfield FlatDB _db

---
-- @function new
-- @tparam string path
-- @tparam int initial_minimal [0, ∞)
-- @treturn StatsStorage
function StatsStorage:initialize(path, initial_minimal)
  assert(type(path) == "string")
  assert(types.is_number_with_limits(initial_minimal, 0))

  self._db = flatdb(path)
  if not self._db.stats then
    self._db.stats = {
      minimal = initial_minimal,
    }
  end
end

---
-- @tparam int current [0, ∞)
-- @treturn Stats
function StatsStorage:update(current)
  assert(types.is_number_with_limits(current, 0))

  if self._db.stats.minimal > current then
    self._db.stats.minimal = current
    self._db:save()
  end

  return Stats:new(current, self._db.stats.minimal)
end

return StatsStorage
