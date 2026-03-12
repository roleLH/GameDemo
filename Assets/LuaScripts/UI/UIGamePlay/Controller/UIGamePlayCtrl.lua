local RaycastHelper = CS.RaycastHelper.Instance

local UIGamePlayCtrl = BaseClass("UIGamePlayCtrl", UIBaseCtrl)
local function Refresh(self)
    local time = os.time()
    -- self.model:OnScoreChange(tostring(math.random(1000,100000)))
    -- for i = 1, 10 do
    while true do
        local new_time = os.time()
        if new_time - time > 5 then
            break
        end
        local block1, block2 = BattleData:GetInstance():GetRandomMatchingTypes()
        if block1 == nil or block2 == nil then
            Logger.Log("No more matching blocks available.")
            break
        end
        self.model:OnClickGrid(block1)
        self.model:OnClickGrid(block2)
    end
end

local function getNormalLayer(self)-- 找到 NormalLayer
    local parent = self.transform
    while parent ~= nil do
        if parent.name == "NormalLayer" then
            return parent
        end
        parent = parent.parent
    end
    return nil
end
-- 点击检测函数
local function OnPointerClick(self, view)

    -- local layer = getNormalLayer(view)
    -- if not layer then return end
    -- loacl layer = view.transform:Find("UIGamePlay")
    local raycaster = view.canvas.unity_graphic_raycaster
    local check_area = view.transform:Find("FloorArea")
    local results = CS.RaycastHelper.GetMouseUIRaycastResults(raycaster, check_area.transform, UIManager:GetInstance().UICamera)

    if results and results.Count > 0 then
        -- 第一个就是最上层点击的对象
        local topObj = results[0].gameObject
        local name = topObj.name
        local item = topObj:GetComponent(typeof(CS.GridItem))
        if item then
            Logger.Log("Clicked on grid item: " .. name .. " at gridid (" .. item.gridId .. ", floor" .. item.floor .. ")")
        end

        self.model:OnClickGrid(topObj)
    end
end

-- 每帧检测鼠标点击
local function Update(self, view)
     if CS.UnityEngine.Input.GetMouseButtonDown(0) then
        OnPointerClick(self, view)
    end
end

UIGamePlayCtrl.Update = Update
UIGamePlayCtrl.Refresh = Refresh
-- UIGamePlayCtrl.AddMouseClickEvent = AddMouseClickEvent
return UIGamePlayCtrl