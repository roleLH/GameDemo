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
-- 获取id，然后在battle中进行存储，如果已经点击了两个，那么判断两个点击的类型，类型相同，执行消除
local function OnClickGrid(self, id, floor)
	local rst = BattleData:GetInstance():OnClickGrid(id, floor)
	-- 点击还不够两个，继续等待
 	if rst == false then
		self:UIBroadcast(UIMessageNames.UIGAMEPLAY_ON_CLICK_GRID, id, floor)
	else
		local canRemove, blocks = BattleData:GetInstance():OnCheckCanRemove()
		self:UIBroadcast(UIMessageNames.UIGAMEPLAY_REMOVE_BLOCK, canRemove, blocks)
	end

end

UIGamePlayModel.OnCreate = OnCreate
UIGamePlayModel.OnDisable = OnDisable
UIGamePlayModel.OnScoreChange = OnScoreChange
UIGamePlayModel.OnClickGrid = OnClickGrid

return UIGamePlayModel