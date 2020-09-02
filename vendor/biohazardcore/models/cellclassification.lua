---
-- @classmod CellClassification

local middleclass = require("middleclass")
local types = require("lualife.types")
local Stringifiable = require("lualife.models.stringifiable")
local PlacedField = require("lualife.models.placedfield")

local CellClassification = middleclass("CellClassification")
CellClassification:include(Stringifiable)

---
-- @table instance
-- @tfield lualife.models.PlacedField old
-- @tfield lualife.models.PlacedField new
-- @tfield lualife.models.PlacedField intersection

---
-- @function new
-- @tparam lualife.models.PlacedField old
-- @tparam lualife.models.PlacedField new
-- @tparam lualife.models.PlacedField intersection
-- @treturn CellClassification
function CellClassification:initialize(old, new, intersection)
  assert(types.is_instance(old, PlacedField))
  assert(types.is_instance(new, PlacedField))
  assert(types.is_instance(intersection, PlacedField))

  self.old = old
  self.new = new
  self.intersection = intersection
end

---
-- @treturn tab table with instance fields
function CellClassification:__data()
  return {
    old = self.old:__data(),
    new = self.new:__data(),
    intersection = self.intersection:__data(),
  }
end

---
-- @function __tostring
-- @treturn string stringified table with instance fields

return CellClassification
