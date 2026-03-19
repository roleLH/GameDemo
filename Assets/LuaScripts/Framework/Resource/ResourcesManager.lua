--[[
-- added by wsh @ 2017-12-01
-- 资源管理系统：提供资源加载管理
-- 注意：
-- 1、只提供异步接口，即使内部使用的是同步操作，对外来说只有异步
-- 2、两套API：使用回调（任何不带"Co"的接口）、使用协程（任何带"Co"的接口）
-- 3、对于串行执行一连串的异步操作，建议使用协程（用同步形式的代码写异步逻辑），回调方式会使代码难读
-- 4、所有lua层脚本别直接使用cs侧的AssetBundleManager，都来这里获取接口
-- 5、理论上做到逻辑层脚本对AB名字是完全透明的，所有资源只有packagePath的概念，这里对路径进行处理
--]]

local ResourcesManager = BaseClass("ResourcesManager", Singleton)
local AssetBundleManager = CS.AssetBundles.AssetBundleManager.Instance

-- 异步加载Asset：回调形式
local function LoadAsync(self, path, res_type, callback, ...)
	assert(path ~= nil and type(path) == "string" and #path > 0, "path err : "..path)
	assert(callback ~= nil and type(callback) == "function", "Need to provide a function as callback")
	local args = SafePack(...)
	AssetBundleManager:LoadAssetAsync(path, res_type, function(handle) 
		local go = handle.Result
		callback(go, SafeUnpack(args))
	end)
	
end

-- 异步加载Asset：协程形式
local function CoLoadAsync(self, path, res_type, progress_callback)
	return nil
end

-- 清理资源：切换场景时调用
local function Cleanup(self)
	
end

ResourcesManager.LoadAsync = LoadAsync
ResourcesManager.CoLoadAsync = CoLoadAsync
ResourcesManager.Cleanup = Cleanup

ResourcesManager.LoadAssetAsync = function(self, path, type, func) 
	AssetBundleManager:LoadAssetAsync(path, type, function(handle)
		local go = handle.Result
		-- go.asset_handle = handle
		func(go)
	end)
end

ResourcesManager.UnloadAsset = function(go) 
	if go and go.asset_handle then 
		AssetBundleManager:UnloadAsset(go.asset_handle)
	end
end

return ResourcesManager
