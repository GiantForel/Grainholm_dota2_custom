local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__ClassExtends = ____lualib.__TS__ClassExtends
local __TS__Decorate = ____lualib.__TS__Decorate
local __TS__SourceMapTraceBack = ____lualib.__TS__SourceMapTraceBack
__TS__SourceMapTraceBack(debug.getinfo(1).short_src, {["8"] = 1,["9"] = 1,["10"] = 1,["11"] = 2,["12"] = 5,["13"] = 6,["14"] = 5,["15"] = 6,["17"] = 6,["18"] = 8,["19"] = 9,["20"] = 10,["21"] = 5,["22"] = 11,["23"] = 12,["24"] = 11,["25"] = 18,["26"] = 19,["27"] = 18,["28"] = 22,["29"] = 23,["30"] = 26,["31"] = 22,["32"] = 6,["33"] = 6,["34"] = 6,["35"] = 5,["38"] = 6});
local ____exports = {}
local ____dota_ts_adapter = require("lib.dota_ts_adapter")
local BaseAbility = ____dota_ts_adapter.BaseAbility
local registerAbility = ____dota_ts_adapter.registerAbility
require("modifiers.heroes.meepo.modifier_meepo_funny_flask_ts")
____exports.meepo_funny_flask_ts = __TS__Class()
local meepo_funny_flask_ts = ____exports.meepo_funny_flask_ts
meepo_funny_flask_ts.name = "meepo_funny_flask_ts"
__TS__ClassExtends(meepo_funny_flask_ts, BaseAbility)
function meepo_funny_flask_ts.prototype.____constructor(self, ...)
    BaseAbility.prototype.____constructor(self, ...)
    self.caster = self:GetCaster()
    self.funny_duration = self:GetSpecialValueFor("bonus_flask_duration")
    self.modifier_funny = "modifier_meepo_funny_flask_ts"
end
function meepo_funny_flask_ts.Precache(self, context)
    PrecacheResource("particle", "particles/units/heroes/hero_ringmaster/funnel_cake_ground_anchors.vpcf", context)
end
function meepo_funny_flask_ts.prototype.OnUpgrade(self)
    self.funny_duration = self:GetSpecialValueFor("bonus_flask_duration")
end
function meepo_funny_flask_ts.prototype.OnSpellStart(self)
    self.caster:EmitSound("Hero_Brewmaster.CinderBrew.Target")
    self.caster:AddNewModifier(self.caster, self, self.modifier_funny, {duration = self.funny_duration})
end
meepo_funny_flask_ts = __TS__Decorate(
    meepo_funny_flask_ts,
    meepo_funny_flask_ts,
    {registerAbility(nil)},
    {kind = "class", name = "meepo_funny_flask_ts"}
)
____exports.meepo_funny_flask_ts = meepo_funny_flask_ts
return ____exports
