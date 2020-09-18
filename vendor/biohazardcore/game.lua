---
-- @classmod Game

local middleclass = require("middleclass")
local types = require("lualife.types")
local Point = require("lualife.models.point")
local PlacedField = require("lualife.models.placedfield")
local GameSettings = require("biohazardcore.models.gamesettings")
local sets = require("lualife.sets")
local matrix = require("lualife.matrix")
local life = require("lualife.life")
local factory = require("biohazardcore.factory")

local Game = middleclass("Game")

---
-- @table instance
-- @tfield GameSettings settings
-- @tfield lualife.models.PlacedField _field
-- @tfield lualife.models.PlacedField _field_part

---
-- @function new
-- @tparam GameSettings settings
-- @treturn Game
function Game:initialize(settings)
  assert(types.is_instance(settings, GameSettings))

  self.settings = settings
  self._field = factory.create_field(settings.field)
  self._field_part = factory.create_field(settings.field_part)
end

---
-- @treturn int
function Game:count()
  return self._field:count()
end

---
-- @treturn lualife.models.Point
function Game:offset()
  return self._field_part.offset
end

---
-- @tparam lualife.models.Point delta_offset
-- @treturn bool
function Game:move(delta_offset)
  assert(types.is_instance(delta_offset, Point))

  local field_part_offset_next = self._field_part.offset:translate(delta_offset)
  local field_part_next =
    PlacedField.place(self._field_part, field_part_offset_next)
  if field_part_next:fits(self._field) then
    self._field_part = field_part_next
    return true
  end

  return false
end

---
-- @function rotate
function Game:rotate()
  self._field_part = matrix.rotate(self._field_part)
end

---
-- @function union
-- @treturn bool
function Game:union()
  if self:_intersection():count() ~= 0 then
    return false
  end

  local field_next = sets.union(self._field, self._field_part)
  field_next = life.populate(field_next)

  self._field = field_next
  self._field_part = factory.create_field(self.settings.field_part)

  return true
end

---
-- @treturn lualife.models.PlacedField
function Game:_intersection()
  return sets.intersection(self._field, self._field_part)
end

return Game
