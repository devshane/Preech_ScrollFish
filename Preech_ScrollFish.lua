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
      mh = GetInventoryItemID('player', INV_SLOT_MAIN_HAND);
      for p in pairs(POLES) do
        if mh == POLES[p] then
          unit = 'player';
          typ = 'macro';

          head = GetInventoryItemID('player', INV_SLOT_HEAD);
          enchant_this_badboy = false;
          for h in pairs(HEADS) do
            if head == HEADS[h] then
              mh_ench, mh_expires, mh_charges, mh_ench_id, _, _, _, _ = GetWeaponEnchantInfo();
              if mh_ench then
                -- good for you
              else
                head_name, head_link = GetItemInfo(head);
                pole_name, pole_link = GetItemInfo(mh);
                WriteChatMessage('buffing ' .. pole_link .. ' with ' .. head_link);
                -- TODO only enchant if the buff is ready -- "Item is not ready yet."
                enchant_this_badboy = true;
                break;
              end
            end
          end

          if not enchant_this_badboy then
            for i = 1, 40 do
              local raft = 'Anglers Fishing Raft';
              local n, _, _, _, _, dur, x, _, _ = UnitBuff("player", i);

              if n == raft then
                secs_left = -1 * (GetTime() - x);
                if secs_left < 30 then
                  _, link = GetItemInfo(raft);
                  if link then
                    WriteChatMessage('casting ' .. link);
                  end
                  macro = '/cast ' .. raft;
                end
              end
            end
          end

          if enchant_this_badboy then
            macro = '/use ' .. INV_SLOT_HEAD;
          else
            if macro == nil then
              macro = '/cast fishing';
            end
          end
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
