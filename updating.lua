---
-- @module updating

local types = require("lualife.types")
local Point = require("lualife.models.point")
local Game = require("biohazardcore.game")
local Rectangle = require("models.rectangle")
local UiUpdate = require("models.uiupdate")

local updating = {}

---
-- @treturn Rectangle
function updating.update_screen()
  local x, y, width, height = love.window.getSafeArea()
  local padding = height / 20
  return Rectangle:new(
    Point:new(x + padding, y + padding),
    Point:new(x + width - padding, y + height - padding)
  )
end

---
-- @tparam biohazardcore.Game game
-- @tparam UiUpdate update
function updating.update_game(game, update)
  assert(types.is_instance(game, Game))
  assert(types.is_instance(update, UiUpdate))

  game:move(update:delta_offset())
  if update.rotated then
    game:rotate()
  end
  if update.unioned then
    game:union()
  end
end

return updating
