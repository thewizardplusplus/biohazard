---
-- @classmod StatsStorage

local middleclass = require("middleclass")
local flatdb = require("flatdb")
local assertions = require("luatypechecks.assertions")
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
  assertions.is_string(path)
  assertions.is_integer(initial_minimal)

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
  assertions.is_integer(current)

  if self._db.stats.minimal > current then
    self._db.stats.minimal = current
    self._db:save()
  end

  return Stats:new(current, self._db.stats.minimal)
end

return StatsStorage
