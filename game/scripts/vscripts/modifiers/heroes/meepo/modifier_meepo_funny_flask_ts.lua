local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__ClassExtends = ____lualib.__TS__ClassExtends
local __TS__Decorate = ____lualib.__TS__Decorate
local __TS__SourceMapTraceBack = ____lualib.__TS__SourceMapTraceBack
__TS__SourceMapTraceBack(debug.getinfo(1).short_src, {["8"] = 1,["9"] = 1,["10"] = 1,["11"] = 3,["12"] = 4,["13"] = 3,["14"] = 4,["16"] = 4,["17"] = 5,["18"] = 6,["19"] = 7,["20"] = 8,["21"] = 9,["22"] = 3,["23"] = 13,["24"] = 14,["25"] = 13,["26"] = 16,["27"] = 17,["28"] = 16,["29"] = 19,["30"] = 20,["31"] = 19,["32"] = 23,["33"] = 24,["34"] = 26,["35"] = 27,["36"] = 29,["37"] = 34,["38"] = 34,["39"] = 34,["40"] = 34,["41"] = 34,["42"] = 23,["43"] = 43,["44"] = 44,["45"] = 43,["46"] = 46,["47"] = 47,["48"] = 46,["49"] = 50,["50"] = 51,["51"] = 50,["52"] = 56,["53"] = 57,["54"] = 56,["55"] = 60,["56"] = 61,["57"] = 60,["58"] = 4,["59"] = 4,["60"] = 4,["61"] = 3,["64"] = 4});
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
    self.particle_buff = "particles/units/heroes/hero_ringmaster/funnel_cake_ground_anchors.vpcf"
    self.sound = "Hero_Alchemist.ChemicalRage.Cast"
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
    self.caster:EmitSound("Hero_Brewmaster.Brawler.Crit")
    self.bonus_atack_speed = self.ability:GetSpecialValueFor("bonus_attack_speed")
    self.bonus_incoming_damage = self.ability:GetSpecialValueFor("bonus_incoming_damage_percent")
    local effect = ParticleManager:CreateParticle(self.particle_buff, PATTACH_ABSORIGIN_FOLLOW, nil)
    ParticleManager:SetParticleControl(
        effect,
        0,
        self.caster:GetAbsOrigin()
    )
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
