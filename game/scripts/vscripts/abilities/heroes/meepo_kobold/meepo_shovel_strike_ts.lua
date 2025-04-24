local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__ClassExtends = ____lualib.__TS__ClassExtends
local __TS__Decorate = ____lualib.__TS__Decorate
local __TS__SourceMapTraceBack = ____lualib.__TS__SourceMapTraceBack
__TS__SourceMapTraceBack(debug.getinfo(1).short_src, {["8"] = 1,["9"] = 1,["10"] = 1,["11"] = 3,["12"] = 4,["13"] = 3,["14"] = 4,["16"] = 4,["17"] = 6,["18"] = 7,["19"] = 3,["20"] = 10,["21"] = 12,["22"] = 13,["23"] = 15,["24"] = 15,["25"] = 15,["26"] = 15,["27"] = 10,["28"] = 4,["29"] = 4,["30"] = 4,["31"] = 3,["34"] = 4});
local ____exports = {}
local ____dota_ts_adapter = require("lib.dota_ts_adapter")
local BaseAbility = ____dota_ts_adapter.BaseAbility
local registerAbility = ____dota_ts_adapter.registerAbility
____exports.meepo_shovel_strike_ts = __TS__Class()
local meepo_shovel_strike_ts = ____exports.meepo_shovel_strike_ts
meepo_shovel_strike_ts.name = "meepo_shovel_strike_ts"
__TS__ClassExtends(meepo_shovel_strike_ts, BaseAbility)
function meepo_shovel_strike_ts.prototype.____constructor(self, ...)
    BaseAbility.prototype.____constructor(self, ...)
    self.sound_cast = "soundevents/game_sounds_heroes/game_sounds_centaur.vsndevts"
    self.particle = "particles/units/heroes/hero_centaur/centaur_double_edge.vpcf"
end
function meepo_shovel_strike_ts.prototype.OnSpellStart(self)
    local target = self:GetCursorTarget()
    local shovel_vision = self:GetSpecialValueFor("shovel_vision")
    EmitSoundOn(
        self.sound_cast,
        self:GetCaster()
    )
end
meepo_shovel_strike_ts = __TS__Decorate(
    meepo_shovel_strike_ts,
    meepo_shovel_strike_ts,
    {registerAbility(nil)},
    {kind = "class", name = "meepo_shovel_strike_ts"}
)
____exports.meepo_shovel_strike_ts = meepo_shovel_strike_ts
return ____exports
