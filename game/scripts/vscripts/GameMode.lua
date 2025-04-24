local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__New = ____lualib.__TS__New
local __TS__Decorate = ____lualib.__TS__Decorate
local __TS__SourceMapTraceBack = ____lualib.__TS__SourceMapTraceBack
__TS__SourceMapTraceBack(debug.getinfo(1).short_src, {["8"] = 1,["9"] = 1,["10"] = 4,["11"] = 5,["12"] = 13,["13"] = 14,["14"] = 13,["16"] = 30,["17"] = 33,["18"] = 33,["19"] = 33,["20"] = 33,["21"] = 33,["22"] = 34,["23"] = 34,["24"] = 34,["25"] = 34,["26"] = 34,["27"] = 35,["28"] = 35,["29"] = 35,["30"] = 35,["31"] = 35,["32"] = 38,["33"] = 38,["34"] = 38,["35"] = 39,["36"] = 42,["37"] = 38,["38"] = 38,["39"] = 29,["40"] = 15,["41"] = 16,["42"] = 17,["43"] = 18,["44"] = 19,["45"] = 20,["46"] = 15,["47"] = 24,["48"] = 26,["49"] = 24,["50"] = 59,["51"] = 60,["52"] = 61,["53"] = 66,["54"] = 59,["55"] = 69,["56"] = 70,["57"] = 71,["58"] = 72,["59"] = 73,["60"] = 74,["61"] = 75,["62"] = 76,["63"] = 80,["64"] = 81,["65"] = 82,["66"] = 83,["67"] = 84,["68"] = 85,["69"] = 86,["70"] = 90,["71"] = 91,["72"] = 92,["73"] = 98,["74"] = 100,["76"] = 69,["77"] = 104,["78"] = 105,["79"] = 114,["80"] = 116,["81"] = 117,["82"] = 117,["83"] = 117,["84"] = 118,["85"] = 117,["86"] = 117,["89"] = 124,["90"] = 125,["91"] = 125,["92"] = 125,["93"] = 125,["95"] = 104,["96"] = 129,["97"] = 130,["98"] = 129,["99"] = 136,["100"] = 137,["101"] = 136,["102"] = 141,["103"] = 143,["104"] = 146,["105"] = 147,["107"] = 149,["109"] = 141,["110"] = 152,["111"] = 159,["112"] = 171,["113"] = 172,["114"] = 173,["115"] = 174,["116"] = 174,["117"] = 174,["118"] = 174,["119"] = 174,["120"] = 174,["121"] = 174,["122"] = 174,["123"] = 174,["124"] = 174,["125"] = 174,["126"] = 178,["127"] = 179,["129"] = 173,["131"] = 152,["132"] = 13,["133"] = 14});
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
    PrecacheResource("soundfile", "sounds/items/searing_signet.vsnd", context)
    PrecacheResource("particle", "particles/units/heroes/hero_morphling/morphling_waveform_splash_a_endcap.vpcf", context)
    PrecacheResource("particle", "particles/meepo_kobold/test_part.vpcf", context)
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
