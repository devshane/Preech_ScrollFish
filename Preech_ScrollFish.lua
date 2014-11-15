INV_SLOT_MAIN_HAND = 16;

POLES = { 45858 }; -- Nat's Lucky Fishing Pole

local working = false;

local function HexToRGBPerc(hex)
	local rhex, ghex, bhex = string.sub(hex, 1, 2), string.sub(hex, 3, 4), string.sub(hex, 5, 6)
	return tonumber(rhex, 16)/255, tonumber(ghex, 16)/255, tonumber(bhex, 16)/255
end

local RED_VALUE, GREEN_VALUE, BLUE_VALUE = HexToRGBPerc('aaaaaa');

function WriteChatMessage(what)
    DEFAULT_CHAT_FRAME:AddMessage('|cffff9900<|cffff6600ScrollFish|cffff9900>|r ' .. what, RED_VALUE, GREEN_VALUE, BLUE_VALUE);
end

function ScrollFish_OnLoad(self)
    WriteChatMessage('loaded');
    self:RegisterEvent('ADDON_LOADED');
end

function ScrollFish_OnEvent(self, event, arg1, arg2, arg3, arg4)
    if (event == 'ADDON_LOADED' and arg1 == 'Preech_ScrollFish') then
        SetOverrideBindingClick(PreechFishFrame, false, 'MOUSEWHEELUP', 'Preech_Fish_KeyButton', 'MOUSEWHEELUP');
        SetOverrideBindingClick(PreechFishFrame, false, 'MOUSEWHEELDOWN', 'Preech_Fish_KeyButton', 'MOUSEWHEELDOWN');
    end
end

function ScrollFish_OnUpdate(self, elapsed)
end

function ScrollFish_OnPreClick(self, button, down)
    local unit = nil;
    local typ = nil;
    local macro = nil;

    if not working then
        working = true;

        if CanBeBuffed() then
            mh = GetInventoryItemID('player', INV_SLOT_MAIN_HAND)
            for p in pairs(POLES) do
                if mh == POLES[p] then
                    unit = 'player';
                    typ = 'macro';
                    macro = '/cast fishing';
                    break;
                end
            end
        end
    end

    Preech_Fish_KeyButton:SetAttribute('unit', unit);
    Preech_Fish_KeyButton:SetAttribute('type', typ);
    Preech_Fish_KeyButton:SetAttribute('macrotext', macro);
end

function ScrollFish_OnPostClick(self, button, down)
    if (button) then
        if (button == 'MOUSEWHEELUP') then
            CameraZoomIn(1);
            working = false;
        elseif (button == 'MOUSEWHEELDOWN') then
            CameraZoomOut(1);
            working = false;
        end
    end
end

function CanBeBuffed()
    if IsFlying() or IsMounted() or UnitOnTaxi('player') then
        return false;
    end
    return true;
end
