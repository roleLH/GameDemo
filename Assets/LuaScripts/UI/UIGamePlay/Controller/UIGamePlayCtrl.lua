local UIGamePlayCtrl = BaseClass("UIGamePlayCtrl", UIBaseCtrl)
local function Refresh(self)
    self.model:OnScoreChange(tostring(math.random(1000,100000)))
end

UIGamePlayCtrl.Refresh = Refresh
return UIGamePlayCtrl