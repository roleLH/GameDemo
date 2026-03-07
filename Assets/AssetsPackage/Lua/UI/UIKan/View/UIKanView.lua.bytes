--[[
-- added by wsh @ 2018-02-26
-- UIBattleMain视图层
--]]

local UIKanView = BaseClass("UIKanView", UIBaseView)
local base = UIBaseView

-- 各个组件路径
local back_btn_path = "Button"

local function OnCreate(self)
	base.OnCreate(self)
	-- 退出按钮
	self.back_btn = self:AddComponent(UIButton, back_btn_path)
	self.back_btn:SetOnClick(function()
		self.ctrl:Back()
	end)
end

local function OnEnable(self)
	base.OnEnable(self)
end

local function OnDestroy(self)
	base.OnDestroy(self)
end

UIKanView.OnCreate = OnCreate
UIKanView.OnEnable = OnEnable
UIKanView.OnDestroy = OnDestroy

return UIKanView