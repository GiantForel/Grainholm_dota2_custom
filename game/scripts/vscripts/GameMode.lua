local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__New = ____lualib.__TS__New
local __TS__Decorate = ____lualib.__TS__Decorate
local __TS__SourceMapTraceBack = ____lualib.__TS__SourceMapTraceBack
__TS__SourceMapTraceBack(debug.getinfo(1).short_src, {["8"] = 1,["9"] = 1,["10"] = 4,["11"] = 5,["12"] = 13,["13"] = 14,["14"] = 13,["16"] = 33,["17"] = 36,["18"] = 36,["19"] = 36,["20"] = 36,["21"] = 36,["22"] = 37,["23"] = 37,["24"] = 37,["25"] = 37,["26"] = 37,["27"] = 38,["28"] = 38,["29"] = 38,["30"] = 38,["31"] = 38,["32"] = 41,["33"] = 41,["34"] = 41,["35"] = 42,["36"] = 45,["37"] = 41,["38"] = 41,["39"] = 32,["40"] = 15,["41"] = 17,["42"] = 18,["43"] = 19,["44"] = 20,["45"] = 21,["46"] = 22,["47"] = 23,["48"] = 15,["49"] = 27,["50"] = 29,["51"] = 27,["52"] = 62,["53"] = 63,["54"] = 64,["55"] = 69,["56"] = 62,["57"] = 72,["58"] = 73,["59"] = 74,["60"] = 75,["61"] = 76,["62"] = 77,["63"] = 78,["64"] = 79,["65"] = 80,["66"] = 84,["67"] = 85,["68"] = 86,["69"] = 87,["70"] = 88,["71"] = 89,["72"] = 90,["73"] = 94,["74"] = 95,["75"] = 96,["76"] = 101,["77"] = 103,["79"] = 72,["80"] = 110,["81"] = 111,["82"] = 120,["83"] = 122,["84"] = 123,["85"] = 123,["86"] = 123,["87"] = 124,["88"] = 123,["89"] = 123,["92"] = 130,["93"] = 131,["94"] = 131,["95"] = 131,["96"] = 131,["98"] = 110,["99"] = 135,["100"] = 136,["101"] = 135,["102"] = 142,["103"] = 143,["104"] = 142,["105"] = 147,["106"] = 149,["107"] = 152,["108"] = 153,["110"] = 155,["112"] = 147,["113"] = 158,["114"] = 165,["115"] = 177,["116"] = 178,["117"] = 179,["118"] = 180,["119"] = 180,["120"] = 180,["121"] = 180,["122"] = 180,["123"] = 180,["124"] = 180,["125"] = 180,["126"] = 180,["127"] = 180,["128"] = 180,["129"] = 184,["130"] = 185,["132"] = 179,["134"] = 158,["135"] = 13,["136"] = 14});
local ____exports = {}
local ____tstl_2Dutils = require("lib.tstl-utils")
local reloadable = ____tstl_2Dutils.reloadable
local heroSelectionTime = 10
local forceHero = "meepo"
____exports.GameMode = __TS__Class()
local GameMode = ____exports.GameMode
GameMode.name = "GameMode"
function GameMode.prototype.____constructor(self)
    self:configure()
    ListenToGameEvent(
        "game_rules_state_change",
        function() return self:OnStateChange() end,
        nil
    )
    ListenToGameEvent(
        "npc_spawned",
        function(event) return self:OnNpcSpawned(event) end,
        nil
    )
    ListenToGameEvent(
        "dota_inventory_item_added",
        function(event) return self:OnHeroScrollGain(event) end,
        nil
    )
    CustomGameEventManager:RegisterListener(
        "ui_panel_closed",
        function(_, data)
            print(("Player " .. tostring(data.PlayerID)) .. " has closed their UI panel.")
            local player = PlayerResource:GetPlayer(data.PlayerID)
        end
    )
