local UIGamePlayView = BaseClass("UIGamePlayView", UIBaseView)
local base = UIBaseView

-- 各个组件路径
local score_text_path = "TopUI/UIGameScore/GameScoreText"
local refresh_btn_path = "ItemUI/RefreshBtn"
local next_game_btn_path = "ItemUI/RefreshBtn2"

local ice_grid_path = "UI/Prefabs/common/IceGrid.prefab"
local gameplay_icon_path = "UI/Prefabs/common/GamePlayIcon.prefab"
local waikuang_res_path = "UI/Prefabs/common/WaiKuang.prefab"

local block_res_path = "UI/Image/GamePlay"

local ROW = 14
local COL = 9
local CELL_SIZE = 98   -- 格子大小，和GridLayout一致
local TYPE_COUNT = 10   -- 类型数量

local function OnCreate(self)
	base.OnCreate(self)

	self.score_text = self:AddComponent(UITMP, score_text_path)
	self.score_text:SetText("asd123596")

    self.refresh_btn = self:AddComponent(UIButton, refresh_btn_path)
    self.refresh_btn:SetOnClick(function()
        self.ctrl:Refresh()
    end)
    self.refresh_btn2 = self:AddComponent(UIButton, next_game_btn_path)
    self.refresh_btn2:SetOnClick(function()
        self.ctrl:Refresh2()
    end)

	self:StartNewGame()
end

