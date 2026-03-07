local UILoginServerCtrl = BaseClass("UILoginServerCtrl", UIBaseCtrl)

local function Back(self)
	SceneManager:GetInstance():SwitchScene(SceneConfig.HomeScene)
end

UILoginServerCtrl.Back = Back

return UILoginServerCtrl
