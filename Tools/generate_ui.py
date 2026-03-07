import os
from pathlib import Path

# 项目 UI 根目录（根据需要修改）
UI_ROOT = Path(__file__).parent.parent / "Assets" / "LuaScripts" / "UI"
CONFIG_DIR = UI_ROOT / "Config"
UI_CONFIG_PATH = CONFIG_DIR / "UIConfig.lua"
UI_WINDOW_NAMES_PATH = CONFIG_DIR / "UIWindowNames.lua"

TEMPLATE_CONFIG = """--[[
-- auto generated
-- UI module config
--]]

local {module_var} = {{
    Name = UIWindowNames.{module_name},
    Layer = UILayers.NormalLayer,
    Model = nil,
    Ctrl = require "UI.{module_name}.Controller.{module_name}Ctrl",
    View = require "UI.{module_name}.View.{module_name}View",
    PrefabPath = "UI/Prefabs/View/{module_name}.prefab",
}}

return {{
    {module_name} = {module_var},
}}
"""

TEMPLATE_VIEW = """--[[
-- auto generated
-- {module_name} 视图层
--]]

local {class_name} = BaseClass("{class_name}", UIBaseView)
local base = UIBaseView

-- 各个组件路径
local back_btn_path = "Button"

local function OnCreate(self)
    base.OnCreate(self)
    -- 退出/开始按钮
    self.back_btn = self:AddComponent(UIButton, back_btn_path)
    self.back_btn:SetOnClick(function()
        self.ctrl:Back()
    end)
end

local function OnEnable(self)
    base.OnEnable(self)
end

local function OnDestroy(self)
    base.OnDestroy(self)
end

{class_name}.OnCreate = OnCreate
{class_name}.OnEnable = OnEnable
{class_name}.OnDestroy = OnDestroy

return {class_name}
"""

TEMPLATE_CTRL = """--[[
-- auto generated
-- {module_name} 控制器占位
--]]

local {class_name} = BaseClass("{class_name}", UIBaseCtrl)

local function Back(self)
    SceneManager:GetInstance():SwitchScene(SceneConfig.LoginScene)
end

{class_name}.Back = Back

return {class_name}
"""

UI_CONFIG_HEADER = """-- filepath: {path}
--[[
-- added by script
-- UI模块配置表，添加新UI模块时需要在此处加入
--]]
"""

UI_CONFIG_MERGE = """
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
"""

WINDOW_NAMES_HEADER = """-- filepath: {path}
--[[
-- added by script
-- UI窗口名字定义，手动添加
--]]
"""

def create_module(module_name: str):
    module_dir = UI_ROOT / module_name
    ctrl_dir = module_dir / "Controller"
    view_dir = module_dir / "View"
    module_dir.mkdir(parents=True, exist_ok=True)
    ctrl_dir.mkdir(parents=True, exist_ok=True)
    view_dir.mkdir(parents=True, exist_ok=True)

    # Config file
    cfg_path = module_dir / f"{module_name}Config.lua"
    cfg_content = TEMPLATE_CONFIG.format(module_var=module_name, module_name=module_name)
    cfg_path.write_text(cfg_content, encoding="utf-8")

    # View file
    view_path = view_dir / f"{module_name}View.lua"
    view_content = TEMPLATE_VIEW.format(class_name=f"{module_name}View", module_name=module_name)
    view_path.write_text(view_content, encoding="utf-8")

    # Ctrl file
    ctrl_path = ctrl_dir / f"{module_name}Ctrl.lua"
    ctrl_content = TEMPLATE_CTRL.format(class_name=f"{module_name}Ctrl", module_name=module_name)
    ctrl_path.write_text(ctrl_content, encoding="utf-8")

    print(f"生成模块: {module_name} -> {module_dir}")

def scan_ui_modules():
    names = []
    for p in sorted(UI_ROOT.iterdir()):
        if p.is_dir() and p.name != "Config" and not p.name.startswith("."):
            names.append(p.name)
    return names

def write_ui_config(modules):
    lines = [UI_CONFIG_HEADER.format(path=UI_CONFIG_PATH)]
    lines.append("local UIModule = {")
    for m in modules:
        lines.append(f'\t{m} = require "UI.{m}.{m}Config",')
    lines.append("}\n")
    lines.append(UI_CONFIG_MERGE)
    UI_CONFIG_PATH.parent.mkdir(parents=True, exist_ok=True)
    UI_CONFIG_PATH.write_text("\n".join(lines), encoding="utf-8")
    print(f"写入 UIConfig: {UI_CONFIG_PATH}")

def write_window_names(modules):
    lines = [WINDOW_NAMES_HEADER.format(path=UI_WINDOW_NAMES_PATH)]
    lines.append("local UIWindowNames = {")
    for m in modules:
        lines.append(f"\t{m} = \"{m}\",")
    lines.append("}\n")
    lines.append('return ConstClass("UIWindowNames", UIWindowNames)')
    UI_WINDOW_NAMES_PATH.write_text("\n".join(lines), encoding="utf-8")
    print(f"写入 UIWindowNames: {UI_WINDOW_NAMES_PATH}")

def main():
    module_name = input("输入 UI 模块名（例如 UIStartMain 或 UIGamePlay）: ").strip()
    if not module_name:
        print("模块名为空，退出。")
        return
    create_module(module_name)
    modules = scan_ui_modules()
    write_ui_config(modules)
    write_window_names(modules)
    print("完成。")

if __name__ == "__main__":
    main()