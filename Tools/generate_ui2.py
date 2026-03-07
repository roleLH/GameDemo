import os

# 路径配置
prefab_root = r"E:\ProjectGame\GameDemo\Assets\AssetsPackage\UI\Prefabs"
lua_root = r"E:\ProjectGame\GameDemo\Assets\LuaScripts\UI"
lua_root2 = r"E:\ProjectGame\GameDemo\Assets\LuaScripts\UI\Config"
config_file_path = os.path.join(lua_root2, "UIConfig.lua")  # 假设主配置文件

# 1. 获取 prefab 文件名列表（去掉 .prefab）
prefab_names = []
for root, dirs, files in os.walk(prefab_root):
    for f in files:
        if f.endswith(".prefab"):
            prefab_names.append(f[:-7])  # 去掉 .prefab

# 2. 获取 Lua UI 文件夹列表
lua_ui_names = [name for name in os.listdir(lua_root) if os.path.isdir(os.path.join(lua_root, name))]

# 3. 找出 prefab 中有但 Lua 中没有的 UI
to_create = [name for name in prefab_names if name not in lua_ui_names]

# 4. 根据模板生成 Lua 文件
for ui_name in to_create:
    ui_path = os.path.join(lua_root, ui_name)
    view_path = os.path.join(ui_path, "View")
    ctrl_path = os.path.join(ui_path, "Controller")

    # 创建文件夹
    os.makedirs(view_path, exist_ok=True)
    os.makedirs(ctrl_path, exist_ok=True)

    # UI Config 文件
    config_file = os.path.join(ui_path, f"{ui_name}Config.lua")
    with open(config_file, "w", encoding="utf-8") as f:
        f.write(f'''local {ui_name} = {{
\tName = UIWindowNames.{ui_name},
\tLayer = UILayers.NormalLayer,
\tModel = nil,
\tCtrl = require "UI.{ui_name}.Controller.{ui_name}Ctrl",
\tView = require "UI.{ui_name}.View.{ui_name}View",
\tPrefabPath = "UI/Prefabs/View/{ui_name}.prefab",
}}

return {{
\t-- 配置
\t{ui_name} = {ui_name},
}}
''')

    # Controller 文件
    ctrl_file = os.path.join(ctrl_path, f"{ui_name}Ctrl.lua")
    with open(ctrl_file, "w", encoding="utf-8") as f:
        f.write(f'''local {ui_name}Ctrl = BaseClass("{ui_name}Ctrl", UIBaseCtrl)

return {ui_name}Ctrl
''')

    # View 文件
    view_file = os.path.join(view_path, f"{ui_name}View.lua")
    with open(view_file, "w", encoding="utf-8") as f:
        f.write(f'''local {ui_name}View = BaseClass("{ui_name}View", UIBaseView)
local base = UIBaseView

-- 各个组件路径
local back_btn_path = "Button"

local function OnCreate(self)
\tbase.OnCreate(self)
end

local function OnEnable(self)
\tbase.OnEnable(self)
end

local function OnDestroy(self)
\tbase.OnDestroy(self)
end

{ui_name}View.OnCreate = OnCreate
{ui_name}View.OnEnable = OnEnable
{ui_name}View.OnDestroy = OnDestroy

return {ui_name}View
''')

print(f"生成完成，共 {len(to_create)} 个 UI: {to_create}")

# 5. 更新 Config.lua
if to_create:
    with open(config_file_path, "r", encoding="utf-8") as f:
        lines = f.readlines()

    # 找到 UIModule 表结束位置 (简单处理，找到最后一个 } 后)
    start_idx = None
    end_idx = None
    for i, line in enumerate(lines):
        if "local UIModule" in line:
            start_idx = i
        if start_idx is not None and line.strip() == "}":
            end_idx = i
            break

    if start_idx is not None and end_idx is not None:
        # 提取现有模块行
        module_lines = lines[start_idx:end_idx+1]
        # 查找最后一行的缩进
        indent = "    "
        # 添加新 UI 模块
        new_lines = []
        for ui_name in to_create:
            line = f'{indent}{ui_name} = require "UI.{ui_name}.{ui_name}Config",\n'
            new_lines.append(line)

        # 插入到 UIModule 内最后一行前
        for i in range(end_idx-1, start_idx, -1):
            if "=" in lines[i]:
                insert_idx = i + 1
                break
        else:
            insert_idx = end_idx

        # 插入新模块
        lines[insert_idx:insert_idx] = new_lines

        # 保存文件
        with open(config_file_path, "w", encoding="utf-8") as f:
            f.writelines(lines)

    print(f"Config.lua 已更新，加入 {len(to_create)} 个 UI 模块")