local UIGameOverView = BaseClass("UIGameOverView", UIBaseView)
local base = UIBaseView
local next_game_btn_path = "TipWindow/ContinueBtn"
local function OnCreate(self)
    base.OnCreate(self)

    BattleData:GetInstance():SetGameOver(true)
    self.next_btn = self:AddComponent(UIButton, next_game_btn_path)
    self.next_btn:SetOnClick(function()
        self.ctrl:NextGame()
    end)
end

local function OnEnable(self)
    base.OnEnable(self)
end

UIGameOverView.OnCreate = OnCreate
UIGameOverView.OnEnable = OnEnable
return UIGameOverView