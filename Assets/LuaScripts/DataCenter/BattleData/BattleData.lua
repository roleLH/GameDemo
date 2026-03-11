
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
    self.clickgrid = {}
end

local function SetGameScore(self, score)
	self.score = score
end
local function GetGameScore(self)
	return self.score
end

local function AddNewBlock(self, id, floorIndex, block, _type)
	self.gridData[id] = self.gridData[id] or {row = 0, col = 0, blocks = {}}
	-- if not self.gridData[id].blocks[floorIndex] then
	-- 	self.gridData[id].blocks[floorIndex] = {}
	-- end
	-- table.insert(self.gridData[id].blocks[floorIndex],{prefab = block, _type = _type})
    self.gridData[id].blocks[floorIndex] = {prefab = block, _type = _type}
end

local function RemoveBlock(self, id, floorIndex)

    local cell = self.gridData[id]
    if not cell then
        return
    end

    cell.blocks[floorIndex] = nil
    -- local floor = cell.blocks[floorIndex]
    -- if not floor then
    --     return
    -- end

    -- for i = #floor, 1, -1 do
    --     if floor[i].prefab == block then
    --         table.remove(floor, i)
    --         break
    --     end
    -- end
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
local function OnClickGrid(self, id, floor)
    table.insert(self.clickgrid, {id = id, floor = floor})
    if #self.clickgrid == 2 then
        return true
    end
    return false
end

local function OnCheckCanRemove(self)
    local blocks = {}
    for k,v in ipairs(self.clickgrid) do
        table.insert(blocks, self.gridData[v.id].blocks[v.floor])
    end
    self.clickgrid = {}
    if #blocks == 2 and blocks[1]._type == blocks[2]._type then
        -- 可以消除，执行消除逻辑
        -- 在这里把缓存删了，然后回view层删除预设
        for k,v in pairs(self.clickgrid) do
            -- local block = self.gridData[v.id].blocks[v.floor][#self.gridData[v.id].blocks[v.floor]]
            self:RemoveBlock(v.id, v.floor)
        end
    else
        return false, blocks
    end

    return true, blocks
end

BattleData.__init = __init
BattleData.SetGameScore = SetGameScore
BattleData.GetGameScore = GetGameScore
BattleData.AddNewBlock = AddNewBlock
BattleData.GetTopBlock = GetTopBlock
BattleData.RemoveBlock = RemoveBlock
BattleData.OnClickGrid = OnClickGrid
BattleData.OnCheckCanRemove = OnCheckCanRemove

return BattleData