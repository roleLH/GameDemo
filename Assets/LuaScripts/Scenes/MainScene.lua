--[[
-- added by copilot @ 2026-03-06
-- 主场景（点击开始）
--]]

local MainScene = BaseClass("MainScene", BaseScene)
local base = BaseScene

-- 创建：准备预加载资源
local function OnCreate(self)
    base.OnCreate(self)
    self:AddPreloadResource(UIConfig[UIWindowNames.UIStartMain].PrefabPath, typeof(CS.UnityEngine.GameObject), 1)
end

-- 准备工作
local function OnComplete(self)
    base.OnComplete(self)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIStartMain)
end

-- 离开场景
local function OnLeave(self)
    UIManager:GetInstance():CloseWindow(UIWindowNames.UIStartMain)
    base.OnLeave(self)
end

MainScene.OnCreate = OnCreate
MainScene.OnComplete = OnComplete
MainScene.OnLeave = OnLeave

return MainScene;
