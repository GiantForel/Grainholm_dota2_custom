local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__New = ____lualib.__TS__New
local __TS__Decorate = ____lualib.__TS__Decorate
local __TS__SourceMapTraceBack = ____lualib.__TS__SourceMapTraceBack
__TS__SourceMapTraceBack(debug.getinfo(1).short_src, {["8"] = 1,["9"] = 1,["10"] = 4,["11"] = 5,["12"] = 13,["13"] = 14,["14"] = 13,["16"] = 26,["17"] = 29,["18"] = 29,["19"] = 29,["20"] = 29,["21"] = 29,["22"] = 30,["23"] = 30,["24"] = 30,["25"] = 30,["26"] = 30,["27"] = 31,["28"] = 31,["29"] = 31,["30"] = 31,["31"] = 31,["32"] = 34,["33"] = 34,["34"] = 34,["35"] = 35,["36"] = 38,["37"] = 34,["38"] = 34,["39"] = 25,["40"] = 15,["41"] = 16,["42"] = 17,["43"] = 15,["44"] = 20,["45"] = 22,["46"] = 20,["47"] = 55,["48"] = 56,["49"] = 57,["50"] = 62,["51"] = 55,["52"] = 65,["53"] = 66,["54"] = 67,["55"] = 68,["56"] = 69,["57"] = 70,["58"] = 71,["59"] = 72,["60"] = 76,["61"] = 77,["62"] = 78,["63"] = 79,["64"] = 80,["65"] = 81,["66"] = 82,["67"] = 86,["68"] = 87,["69"] = 88,["70"] = 94,["71"] = 96,["73"] = 65,["74"] = 100,["75"] = 101,["76"] = 110,["77"] = 112,["78"] = 113,["79"] = 113,["80"] = 113,["81"] = 114,["82"] = 113,["83"] = 113,["86"] = 120,["87"] = 121,["88"] = 121,["89"] = 121,["90"] = 121,["92"] = 100,["93"] = 125,["94"] = 126,["95"] = 125,["96"] = 132,["97"] = 133,["98"] = 132,["99"] = 137,["100"] = 139,["101"] = 142,["102"] = 143,["104"] = 145,["106"] = 137,["107"] = 148,["108"] = 155,["109"] = 167,["110"] = 168,["111"] = 169,["112"] = 170,["113"] = 170,["114"] = 170,["115"] = 170,["116"] = 170,["117"] = 170,["118"] = 170,["119"] = 170,["120"] = 170,["121"] = 170,["122"] = 170,["123"] = 174,["124"] = 175,["126"] = 169,["128"] = 148,["129"] = 13,["130"] = 14});
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
