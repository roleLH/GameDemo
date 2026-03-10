
local BattleData = BaseClass("BattleData", Singleton)

local MAX_FLOOR = 3
local function __init(self)
	self.score = 0
	self.gridData = {
		-- [id] = {
		-- 	row = r,
		-- 	col = c,
		-- 	blocks = {
		-- 		[1] = block1,  -- Floor1
		-- 		[2] = block2,  -- Floor2
		-- 		[3] = block3   -- Floor3
		-- 	}
		-- }
	}
end

local function SetGameScore(self, score)
	self.score = score
end
local function GetGameScore(self)
	return self.score
end

local function AddNewBlock(self, id, floorIndex, block, _type)
	self.gridData[id] = self.gridData[id] or {row = 0, col = 0, blocks = {}}
	if not self.gridData[id].blocks[floorIndex] then
		self.gridData[id].blocks[floorIndex] = {}
	end
	table.insert(self.gridData[id].blocks[floorIndex],{prefab = block, _type = _type})
end

local function RemoveBlock(self, id, floorIndex, block)

    local cell = self.gridData[id]
    if not cell then
        return
    end

    local floor = cell.blocks[floorIndex]
    if not floor then
        return
    end

    for i = #floor, 1, -1 do
        if floor[i].prefab == block then
            table.remove(floor, i)
            break
        end
    end
end

local function GetTopBlock(self, id)

    local cell = self.gridData[id]
    if cell == nil then
        return nil
    end

    for i = MAX_FLOOR, 1, -1 do
        if cell.blocks[i] ~= nil then
            return cell.blocks[i]
        end
    end

    return nil
end

BattleData.__init = __init
BattleData.SetGameScore = SetGameScore
BattleData.GetGameScore = GetGameScore
BattleData.AddNewBlock = AddNewBlock
BattleData.GetTopBlock = GetTopBlock
BattleData.RemoveBlock = RemoveBlock

return BattleData