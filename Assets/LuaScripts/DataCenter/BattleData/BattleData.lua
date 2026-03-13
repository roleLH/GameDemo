
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
    self.gameover = false
end

local function AddGameScore(self, score)
	self.score = self.score + score
end

local function GetGameScore(self)
	return self.score
end

local function AddNewBlock(self, id, floorIndex, block, _type)
	self.gridData[id] = self.gridData[id] or {row = 0, col = 0, blocks = {}}
    self.gridData[id].blocks[floorIndex] = {prefab = block, _type = _type}
end

local function RemoveBlock(self, id, floorIndex)

    local cell = self.gridData[id]
    if not cell then
        return
    end

    cell.blocks[floorIndex] = nil
    if #cell.blocks == 0 then
        self.gridData[id] = nil
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
local function OnClickGrid(self, object)
    local item = object:GetComponent(typeof(CS.GridItem))
    local id = item.gridId
    local floor = item.floor
    local _type = item._type
    -- 判断下当前点击和第一个点击是不是同一个
    if #self.clickgrid > 0 then
        local last = self.clickgrid[#self.clickgrid]
        local lastobject = self.gridData[last.id].blocks[last.floor].prefab
        local lastitem = lastobject:GetComponent(typeof(CS.GridItem))
        if lastitem.gridId == id and lastitem.floor == floor then
            return false
        end
    end
    table.insert(self.clickgrid, {id = id, floor = floor, _type = _type})
    if #self.clickgrid == 2 then
        return true
    end
    return false
end

local function OnCheckCanRemove(self)
    local blocks = {}
    for k,v in ipairs(self.clickgrid) do
        local prefab = self.gridData[v.id].blocks[v.floor].prefab
        table.insert(blocks, {prefab = prefab, _type = v._type, id = v.id, floor = v.floor})
        -- table.insert(blocks, v)
    end
    self.clickgrid = {}
    if #blocks == 2 and blocks[1]._type == blocks[2]._type then
        -- 可以消除，执行消除逻辑
        -- 在这里把缓存删了，然后回view层删除预设
        for k,v in pairs(blocks) do
            -- local block = self.gridData[v.id].blocks[v.floor][#self.gridData[v.id].blocks[v.floor]]
            self:RemoveBlock(v.id, v.floor)
        end
    else
        return false, blocks
    end

    if self.gridData == nil or next(self.gridData) == nil then
        self:SetGameOver()
        return true, blocks, true
    end

    return true, blocks
end

local function GetRandomMatchingTypes(self)
    -- 收集所有块到一个列表
    local allBlocks = {}
    for id, cell in pairs(self.gridData) do
        -- 取最高层
        local floor = #cell.blocks
        local block = cell.blocks[floor]
        table.insert(allBlocks, {
            id = id,
            floor = floor,
            _type = block._type,
            prefab = block.prefab
        })
        -- for floor, block in pairs(cell.blocks) do
        -- end
    end

    -- 如果块少于2个，无法匹配
    if #allBlocks < 2 then
        return nil, nil  -- 或抛出错误
    end

    -- 随机选择第一个块
    local firstIndex = math.random(1, #allBlocks)
    local firstBlock = allBlocks[firstIndex]
    local targetType = firstBlock._type

    -- 从剩余块中找到另一个相同 _type 的块
    local matchingBlocks = {}
    for i, block in ipairs(allBlocks) do
        if i ~= firstIndex and block._type == targetType then
            table.insert(matchingBlocks, block)
        end
    end

    -- 如果没有匹配的块，返回 nil
    if #matchingBlocks == 0 then
        return nil, nil
    end

    -- 随机选择一个匹配的块
    local secondIndex = math.random(1, #matchingBlocks)
    local secondBlock = matchingBlocks[secondIndex]

    -- 返回两个 _type（相同）
    return firstBlock.prefab, secondBlock.prefab
end

local function GetData(self)
	return self.gridData
end

local function ClearData(self)
	self.score = 0
	self.gridData = {}
    self.clickgrid = {}
    self.gameover = false
end

local function SetGameOver(self)
    self.gameover = true
end
local function GetGameOver(self)
    return self.gameover
end
BattleData.__init = __init
BattleData.AddGameScore = AddGameScore
BattleData.GetGameScore = GetGameScore
BattleData.AddNewBlock = AddNewBlock
BattleData.GetTopBlock = GetTopBlock
BattleData.RemoveBlock = RemoveBlock
BattleData.OnClickGrid = OnClickGrid
BattleData.OnCheckCanRemove = OnCheckCanRemove
BattleData.GetRandomMatchingTypes = GetRandomMatchingTypes
BattleData.ClearData = ClearData
BattleData.GetData = GetData
BattleData.SetGameOver = SetGameOver
BattleData.GetGameOver = GetGameOver

return BattleData