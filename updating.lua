---
-- @module updating

local types = require("lualife.types")
local ClassifiedGame = require("biohazardcore.classifiedgame")
local UiUpdate = require("models.uiupdate")

local updating = {}

---
-- @tparam biohazardcore.ClassifiedGame game
-- @tparam UiUpdate update
function updating.update_game(game, update)
  assert(types.is_instance(game, ClassifiedGame))
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
