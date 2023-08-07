---
-- @classmod CellClassification

local middleclass = require("middleclass")
local assertions = require("luatypechecks.assertions")
local checks = require("luatypechecks.checks")
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
-- @tparam any cell_kind
-- @treturn bool
function CellClassification.static.is_cell_kind(cell_kind)
  return checks.is_enumeration(cell_kind, CellClassification.cell_kinds())
end

---
-- @function new
-- @tparam lualife.models.PlacedField old
-- @tparam lualife.models.PlacedField new
-- @tparam lualife.models.PlacedField intersection
-- @treturn CellClassification
function CellClassification:initialize(old, new, intersection)
  assertions.is_instance(old, PlacedField)
  assertions.is_instance(new, PlacedField)
  assertions.is_instance(intersection, PlacedField)

  self.old = old
  self.new = new
  self.intersection = intersection
end

---
-- @treturn func func(instance: CellClassification, field: nil|string):
--   nil|(string, lualife.models.PlacedField); next function
-- @treturn CellClassification self
-- @treturn nil
function CellClassification:__pairs()
  local function next(instance, field)
    assertions.is_instance(instance, CellClassification)
    assertions.is_string_or_nil(field)

    if field == nil then
      return "old", instance.old
    elseif field == "old" then
      return "new", instance.new
    elseif field == "new" then
      return "intersection", instance.intersection
    else
      return nil
    end
  end

  return next, self, nil
end

---
-- @treturn tab table with instance fields
function CellClassification:__data()
  local data = {}
  for cell_kind, cells in pairs(self) do
    data[cell_kind] = cells:__data()
  end

  return data
end

---
-- @function __tostring
-- @treturn string stringified table with instance fields

return CellClassification
