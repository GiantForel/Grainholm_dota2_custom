local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__ClassExtends = ____lualib.__TS__ClassExtends
local __TS__Decorate = ____lualib.__TS__Decorate
local __TS__SourceMapTraceBack = ____lualib.__TS__SourceMapTraceBack
__TS__SourceMapTraceBack(debug.getinfo(1).short_src, {["8"] = 1,["9"] = 1,["10"] = 1,["11"] = 4,["12"] = 5,["13"] = 4,["14"] = 5,["16"] = 5,["17"] = 7,["18"] = 8,["19"] = 9,["20"] = 4,["21"] = 12,["22"] = 14,["23"] = 16,["24"] = 17,["25"] = 19,["26"] = 19,["27"] = 19,["28"] = 19,["29"] = 21,["30"] = 22,["31"] = 22,["32"] = 22,["33"] = 22,["34"] = 22,["35"] = 22,["36"] = 22,["37"] = 22,["38"] = 22,["39"] = 21,["40"] = 12,["41"] = 36,["42"] = 38,["45"] = 40,["46"] = 42,["47"] = 43,["48"] = 44,["49"] = 45,["50"] = 47,["51"] = 47,["52"] = 47,["53"] = 47,["54"] = 47,["55"] = 47,["56"] = 47,["57"] = 49,["58"] = 50,["59"] = 52,["61"] = 55,["62"] = 56,["63"] = 56,["64"] = 56,["65"] = 56,["66"] = 56,["67"] = 56,["68"] = 55,["69"] = 36,["70"] = 5,["71"] = 5,["72"] = 5,["73"] = 4,["76"] = 5});
local ____exports = {}
local ____dota_ts_adapter = require("lib.dota_ts_adapter")
local BaseAbility = ____dota_ts_adapter.BaseAbility
local registerAbility = ____dota_ts_adapter.registerAbility
____exports.skywrath_mage_arcane_bolt_ts = __TS__Class()
local skywrath_mage_arcane_bolt_ts = ____exports.skywrath_mage_arcane_bolt_ts
skywrath_mage_arcane_bolt_ts.name = "skywrath_mage_arcane_bolt_ts"
__TS__ClassExtends(skywrath_mage_arcane_bolt_ts, BaseAbility)
function skywrath_mage_arcane_bolt_ts.prototype.____constructor(self, ...)
    BaseAbility.prototype.____constructor(self, ...)
    self.sound_cast = "Hero_SkywrathMage.ArcaneBolt.Cast"
    self.sound_impact = "Hero_SkywrathMage.ArcaneBolt.Impact"
    self.projectile_arcane_bolt = "particles/units/heroes/hero_skywrath_mage/skywrath_mage_arcane_bolt.vpcf"
end
function skywrath_mage_arcane_bolt_ts.prototype.OnSpellStart(self)
    local target = self:GetCursorTarget()
    local bolt_speed = self:GetSpecialValueFor("bolt_speed")
    local bolt_vision = self:GetSpecialValueFor("bolt_vision")
    EmitSoundOn(
        self.sound_cast,
        self:GetCaster()
    )
    ProjectileManager:CreateTrackingProjectile({
        Ability = self,
        EffectName = self.projectile_arcane_bolt,
        Source = self:GetCaster(),
        Target = target,
        bDodgeable = false,
        bProvidesVision = true,
        iMoveSpeed = bolt_speed,
        iVisionRadius = bolt_vision,
        iVisionTeamNumber = self:GetCaster():GetTeamNumber()
    })
end
function skywrath_mage_arcane_bolt_ts.prototype.OnProjectileHit(self, target, location)
    if not target then
        return
    end
    EmitSoundOn(self.sound_impact, target)
    local bolt_vision = self:GetSpecialValueFor("bolt_vision")
    local bolt_damage = self:GetSpecialValueFor("bolt_damage")
    local int_multiplier = self:GetSpecialValueFor("int_multiplier")
    local vision_duration = self:GetSpecialValueFor("vision_duration")
    AddFOWViewer(
        self:GetCaster():GetTeamNumber(),
        location,
        bolt_vision,
        vision_duration,
        false
    )
    local damage = bolt_damage
    if self:GetCaster():IsHero() then
        damage = damage + self:GetCaster():GetIntellect(true) * int_multiplier
    end
    ApplyDamage({
        attacker = self:GetCaster(),
        damage = damage,
        damage_type = DAMAGE_TYPE_MAGICAL,
        victim = target,
        ability = self,
        damage_flags = DOTA_DAMAGE_FLAG_NONE
    })
end
skywrath_mage_arcane_bolt_ts = __TS__Decorate(
    skywrath_mage_arcane_bolt_ts,
    skywrath_mage_arcane_bolt_ts,
    {registerAbility(nil)},
    {kind = "class", name = "skywrath_mage_arcane_bolt_ts"}
)
____exports.skywrath_mage_arcane_bolt_ts = skywrath_mage_arcane_bolt_ts
return ____exports
