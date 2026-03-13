local UIGamePlay = {
	Name = UIWindowNames.UIGamePlay,
	Layer = UILayers.NormalLayer,
	Model = require "UI.UIGamePlay.Model.UIGamePlayModel",
	Ctrl = require "UI.UIGamePlay.Controller.UIGamePlayCtrl",
	View = require "UI.UIGamePlay.View.UIGamePlayView",
	PrefabPath = "UI/Prefabs/View/UIGamePlay.prefab",
}
local UIGameOver = {
	Name = UIWindowNames.UIGameOver,
	Layer = UILayers.NormalLayer,
	Model = require "UI.UIGamePlay.Model.UIGameOverModel",
	Ctrl = require "UI.UIGamePlay.Controller.UIGameOverCtrl",
	View = require "UI.UIGamePlay.View.UIGameOverView",
	PrefabPath = "UI/Prefabs/View/UIGameOver.prefab",
}
return {
	-- 配置
	UIGamePlay = UIGamePlay,
	UIGameOver = UIGameOver,
}
