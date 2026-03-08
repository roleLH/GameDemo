local UIGamePlayView = BaseClass("UIGamePlayView", UIBaseView)
local base = UIBaseView

-- 各个组件路径
local score_text_path = "TopUI/UIGameScore/GameScoreText"
local refresh_btn_path = "ItemUI/RefreshBtn"

local ice_grid_path = "UI/Prefabs/common/IceGrid.prefab"
local function OnCreate(self)
	base.OnCreate(self)

	self.score_text = self:AddComponent(UITMP, score_text_path)
	self.score_text:SetText("asd123596")

    self.refresh_btn = self:AddComponent(UIButton, refresh_btn_path)
    self.refresh_btn:SetOnClick(function()
        self.ctrl:Refresh()
    end)

	self:OnGenerateIceGrid()
end

local function OnGenerateIceGrid()
	for i = 1, 126, 1 do
		GameObjectPool:GetInstance():GetGameObjectAsync(ice_grid_path, function(inst)
			if IsNull(inst) then
				error("Load chara res err!")
				do return end
			end

			local chara_root = CS.UnityEngine.GameObject.Find("GridArea")
			if IsNull(chara_root) then
				error("chara_root null!")
				do return end
			end

			inst.transform:SetParent(chara_root.transform, false)
			-- inst.transform.localPosition = Vector3.New(-7.86, 50, 5.85)

			-- UIManager:GetInstance():OpenWindow(UIWindowNames.UIBattleMain)
		end)
	end
end

local function OnScoreChange(self)
	local score = BattleData:GetInstance():GetGameScore()
	self.score_text:SetText(score)
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
UIGamePlayView.OnGenerateIceGrid = OnGenerateIceGrid

return UIGamePlayView
