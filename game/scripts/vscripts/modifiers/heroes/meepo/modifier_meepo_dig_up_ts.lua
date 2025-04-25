local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__ClassExtends = ____lualib.__TS__ClassExtends
local __TS__Decorate = ____lualib.__TS__Decorate
local __TS__SourceMapTraceBack = ____lualib.__TS__SourceMapTraceBack
__TS__SourceMapTraceBack(debug.getinfo(1).short_src, {["8"] = 1,["9"] = 1,["10"] = 1,["11"] = 3,["12"] = 4,["13"] = 3,["14"] = 4,["16"] = 4,["17"] = 5,["18"] = 6,["19"] = 7,["20"] = 8,["21"] = 3,["22"] = 15,["23"] = 16,["24"] = 15,["25"] = 18,["26"] = 19,["27"] = 18,["28"] = 21,["29"] = 22,["30"] = 21,["31"] = 25,["32"] = 26,["33"] = 28,["34"] = 25,["35"] = 31,["36"] = 32,["37"] = 31,["38"] = 34,["39"] = 35,["40"] = 34,["41"] = 37,["42"] = 37,["43"] = 40,["44"] = 40,["45"] = 4,["46"] = 4,["47"] = 4,["48"] = 3,["51"] = 4});
local ____exports = {}
local ____dota_ts_adapter = require("lib.dota_ts_adapter")
local BaseModifier = ____dota_ts_adapter.BaseModifier
local registerModifier = ____dota_ts_adapter.registerModifier
____exports.modifier_meepo_dig_up_ts = __TS__Class()
local modifier_meepo_dig_up_ts = ____exports.modifier_meepo_dig_up_ts
modifier_meepo_dig_up_ts.name = "modifier_meepo_dig_up_ts"
__TS__ClassExtends(modifier_meepo_dig_up_ts, BaseModifier)
function modifier_meepo_dig_up_ts.prototype.____constructor(self, ...)
    BaseModifier.prototype.____constructor(self, ...)
    self.caster = self:GetCaster()
    self.ability = self:GetAbility()
    self.parent = self:GetParent()
    self.particle_buff = "particles/high_five_mug_travel.vpcf"
end
function modifier_meepo_dig_up_ts.prototype.IsHidden(self)
    return false
end
function modifier_meepo_dig_up_ts.prototype.IsDebuff(self)
    return false
end
function modifier_meepo_dig_up_ts.prototype.IsPurgable(self)
    return true
end
function modifier_meepo_dig_up_ts.prototype.OnCreated(self)
    self.interval = self.ability:GetSpecialValueFor("bonus_incoming_damage_percent")
    self:StartIntervalThink(self.interval)
end
function modifier_meepo_dig_up_ts.prototype.GetEffectName(self)
    return self.particle_buff
end
function modifier_meepo_dig_up_ts.prototype.GetEffectAttachType(self)
    return PATTACH_ABSORIGIN_FOLLOW
end
function modifier_meepo_dig_up_ts.prototype.StartIntervalThink(self, interval)
end
function modifier_meepo_dig_up_ts.prototype.OnIntervalThink(self)
end
modifier_meepo_dig_up_ts = __TS__Decorate(
    modifier_meepo_dig_up_ts,
    modifier_meepo_dig_up_ts,
    {registerModifier(nil)},
    {kind = "class", name = "modifier_meepo_dig_up_ts"}
)
____exports.modifier_meepo_dig_up_ts = modifier_meepo_dig_up_ts
return ____exports
