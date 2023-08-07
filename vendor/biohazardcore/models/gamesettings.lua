---
-- @classmod GameSettings

local middleclass = require("middleclass")
local assertions = require("luatypechecks.assertions")
local Stringifiable = require("lualife.models.stringifiable")
local FieldSettings = require("biohazardcore.models.fieldsettings")

local GameSettings = middleclass("GameSettings")
GameSettings:include(Stringifiable)

---
-- @table instance
-- @tfield FieldSettings field
-- @tfield FieldSettings field_part

---
-- @function new
-- @tparam FieldSettings field
-- @tparam FieldSettings field_part
-- @treturn GameSettings
function GameSettings:initialize(field, field_part)
  assertions.is_instance(field, FieldSettings)
  assertions.is_instance(field_part, FieldSettings)

  self.field = field
  self.field_part = field_part
end

---
-- @treturn tab table with instance fields
function GameSettings:__data()
  return {
    field = self.field:__data(),
    field_part = self.field_part:__data(),
  }
end

---
-- @function __tostring
-- @treturn string stringified table with instance fields

return GameSettings
