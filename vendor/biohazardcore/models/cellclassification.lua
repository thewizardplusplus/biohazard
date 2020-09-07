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
-- @function cell_kinds
-- @static
-- @treturn {string,...} array with all cell kinds
function CellClassification.static.cell_kinds()
  return {"old", "new", "intersection"}
end

---
-- @function is_cell_kind
-- @static
-- @tparam string sample
-- @treturn bool
function CellClassification.static.is_cell_kind(sample)
  assert(type(sample) == "string")

  for _, cell_kind in ipairs(CellClassification.cell_kinds()) do
    if sample == cell_kind then
      return true
    end
  end

  return false
end

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
  local data = {}
  for _, cell_kind in ipairs(CellClassification.cell_kinds()) do
    data[cell_kind] = self[cell_kind]:__data()
  end

  return data
end

---
-- @function __tostring
-- @treturn string stringified table with instance fields

return CellClassification
