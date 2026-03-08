--[[
-- added by wsh @ 2017-12-05
-- 客户端数据
--]]

local ClientData = BaseClass("ClientData", Singleton)

local function __init(self)
	self.score = 0
end

local function SetGameScore(self, score)
	self.score = score
end
local function GetGameScore(self)
	return self.score
end
ClientData.__init = __init
ClientData.SetGameScore = SetGameScore
ClientData.GetGameScore = GetGameScore

return ClientData