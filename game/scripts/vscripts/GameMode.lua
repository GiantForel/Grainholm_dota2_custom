local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__New = ____lualib.__TS__New
local __TS__Decorate = ____lualib.__TS__Decorate
local __TS__SourceMapTraceBack = ____lualib.__TS__SourceMapTraceBack
__TS__SourceMapTraceBack(debug.getinfo(1).short_src, {["8"] = 1,["9"] = 1,["10"] = 4,["11"] = 5,["12"] = 13,["13"] = 14,["14"] = 13,["16"] = 35,["17"] = 38,["18"] = 38,["19"] = 38,["20"] = 38,["21"] = 38,["22"] = 39,["23"] = 39,["24"] = 39,["25"] = 39,["26"] = 39,["27"] = 40,["28"] = 40,["29"] = 40,["30"] = 40,["31"] = 40,["32"] = 43,["33"] = 43,["34"] = 43,["35"] = 44,["36"] = 47,["37"] = 43,["38"] = 43,["39"] = 34,["40"] = 15,["41"] = 17,["42"] = 18,["43"] = 21,["44"] = 23,["45"] = 24,["46"] = 15,["47"] = 29,["48"] = 31,["49"] = 29,["50"] = 64,["51"] = 65,["52"] = 66,["53"] = 71,["54"] = 64,["55"] = 74,["56"] = 75,["57"] = 76,["58"] = 77,["59"] = 78,["60"] = 79,["61"] = 80,["62"] = 81,["63"] = 85,["64"] = 86,["65"] = 87,["66"] = 88,["67"] = 89,["68"] = 90,["69"] = 91,["70"] = 95,["71"] = 96,["72"] = 97,["73"] = 103,["74"] = 105,["76"] = 74,["77"] = 109,["78"] = 110,["79"] = 119,["80"] = 121,["81"] = 122,["82"] = 122,["83"] = 122,["84"] = 123,["85"] = 122,["86"] = 122,["89"] = 129,["90"] = 130,["91"] = 130,["92"] = 130,["93"] = 130,["95"] = 109,["96"] = 134,["97"] = 135,["98"] = 134,["99"] = 141,["100"] = 142,["101"] = 141,["102"] = 146,["103"] = 148,["104"] = 151,["105"] = 152,["107"] = 154,["109"] = 146,["110"] = 157,["111"] = 164,["112"] = 176,["113"] = 177,["114"] = 178,["115"] = 179,["116"] = 179,["117"] = 179,["118"] = 179,["119"] = 179,["120"] = 179,["121"] = 179,["122"] = 179,["123"] = 179,["124"] = 179,["125"] = 179,["126"] = 183,["127"] = 184,["129"] = 178,["131"] = 157,["132"] = 13,["133"] = 14});
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
    PrecacheResource("soundfile", "sounds/searing_signet.vsnd", context)
    PrecacheResource("particle", "particles/units/heroes/hero_spectre/spectre_ambient_blade_fallback_low.vpcf", context)
    PrecacheResource("particle", "particles/high_five_mug_travel.vpcf", context)
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