end
function GameMode.Precache(context)
    PrecacheResource("particle", "particles/units/heroes/hero_meepo/meepo_earthbind_projectile_fx.vpcf", context)
    PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_meepo.vsndevts", context)
    PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_brewmaster.vsndevts", context)
    PrecacheResource("texture", "particles/units/heroes/hero_juggernaut/juggernaut_healing_ward_eruption_ripple.vpcf", context)
    PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_earhshaker.vsndevts", context)
    PrecacheResource("particle", "particles/units/heroes/hero_ringmaster/funnel_cake_ground_anchors.vpcf", context)
    PrecacheResource("particle", "particles/units/heroes/hero_juggernaut/juggernaut_healing_ward_eruption_ripple.vpcf", context)
end
function GameMode.Activate()
    GameRules.Addon = __TS__New(____exports.GameMode)
end
function GameMode.prototype.configure(self)
    GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_GOODGUYS, 4)
    GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_BADGUYS, 4)
    self:CustomGameSetup()
end
function GameMode.prototype.CustomGameSetup(self)
    GameRules:EnableCustomGameSetupAutoLaunch(true)
    GameRules:SetCustomGameSetupAutoLaunchDelay(0)
    GameRules:SetHeroSelectionTime(heroSelectionTime)
    GameRules:SetStrategyTime(0)
    GameRules:SetPreGameTime(0)
    GameRules:SetShowcaseTime(0)
    GameRules:SetPostGameTime(5)
    GameRules:SetTimeOfDay(14)
    local GameMode = GameRules:GetGameModeEntity()
    GameMode:SetAnnouncerDisabled(true)
    GameMode:SetKillingSpreeAnnouncerDisabled(true)
    GameMode:SetDaynightCycleDisabled(true)
    GameMode:DisableHudFlip(true)
    GameMode:SetDeathOverlayDisabled(true)
    GameMode:SetWeatherEffectsDisabled(true)
    GameRules:SetCustomGameAllowHeroPickMusic(false)
    GameRules:SetCustomGameAllowMusicAtGameStart(false)
    GameRules:SetCustomGameAllowBattleMusic(false)
    if forceHero ~= nil then
        GameMode:SetCustomGameForceHero(forceHero)
    end
end
function GameMode.prototype.OnStateChange(self)
    local state = GameRules:State_Get()
    if state == DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP then
        if IsInToolsMode() then
            Timers:CreateTimer(
                3,
                function()
                    GameRules:FinishCustomGameSetup()
                end
            )
        end
    end
    if state == DOTA_GAMERULES_STATE_PRE_GAME then
        Timers:CreateTimer(
            0.2,
            function() return self:StartGame() end
        )
    end
end
function GameMode.prototype.StartGame(self)
    print("Game starting!")
end
function GameMode.prototype.Reload(self)
    print("Script reloaded!")
end
function GameMode.prototype.OnHeroScrollGain(self, event)
    local item = EntIndexToHScript(event.item_entindex)
    if item:GetAbilityName() == "item_tpscroll" and item:GetPurchaser() == nil then
        return false
    else
        return true
    end
end
function GameMode.prototype.OnNpcSpawned(self, event)
    local npc = EntIndexToHScript(event.entindex)
    if npc:IsRealHero() then
    elseif npc:GetUnitName() == "npc_dota_neutral_kobold" then
        Timers:CreateTimer(function()
            local units = FindUnitsInRadius(
                npc:GetTeamNumber(),
                npc:GetAbsOrigin(),
                nil,
                500,
                DOTA_UNIT_TARGET_TEAM_ENEMY,
                bit.bor(DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_HERO),
                DOTA_UNIT_TARGET_FLAG_NONE,
                FIND_ANY_ORDER,
                false
            )
            for ____, unit in ipairs(units) do
                unit:ForceKill(true)
            end
        end)
    end
end
GameMode = __TS__Decorate(GameMode, GameMode, {reloadable}, {kind = "class", name = "GameMode"})
____exports.GameMode = GameMode
return ____exports
