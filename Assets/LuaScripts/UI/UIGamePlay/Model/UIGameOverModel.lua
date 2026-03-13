local UIGameOverModel = BaseClass("UIGameOverModel", UIBaseModel)
local base = UIBaseModel

local function OnNextGame(self)
	self:UIBroadcast(UIMessageNames.UIGAMEPLAY_NEXT_GAME)
end

UIGameOverModel.OnNextGame = OnNextGame
return UIGameOverModel