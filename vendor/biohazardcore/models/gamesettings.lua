-- luacheck: no max comment line length

---
-- @classmod GameSettings

local middleclass = require("middleclass")
local assertions = require("luatypechecks.assertions")
local Nameable = require("luaserialization.nameable")
local Stringifiable = require("luaserialization.stringifiable")
local FieldSettings = require("biohazardcore.models.fieldsettings")

local GameSettings = middleclass("GameSettings")
GameSettings:include(Nameable)
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
--   (see the [luaserialization](https://github.com/thewizardplusplus/luaserialization) library)
function GameSettings:__data()
  return {
    field = self.field,
    field_part = self.field_part,
  }
end

---
-- @function __tostring
-- @treturn string stringified table with instance fields
--   (see the [luaserialization](https://github.com/thewizardplusplus/luaserialization) library)

return GameSettings
