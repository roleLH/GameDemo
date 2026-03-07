local UIGamePlayView = BaseClass("UIGamePlayView", UIBaseView)
local base = UIBaseView

-- 各个组件路径
local score_text_path = "TopUI/UIGameScore/GameScoreText"
local refresh_btn_path = "ItemUI/RefreshBtn"

local function OnCreate(self)
	base.OnCreate(self)

	self.score_text = self:AddComponent(UITMP, score_text_path)
	self.score_text:SetText("asd123596")

    self.refresh_btn = self:AddComponent(UIButton, refresh_btn_path)
    self.refresh_btn:SetOnClick(function()
        self.ctrl:Refresh()
    end)
end

local function OnScoreChange(self, score)
	self.score_text:SetText(tostring(score))
end

local function OnAddListener(self)
	base.OnAddListener(self)
	-- UI消息注册
	self:AddUIListener(UIMessageNames.UIGAMEPLAY_SCORE_CHANGE, OnScoreChange)
end

local function OnRemoveListener(self)
	base.OnRemoveListener(self)
	-- UI消息注销
	self:RemoveUIListener(UIMessageNames.UIGAMEPLAY_SCORE_CHANGE, OnScoreChange)
end
local function OnEnable(self)
	base.OnEnable(self)
end

local function OnDestroy(self)
	base.OnDestroy(self)
end

UIGamePlayView.OnCreate = OnCreate
UIGamePlayView.OnEnable = OnEnable
UIGamePlayView.OnDestroy = OnDestroy
UIGamePlayView.OnAddListener = OnAddListener
UIGamePlayView.OnRemoveListener = OnRemoveListener

return UIGamePlayView
