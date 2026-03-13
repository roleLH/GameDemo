--[[
-- UIStartMain 控制器占位
--]]

local UIStartMainCtrl = BaseClass("UIStartMainCtrl", UIBaseCtrl)

local function Back(self)
	UIManager:GetInstance():OpenWindow(UIWindowNames.UIGamePlay)
	-- SceneManager:GetInstance():SwitchScene(SceneConfig.MainScene)
end

UIStartMainCtrl.Back = Back

return UIStartMainCtrl