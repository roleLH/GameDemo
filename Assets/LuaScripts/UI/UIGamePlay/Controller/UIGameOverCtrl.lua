
local UIGameOverCtrl = BaseClass("UIGameOverCtrl", UIBaseCtrl)

local function NextGame(self)
    --@TODO 这里可以添加一些过渡动画或者界面
	-- SceneManager:GetInstance():SwitchScene(SceneConfig.MainScene)
	SceneManager:GetInstance():SwitchSameScene(SceneConfig.MainScene)
    -- UIManager:GetInstance():CloseWindow(UIWindowNames.UIGameOver)
    -- UIManager:GetInstance():OpenWindow(UIWindowNames.UIGamePlay)
    -- self.model:OnNextGame()
end

UIGameOverCtrl.NextGame = NextGame

return UIGameOverCtrl