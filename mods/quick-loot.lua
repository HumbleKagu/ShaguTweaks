local _G = _G or getfenv(0)

local module = ShaguTweaks:register({
  title = "Open Loot Window at Mouse",
  description = "Automatically positions the most relevant part of the loot window under your cursor.",
  expansions = { ["vanilla"] = true, ["tbc"] = nil },
  category = nil,
  enabled = nil,
})

--modified code from _LazyPig https://github.com/CosminPOP/_LazyPig
local function QuickLoot_ItemUnderCursor()
	local index;
	local x, y = GetCursorPosition();
	local scale = LootFrame:GetEffectiveScale();
	x = x / scale;
	y = y / scale;
	LootFrame:ClearAllPoints();
	for index = 1, LOOTFRAME_NUMBUTTONS, 1 do
		local button = getglobal("LootButton"..index);
		if( button:IsVisible() ) then
			x = x - 42;
			y = y + 56 + (40 * index);
			LootFrame:SetPoint("TOPLEFT", "UIParent", "BOTTOMLEFT", x, y);
			return;
		end
	end
	if LootFrameDownButton:IsVisible() then
		x = x - 158;
		y = y + 223;
	else
		if GetNumLootItems() == 0  then
			HideUIPanel(LootFrame);
			return
		end
		x = x - 173;
		y = y + 25;
	end
	LootFrame:SetPoint("TOPLEFT", "UIParent", "BOTTOMLEFT", x, y);
end

local function QuickLoot_LootFrame_OnEvent(event)
	OriginalLootFrame_OnEvent(event);
	if(event == "LOOT_SLOT_CLEARED") then
		QuickLoot_ItemUnderCursor();
	end
end

local function QuickLoot_LootFrame_Update()
	OriginalLootFrame_Update();
	QuickLoot_ItemUnderCursor();
end

module.enable = function(self)
	OriginalLootFrame_OnEvent = LootFrame_OnEvent;
	LootFrame_OnEvent = QuickLoot_LootFrame_OnEvent;
	OriginalLootFrame_Update = LootFrame_Update;
	LootFrame_Update = QuickLoot_LootFrame_Update;
	UIPanelWindows["LootFrame"] = nil;
end
