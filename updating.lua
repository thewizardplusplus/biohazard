---
-- @module updating

local types = require("lualife.types")
local Game = require("biohazardcore.game")
local UiUpdate = require("models.uiupdate")

local updating = {}

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
