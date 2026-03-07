--[[
-- added by copilot @ 2026-03-06
-- UIMain 模块窗口配置，要使用还需要导出到 UI.Config.UIConfig.lua
--]]

local UIStartMain = {
    Name = UIWindowNames.UIStartMain,
    Layer = UILayers.NormalLayer,
    Model = nil,
    Ctrl = require "UI.UIStartMain.Controller.UIStartMainCtrl",
    View = require "UI.UIStartMain.View.UIStartMainView",
    PrefabPath = "UI/Prefabs/View/UIStartMain.prefab",
}

return {
    UIStartMain = UIStartMain,
}
