local UIGamePlayView = BaseClass("UIGamePlayView", UIBaseView)
local base = UIBaseView

-- 各个组件路径
local score_text_path = "TopUI/UIGameScore/GameScoreText"
local refresh_btn_path = "ItemUI/RefreshBtn"

local ice_grid_path = "UI/Prefabs/common/IceGrid.prefab"
local gameplay_icon_path = "UI/Prefabs/common/GamePlayIcon.prefab"
local waikuang_res_path = "UI/Prefabs/common/WaiKuang.prefab"

local block_res_path = "UI/Image/GamePlay"

local ROW = 14
local COL = 9
local CELL_SIZE = 98   -- 格子大小，和GridLayout一致

local function OnCreate(self)
	base.OnCreate(self)

	self.score_text = self:AddComponent(UITMP, score_text_path)
	self.score_text:SetText("asd123596")

    self.refresh_btn = self:AddComponent(UIButton, refresh_btn_path)
    self.refresh_btn:SetOnClick(function()
        self.ctrl:Refresh()
    end)

	self:OnGenerateIceGrid()
	self:GenerateFloorBlock(1, 10)
end

-- 游玩用的Block，生成在Floor上
local function GenerateFloorBlock(self, floorName)
    local floor = CS.UnityEngine.GameObject.Find("FloorArea/Floor"..floorName)
    for r = 1, ROW do
        for c = 1, COL do
            local id = (r - 1) * COL + c
            GameObjectPool:GetInstance():GetGameObjectAsync(gameplay_icon_path, function(inst)
                inst.transform:SetParent(floor.transform, false)
				local _type = math.random(1, 6)
				local block_sprite_name = _type..".png"
				local atlas_config = {AtlasPath = block_res_path}

                inst.transform:SetParent(floor.transform, false)

                local rect = inst:GetComponent(typeof(CS.UnityEngine.RectTransform))

                local x = (c - 1) * CELL_SIZE
                local y = -(r - 1) * CELL_SIZE

                rect.anchoredPosition = CS.UnityEngine.Vector2(x, y)

				inst.gameObject.name = "GamePlayIcon_"..id

				local item = inst:GetComponent(typeof(CS.GridItem))
				item.gridId = id
				item.floor = tonumber(floorName)

				BattleData:GetInstance():AddNewBlock(id, tonumber(floorName), inst, _type)
				-- 如果后续改成挂了多个image，这里换一下写法
				-- local gridItem = obj:GetComponent(typeof(CS.GridItem))

				-- if not gridItem then
				-- 	gridItem = obj:GetComponentInParent(typeof(CS.GridItem))
				-- end

				local image = self:AddComponent(UIImage, inst.gameObject, atlas_config)
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

local function SetOnClick(self, id, floor)
    GameObjectPool:GetInstance():GetGameObjectAsync(waikuang_res_path, function(inst)
		local gameObject = CS.UnityEngine.GameObject.Find("FloorArea/Floor"..floor.."/GamePlayIcon_"..id)
        inst.transform:SetParent(gameObject.transform, false)
	end)
end

local function OnRemoveBlock(self, canRemove, blocks)
	-- 能移除，把俩预设删了
	if canRemove then
		-- 不能移除，删除waikuang
		for k,v in pairs(blocks) do
			local block = v.prefab
			GameObjectPool:GetInstance():RecycleGameObject(gameplay_icon_path, block.gameObject)
		end
	else
		-- 不能移除，删除waikuang
		for k,v in pairs(blocks) do
			local block = v.prefab
			if block.transform.childCount > 0 then
				local child = UIUtil.GetChild(block.transform, 0)
				GameObjectPool:GetInstance():RecycleGameObject(waikuang_res_path, child.gameObject)
			end
		end
	end
end

local function OnAddListener(self)
	base.OnAddListener(self)
	-- UI消息注册
	self:AddUIListener(UIMessageNames.UIGAMEPLAY_SCORE_CHANGE, OnScoreChange)
	self:AddUIListener(UIMessageNames.UIGAMEPLAY_ON_CLICK_GRID, SetOnClick)
	self:AddUIListener(UIMessageNames.UIGAMEPLAY_REMOVE_BLOCK, OnRemoveBlock)
end

local function OnRemoveListener(self)
	base.OnRemoveListener(self)
	-- UI消息注销
	self:RemoveUIListener(UIMessageNames.UIGAMEPLAY_SCORE_CHANGE, OnScoreChange)
	self:RemoveUIListener(UIMessageNames.UIGAMEPLAY_ON_CLICK_GRID, SetOnClick)
	self:RemoveUIListener(UIMessageNames.UIGAMEPLAY_REMOVE_BLOCK, OnRemoveBlock)
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

return UIGamePlayView
