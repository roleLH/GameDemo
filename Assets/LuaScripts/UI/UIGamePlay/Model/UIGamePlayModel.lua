local UIGamePlayModel = BaseClass("UIGamePlayModel", UIBaseModel)
local base = UIBaseModel

-- 打开
local function OnCreate(self)
	base.OnCreate(self)
	-- 进度
	self.score = 0
end
-- 关闭
local function OnDisable(self)
	base.OnDisable(self)
	self.score = 0
end
local function OnScoreChange(self, score)
	BattleData:GetInstance():SetGameScore(score)
	self:UIBroadcast(UIMessageNames.UIGAMEPLAY_SCORE_CHANGE)
end

UIGamePlayModel.OnCreate = OnCreate
UIGamePlayModel.OnDisable = OnDisable
UIGamePlayModel.OnScoreChange = OnScoreChange

return UIGamePlayModel