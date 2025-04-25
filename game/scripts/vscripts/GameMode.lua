local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__New = ____lualib.__TS__New
local __TS__Decorate = ____lualib.__TS__Decorate
local __TS__SourceMapTraceBack = ____lualib.__TS__SourceMapTraceBack
__TS__SourceMapTraceBack(debug.getinfo(1).short_src, {["8"] = 1,["9"] = 1,["10"] = 4,["11"] = 5,["12"] = 13,["13"] = 14,["14"] = 13,["16"] = 31,["17"] = 34,["18"] = 34,["19"] = 34,["20"] = 34,["21"] = 34,["22"] = 35,["23"] = 35,["24"] = 35,["25"] = 35,["26"] = 35,["27"] = 36,["28"] = 36,["29"] = 36,["30"] = 36,["31"] = 36,["32"] = 39,["33"] = 39,["34"] = 39,["35"] = 40,["36"] = 43,["37"] = 39,["38"] = 39,["39"] = 30,["40"] = 15,["41"] = 17,["42"] = 18,["43"] = 19,["44"] = 20,["45"] = 21,["46"] = 15,["47"] = 25,["48"] = 27,["49"] = 25,["50"] = 60,["51"] = 61,["52"] = 62,["53"] = 67,["54"] = 60,["55"] = 70,["56"] = 71,["57"] = 72,["58"] = 73,["59"] = 74,["60"] = 75,["61"] = 76,["62"] = 77,["63"] = 78,["64"] = 82,["65"] = 83,["66"] = 84,["67"] = 85,["68"] = 86,["69"] = 87,["70"] = 88,["71"] = 92,["72"] = 93,["73"] = 94,["74"] = 99,["75"] = 101,["77"] = 70,["78"] = 108,["79"] = 109,["80"] = 118,["81"] = 120,["82"] = 121,["83"] = 121,["84"] = 121,["85"] = 122,["86"] = 121,["87"] = 121,["90"] = 128,["91"] = 129,["92"] = 129,["93"] = 129,["94"] = 129,["96"] = 108,["97"] = 133,["98"] = 134,["99"] = 133,["100"] = 140,["101"] = 141,["102"] = 140,["103"] = 145,["104"] = 147,["105"] = 150,["106"] = 151,["108"] = 153,["110"] = 145,["111"] = 156,["112"] = 163,["113"] = 175,["114"] = 176,["115"] = 177,["116"] = 178,["117"] = 178,["118"] = 178,["119"] = 178,["120"] = 178,["121"] = 178,["122"] = 178,["123"] = 178,["124"] = 178,["125"] = 178,["126"] = 178,["127"] = 182,["128"] = 183,["130"] = 177,["132"] = 156,["133"] = 13,["134"] = 14});
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
