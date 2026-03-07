local UIGamePlay = {
	Name = UIWindowNames.UIGamePlay,
	Layer = UILayers.NormalLayer,
	Model = require "UI.UIGamePlay.Model.UIGamePlayModel",
	Ctrl = require "UI.UIGamePlay.Controller.UIGamePlayCtrl",
	View = require "UI.UIGamePlay.View.UIGamePlayView",
	PrefabPath = "UI/Prefabs/View/UIGamePlay.prefab",
}

return {
	-- 配置
	UIGamePlay = UIGamePlay,
}
