-- filepath: E:\ProjectGame\GameDemo\Assets\LuaScripts\UI\Config\UIConfig.lua
--[[
-- added by script
-- UI模块配置表，添加新UI模块时需要在此处加入
--]]

local UIModule = {
    UIKan = require "UI.UIKan.UIKanConfig",
    UILoading = require "UI.UILoading.UILoadingConfig",
    UILogin = require "UI.UILogin.UILoginConfig",
    -- UILoginServer = require "UI.UILoginServer.UILoginServerConfig",
    UIStartMain = require "UI.UIStartMain.UIStartMainConfig",
    UITestMain = require "UI.UITestMain.UITestMainConfig",
    UIGamePlay = require "UI.UIGamePlay.UIGamePlayConfig",
    -- UIGameOver = require "UI.UIGamePlay.UIGamePlayConfig",
}


local UIConfig = {}
for _,ui_module in pairs(UIModule) do 
    for _,ui_config in pairs(ui_module) do
        local ui_name = ui_config.Name
        assert(UIConfig.ui_name == nil, "Aready exsits : "..ui_name)
        if ui_config.View then
            assert(ui_config.PrefabPath ~= nil and #ui_config.PrefabPath > 0, ui_name.." PrefabPath empty.")
        end
        UIConfig[ui_name] = ui_config
    end
end

return ConstClass("UIConfig", UIConfig)
