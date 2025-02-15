-- luacheck: no max comment line length

---
-- @classmod Field

local middleclass = require("middleclass")
local assertions = require("luatypechecks.assertions")
local Nameable = require("luaserialization.nameable")
local Stringifiable = require("luaserialization.stringifiable")
local Size = require("lualife.models.size")
local Point = require("lualife.models.point")

local Field = middleclass("Field")
Field:include(Nameable)
Field:include(Stringifiable)

---
-- @table instance
-- @tfield Size size
-- @tfield tab _cells
--   map[string, bool]; key - stringified Point, value - always true

---
-- @function new
-- @tparam Size size
-- @treturn Field
function Field:initialize(size)
  assertions.is_instance(size, Size)

  self.size = size
  self._cells = {}
end

---
-- @treturn tab table with instance fields
--   (see the [luaserialization](https://github.com/thewizardplusplus/luaserialization) library)
function Field:__data()
  local cells = {}
  self:map(function(point, contains)
    assertions.is_instance(point, Point)
    assertions.is_boolean(contains)

    if contains then
      table.insert(cells, point)
    end
  end)

  return {
    size = self.size,
    cells = cells,
  }
end

---
-- @function __tostring
-- @treturn string stringified table with instance fields
--   (see the [luaserialization](https://github.com/thewizardplusplus/luaserialization) library)

---
-- @treturn int [0, self.size.width * self.size.height]
function Field:count()
  local count = 0
  for _ in pairs(self._cells) do
    count = count + 1
  end

  return count
end

---
-- @tparam Point point
-- @treturn bool
function Field:contains(point)
  assertions.is_instance(point, Point)

  return self.size:_contains(point) and self._cells[tostring(point)] == true
end

---
-- @tparam Field other
-- @treturn bool
function Field:fits(other)
  assertions.is_instance(other, Field)

  return self.size:_fits(other.size)
end

---
-- @tparam Point point
function Field:set(point)
  assertions.is_instance(point, Point)

  if self.size:_contains(point) then
    self._cells[tostring(point)] = true
  end
end

---
-- @tparam func mapper func(point: Point, contains: bool): bool
-- @treturn Field
function Field:map(mapper)
  assertions.is_callable(mapper)

  local field = Field:new(self.size)
  for y = 0, self.size.height - 1 do
    for x = 0, self.size.width - 1 do
      local point = Point:new(x, y)
      local contains = self:contains(point)
      if mapper(point, contains) then
        field:set(point)
      end
    end
  end

  return field
end

return Field
