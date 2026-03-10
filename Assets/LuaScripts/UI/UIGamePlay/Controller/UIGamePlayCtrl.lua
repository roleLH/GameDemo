local RaycastHelper = CS.RaycastHelper.Instance

local UIGamePlayCtrl = BaseClass("UIGamePlayCtrl", UIBaseCtrl)
local function Refresh(self)
    self.model:OnScoreChange(tostring(math.random(1000,100000)))
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
    local results = CS.RaycastHelper.GetMouseUIRaycastResults(raycaster)

    if results and results.Count > 0 then
        -- 第一个就是最上层点击的对象
        local topObj = results[0].gameObject
        local name = topObj.name
        local item = topObj:GetComponent(typeof(CS.GridItem))
        if item then
            Logger.Log("Clicked on grid item: " .. name .. " at gridid (" .. item.gridId .. ", floor" .. item.floor .. ")")
        end

        -- 执行逻辑，比如消除
        -- local gridItem = topObj:GetComponent(typeof(CS.GridItem)) -- 你的格子脚本
        -- if gridItem then
        --     self.model:OnClickGrid(gridItem.gridX, gridItem.gridY)
        -- end
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
UIGamePlayCtrl.AddMouseClickEvent = AddMouseClickEvent
return UIGamePlayCtrl