local function Generate(n, m, floors, typecount)
	-- 工具函数：洗牌
	local function shuffle(t)
		for i = #t, 2, -1 do
			local j = math.random(i)
			t[i], t[j] = t[j], t[i]
		end
	end

	-- 检查某列是否在已有 floor 重复
	local function isValid(floorTable, col, candidate)
		for _, f in ipairs(floorTable) do
			if f[col] == candidate then return false end
		end
		return true
	end

	-- 生成每层格子
	local floorsData = {}
	for f = 1, floors do
		local floor = {}
		local layerTypes = {}
		-- 每层严格两两配对
		local needed = (n*m)/2
		for i = 1, needed do
			local _type = math.random(1, typecount)
			layerTypes[#layerTypes+1] = _type
			layerTypes[#layerTypes+1] = _type
		end
		shuffle(layerTypes)

		-- 避免同列同 floor 重复
		for i = 1, n*m do
			local candidate = layerTypes[i]
			if not isValid(floorsData, i, candidate) then
				-- 找一个可以用的 type
				for j = i+1, #layerTypes do
					if isValid(floorsData, i, layerTypes[j]) then
						layerTypes[i], layerTypes[j] = layerTypes[j], layerTypes[i]
						break
					end
				end
			end
			floor[i] = layerTypes[i]
		end
		floorsData[f] = floor
	end
	return floorsData
end

function GenerateGrid(n, m, floor, typeCount)

    local total = n * m
    assert(total % 2 == 0, "grid数量必须是偶数")

    local result = {}

    -- 初始化grid
    for i = 1, total do
        result[i] = {}
    end

    for f = 1, floor do

        local fruits = {}

        -- 生成pair
        for i = 1, total / 2 do
            local t = math.random(1, typeCount)
            table.insert(fruits, t)
            table.insert(fruits, t)
        end

        -- shuffle
        for i = total, 2, -1 do
            local j = math.random(1, i)
            fruits[i], fruits[j] = fruits[j], fruits[i]
        end

        -- 填入grid，并保证不同floor不同type
        for id = 1, total do

            local t = fruits[id]

            if f > 1 then
                while t == result[id][f - 1] do
                    t = math.random(1, typeCount)
                end
            end

            result[id][f] = t
        end

    end

    return result
end

-- 游玩用的Block，生成在Floor上
local function GenerateFloorBlock(self, floorName, results)
    local floor = CS.UnityEngine.GameObject.Find("FloorArea/Floor"..floorName)
    for r = 1, ROW do
        for c = 1, COL do
            GameObjectPool:GetInstance():GetGameObjectAsync(gameplay_icon_path, function(inst)
            	local id = (r - 1) * COL + c

				-- 设置父物体
                inst.transform:SetParent(floor.transform, false)

				-- 设置位置
                local rect = inst.transform
                -- local rect = inst:GetComponent(typeof(CS.UnityEngine.RectTransform))
                local x = (c - 1) * CELL_SIZE + floorName
                local y = -(r - 1) * CELL_SIZE + floorName
                rect.anchoredPosition = CS.UnityEngine.Vector2(x, y)

				-- 设置名字
				inst.gameObject.name = "GamePlayIcon_"..id.."_Floor"..floorName

				-- 设置block类型，随机生成一个类型，存储到BattleData中
			local _type = results[floorName][c + (r - 1) * COL]
				BattleData:GetInstance():AddNewBlock(id, tonumber(floorName), inst, _type)

				-- 设置格子组件，记录格子id和floor
				local item = inst:GetComponent(typeof(CS.GridItem))
				item.gridId = id
				item.floor = tonumber(floorName)
				item._type = _type
				-- local fruit = UIUtil.GetChild(inst.transform, 0)

				-- 设置图标，底图，外框
				local fruit = inst.transform:Find("Fruit")
				fruit.gameObject.name = "Fruit"..id.."_Floor"..floorName
				local block_sprite_name = _type..".png"
				local atlas_config = {AtlasPath = block_res_path}
				local image = self:AddComponent(UIImage, fruit.gameObject, atlas_config)
				image:SetSpriteName(block_sprite_name)

            end)

        end
    end
end
-- 底图
local function OnGenerateIceGrid(self)
	for i = 1, ROW * COL, 1 do
		GameObjectPool:GetInstance():GetGameObjectAsync(ice_grid_path, function(inst)
			if IsNull(inst) then
				error("Load chara res err!")
				do return end
			end

			local chara_root = CS.UnityEngine.GameObject.Find("GridArea")
			if IsNull(chara_root) then
				error("chara_root null!")
				do return end
			end

			inst.transform:SetParent(chara_root.transform, false)
		end)
	end
end

local function OnScoreChange(self)
	local score = BattleData:GetInstance():GetGameScore()
	self.score_text:SetText(score)
end

local function SetOnClickGrid(self, select_object)
    local item = select_object:GetComponent(typeof(CS.GridItem))
	local id = item.gridId
	local floor = item.floor
	Logger.Log("点击了格子 id:"..id.." floor:"..floor)
	local frame = select_object.transform:Find("waikuang")
	frame.gameObject:SetActive(true)

	-- local fruit = UIUtil.GetChild(select_object.transform, 0)
	-- local image = fruit:GetComponent(typeof(CS.UnityEngine.UI.Image))
	-- Logger.Log("Highlight material: " .. tostring(image.material.name))
	-- local mat = image.material
	-- mat:SetFloat("_Highlight", 5)
end

local function OnRemoveBlock(self, canRemove, blocks, over)
	-- 能移除，把俩预设删了
	if canRemove then
		-- 不能移除，删除waikuang
		for k,v in pairs(blocks) do
			local block = v.prefab
			GameObjectPool:GetInstance():RecycleGameObject(gameplay_icon_path, block.gameObject)

			-- local fruit = UIUtil.GetChild(block.transform, 0)
			-- local image = fruit:GetComponent(typeof(CS.UnityEngine.UI.Image))
			-- local mat = image.material
			-- mat:SetFloat("_Highlight", 1)
		end
		BattleData:GetInstance():AddGameScore(10)
		self:OnScoreChange()
	else
		-- 不能移除，删除waikuang
		for k,v in pairs(blocks) do
			local block = v.prefab
			if block.transform.childCount > 0 then
				local frame = block.transform:Find("waikuang")
				frame.gameObject:SetActive(false)
				-- GameObjectPool:GetInstance():RecycleGameObject(waikuang_res_path, child.gameObject)
			end
			-- local fruit = UIUtil.GetChild(block.transform, 0)
			-- local image = fruit:GetComponent(typeof(CS.UnityEngine.UI.Image))
			-- local mat = image.material
			-- mat:SetFloat("_Highlight", 1)
		end
	end
	if over then
		self.ctrl:Refresh2()
	end
end

--先清除全部数据，再重新设置
local function StartNewGame(self)
	-- local data = BattleData:GetInstance():GetData()
	-- for k,v in pairs(data) do
	-- 	for k2,v2 in pairs(v.blocks) do
	-- 		local block = v2.prefab
	-- 		GameObjectPool:GetInstance():RecycleGameObject(gameplay_icon_path, block.gameObject)
	-- 	end
	-- end
	BattleData:GetInstance():ClearData()
	-- GameObjectPool.Cleanup()
	self:OnScoreChange()
	-- self:OnGenerateIceGrid()
	-- self:GenerateFloorBlock(1)
	-- self:GenerateFloorBlock(2)
	local results = Generate(ROW, COL, 3, TYPE_COUNT)
	for i = 1, 3 do
		 self:GenerateFloorBlock(i, results)
	end
end

local function OnAddListener(self)
	base.OnAddListener(self)
	-- UI消息注册
	self:AddUIListener(UIMessageNames.UIGAMEPLAY_SCORE_CHANGE, OnScoreChange)
	self:AddUIListener(UIMessageNames.UIGAMEPLAY_ON_CLICK_GRID, SetOnClickGrid)
	self:AddUIListener(UIMessageNames.UIGAMEPLAY_REMOVE_BLOCK, OnRemoveBlock)
	self:AddUIListener(UIMessageNames.UIGAMEPLAY_NEXT_GAME, StartNewGame)
end

local function OnRemoveListener(self)
	base.OnRemoveListener(self)
	-- UI消息注销
	self:RemoveUIListener(UIMessageNames.UIGAMEPLAY_SCORE_CHANGE, OnScoreChange)
	self:RemoveUIListener(UIMessageNames.UIGAMEPLAY_ON_CLICK_GRID, SetOnClickGrid)
	self:RemoveUIListener(UIMessageNames.UIGAMEPLAY_REMOVE_BLOCK, OnRemoveBlock)
	self:RemoveUIListener(UIMessageNames.UIGAMEPLAY_NEXT_GAME, StartNewGame)
end
local function OnEnable(self)
	base.OnEnable(self)
end

local function OnDestroy(self)
	base.OnDestroy(self)
end

local function Update(self)
	self.ctrl:Update(self)
end

UIGamePlayView.OnCreate = OnCreate
UIGamePlayView.OnEnable = OnEnable
UIGamePlayView.OnDestroy = OnDestroy
UIGamePlayView.OnAddListener = OnAddListener
UIGamePlayView.OnRemoveListener = OnRemoveListener
UIGamePlayView.OnGenerateIceGrid = OnGenerateIceGrid
UIGamePlayView.GenerateFloorBlock = GenerateFloorBlock
UIGamePlayView.Update = Update
UIGamePlayView.StartNewGame = StartNewGame
UIGamePlayView.OnScoreChange = OnScoreChange

return UIGamePlayView
