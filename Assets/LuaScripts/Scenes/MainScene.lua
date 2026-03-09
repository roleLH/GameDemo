--[[
-- added by copilot @ 2026-03-06
-- 主场景（点击开始）
--]]

local MainScene = BaseClass("MainScene", BaseScene)
local base = BaseScene


local block_res_path1 = "UI/Image/GamePlay/1.png"
local block_res_path2 = "UI/Image/GamePlay/2.png"
local block_res_path3 = "UI/Image/GamePlay/3.png"
local block_res_path4 = "UI/Image/GamePlay/4.png"
local block_res_path5 = "UI/Image/GamePlay/5.png"
local block_res_path6 = "UI/Image/GamePlay/6.png"

-- 创建：准备预加载资源
local function OnCreate(self)
    base.OnCreate(self)
    self:AddPreloadResource(UIConfig[UIWindowNames.UIStartMain].PrefabPath, typeof(CS.UnityEngine.GameObject), 1)
    self:AddPreloadResource(block_res_path1, typeof(CS.UnityEngine.Sprite))
    self:AddPreloadResource(block_res_path2, typeof(CS.UnityEngine.Sprite))
    self:AddPreloadResource(block_res_path3, typeof(CS.UnityEngine.Sprite))
    self:AddPreloadResource(block_res_path4, typeof(CS.UnityEngine.Sprite))
    self:AddPreloadResource(block_res_path5, typeof(CS.UnityEngine.Sprite))
    self:AddPreloadResource(block_res_path6, typeof(CS.UnityEngine.Sprite))
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
