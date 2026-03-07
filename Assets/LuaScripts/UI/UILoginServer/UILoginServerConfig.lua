local UILoginServer = {
	Name = UIWindowNames.UILoginServer,
	Layer = UILayers.NormalLayer,
	Model = nil,
	Ctrl = require "UI.UILoginServer.Controller.UILoginServerCtrl",
	View = require "UI.UILoginServer.View.UILoginServerView",
	PrefabPath = "UI/Prefabs/View/UILoginServer.prefab",
}

return {
	-- 配置
	UILoginServer = UILoginServer,
}
