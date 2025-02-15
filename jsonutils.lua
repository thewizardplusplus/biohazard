-- luacheck: no max comment line length

---
-- @module jsonutils

local assertions = require("luatypechecks.assertions")
local checks = require("luatypechecks.checks")
local json = require("luaserialization.json")

local jsonutils = {}

---
-- @tparam string path
-- @tparam tab schema JSON Schema
-- @tparam[optchain] {[string]=func,...} constructors constructors for tables with the `__name` property; the values should be `func(options: tab): tab`; the constructor can either return an error as the second result or throw it as an exception
-- @treturn any
-- @error error message
function jsonutils.load_from_json(path, schema, constructors)
  assertions.is_string(path)
  assertions.is_table(schema)
  assertions.is_table_or_nil(constructors, checks.is_string, checks.is_callable)

  local data_in_json, err = love.filesystem.read(path)
  if not data_in_json then
    return nil, "unable to read data: " .. err
  end

  local data, err = json.from_json( -- luacheck: no redefined
    data_in_json,
    schema,
    constructors
  )
  if not data then
    return nil, "unable to parse data: " .. err
  end

  return data
end

return jsonutils
