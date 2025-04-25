local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__ClassExtends = ____lualib.__TS__ClassExtends
local __TS__Decorate = ____lualib.__TS__Decorate
local __TS__SourceMapTraceBack = ____lualib.__TS__SourceMapTraceBack
__TS__SourceMapTraceBack(debug.getinfo(1).short_src, {["8"] = 1,["9"] = 1,["10"] = 1,["11"] = 3,["12"] = 4,["13"] = 3,["14"] = 4,["16"] = 4,["17"] = 5,["18"] = 6,["19"] = 7,["20"] = 8,["21"] = 3,["22"] = 13,["23"] = 14,["24"] = 13,["25"] = 16,["26"] = 17,["27"] = 16,["28"] = 19,["29"] = 20,["30"] = 19,["31"] = 23,["32"] = 25,["33"] = 26,["34"] = 23,["35"] = 28,["36"] = 29,["37"] = 28,["38"] = 31,["39"] = 32,["40"] = 31,["41"] = 35,["42"] = 36,["43"] = 35,["44"] = 41,["45"] = 42,["46"] = 41,["47"] = 45,["48"] = 46,["49"] = 45,["50"] = 4,["51"] = 4,["52"] = 4,["53"] = 3,["56"] = 4});
local ____exports = {}
local ____dota_ts_adapter = require("lib.dota_ts_adapter")
local BaseModifier = ____dota_ts_adapter.BaseModifier
local registerModifier = ____dota_ts_adapter.registerModifier
____exports.modifier_meepo_funny_flask_ts = __TS__Class()
local modifier_meepo_funny_flask_ts = ____exports.modifier_meepo_funny_flask_ts
modifier_meepo_funny_flask_ts.name = "modifier_meepo_funny_flask_ts"
__TS__ClassExtends(modifier_meepo_funny_flask_ts, BaseModifier)
function modifier_meepo_funny_flask_ts.prototype.____constructor(self, ...)
    BaseModifier.prototype.____constructor(self, ...)
    self.caster = self:GetCaster()
    self.ability = self:GetAbility()
    self.parent = self:GetParent()
    self.particle_buff = "particles/high_five_mug_travel.vpcf"
end
function modifier_meepo_funny_flask_ts.prototype.IsHidden(self)
    return false
end
function modifier_meepo_funny_flask_ts.prototype.IsDebuff(self)
    return false
end
function modifier_meepo_funny_flask_ts.prototype.IsPurgable(self)
    return true
end
function modifier_meepo_funny_flask_ts.prototype.OnCreated(self)
    self.bonus_atack_speed = self.ability:GetSpecialValueFor("bonus_attack_speed")
    self.bonus_incoming_damage = self.ability:GetSpecialValueFor("bonus_incoming_damage_percent")
end
function modifier_meepo_funny_flask_ts.prototype.GetEffectName(self)
    return self.particle_buff
end
function modifier_meepo_funny_flask_ts.prototype.GetEffectAttachType(self)
    return PATTACH_ABSORIGIN_FOLLOW
end
function modifier_meepo_funny_flask_ts.prototype.DeclareFunctions(self)
    return {MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT, MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
end
function modifier_meepo_funny_flask_ts.prototype.GetModifierAttackSpeedBonus_Constant(self)
    return self.bonus_atack_speed or 0
end
function modifier_meepo_funny_flask_ts.prototype.GetModifierIncomingDamage_Percentage(self, event)
    return self.bonus_incoming_damage or 0
end
modifier_meepo_funny_flask_ts = __TS__Decorate(
    modifier_meepo_funny_flask_ts,
    modifier_meepo_funny_flask_ts,
    {registerModifier(nil)},
    {kind = "class", name = "modifier_meepo_funny_flask_ts"}
)
____exports.modifier_meepo_funny_flask_ts = modifier_meepo_funny_flask_ts
return ____exports
