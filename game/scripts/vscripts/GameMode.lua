local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__New = ____lualib.__TS__New
local __TS__Decorate = ____lualib.__TS__Decorate
local __TS__SourceMapTraceBack = ____lualib.__TS__SourceMapTraceBack
__TS__SourceMapTraceBack(debug.getinfo(1).short_src, {["8"] = 1,["9"] = 1,["10"] = 2,["11"] = 2,["12"] = 4,["13"] = 12,["14"] = 13,["15"] = 12,["17"] = 25,["18"] = 28,["19"] = 28,["20"] = 28,["21"] = 28,["22"] = 28,["23"] = 29,["24"] = 29,["25"] = 29,["26"] = 29,["27"] = 29,["28"] = 32,["29"] = 32,["30"] = 32,["31"] = 33,["32"] = 36,["33"] = 37,["34"] = 45,["35"] = 46,["36"] = 47,["38"] = 32,["39"] = 32,["40"] = 24,["41"] = 14,["42"] = 15,["43"] = 16,["44"] = 14,["45"] = 19,["46"] = 21,["47"] = 19,["48"] = 52,["49"] = 53,["50"] = 54,["51"] = 56,["52"] = 57,["53"] = 52,["54"] = 60,["55"] = 61,["56"] = 70,["57"] = 72,["58"] = 73,["59"] = 73,["60"] = 73,["61"] = 74,["62"] = 73,["63"] = 73,["66"] = 80,["67"] = 81,["68"] = 81,["69"] = 81,["70"] = 81,["72"] = 60,["73"] = 85,["74"] = 86,["75"] = 85,["76"] = 92,["77"] = 93,["78"] = 92,["79"] = 98,["80"] = 101,["81"] = 113,["82"] = 114,["83"] = 115,["84"] = 116,["85"] = 116,["86"] = 116,["87"] = 116,["88"] = 116,["89"] = 116,["90"] = 116,["91"] = 116,["92"] = 116,["93"] = 116,["94"] = 116,["95"] = 120,["96"] = 121,["98"] = 115,["100"] = 98,["101"] = 12,["102"] = 13});
local ____exports = {}
local ____tstl_2Dutils = require("lib.tstl-utils")
local reloadable = ____tstl_2Dutils.reloadable
local ____modifier_panic = require("modifiers.modifier_panic")
local modifier_panic = ____modifier_panic.modifier_panic
local heroSelectionTime = 20
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
    CustomGameEventManager:RegisterListener(
        "ui_panel_closed",
        function(_, data)
            print(("Player " .. tostring(data.PlayerID)) .. " has closed their UI panel.")
            local player = PlayerResource:GetPlayer(data.PlayerID)
            CustomGameEventManager:Send_ServerToPlayer(player, "example_event", {myNumber = 42, myBoolean = true, myString = "Hello!", myArrayOfNumbers = {1.414, 2.718, 3.142}})
            local hero = player:GetAssignedHero()
            if hero ~= nil then
                hero:AddNewModifier(hero, nil, modifier_panic.name, {duration = 5})
            end
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
    GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_BADGUYS, 0)
    GameRules:SetShowcaseTime(0)
    GameRules:SetHeroSelectionTime(heroSelectionTime)
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
