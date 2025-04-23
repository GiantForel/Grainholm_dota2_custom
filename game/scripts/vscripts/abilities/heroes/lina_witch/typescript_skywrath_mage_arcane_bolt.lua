local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__ClassExtends = ____lualib.__TS__ClassExtends
local __TS__Decorate = ____lualib.__TS__Decorate
local __TS__SourceMapTraceBack = ____lualib.__TS__SourceMapTraceBack
__TS__SourceMapTraceBack(debug.getinfo(1).short_src, {["8"] = 1,["9"] = 1,["10"] = 1,["11"] = 4,["12"] = 5,["13"] = 4,["14"] = 5,["16"] = 5,["17"] = 7,["18"] = 8,["19"] = 9,["20"] = 4,["21"] = 11,["22"] = 13,["23"] = 15,["24"] = 16,["25"] = 18,["26"] = 18,["27"] = 18,["28"] = 18,["29"] = 20,["30"] = 21,["31"] = 21,["32"] = 21,["33"] = 21,["34"] = 21,["35"] = 21,["36"] = 21,["37"] = 21,["38"] = 21,["39"] = 20,["40"] = 11,["41"] = 35,["42"] = 37,["45"] = 39,["46"] = 41,["47"] = 42,["48"] = 43,["49"] = 44,["50"] = 46,["51"] = 46,["52"] = 46,["53"] = 46,["54"] = 46,["55"] = 46,["56"] = 46,["57"] = 48,["58"] = 49,["59"] = 51,["61"] = 54,["62"] = 55,["63"] = 55,["64"] = 55,["65"] = 55,["66"] = 55,["67"] = 55,["68"] = 54,["69"] = 35,["70"] = 5,["71"] = 5,["72"] = 5,["73"] = 4,["76"] = 5});
local ____exports = {}
local ____dota_ts_adapter = require("lib.dota_ts_adapter")
local BaseAbility = ____dota_ts_adapter.BaseAbility
local registerAbility = ____dota_ts_adapter.registerAbility
____exports.typescript_skywrath_mage_arcane_bolt = __TS__Class()
local typescript_skywrath_mage_arcane_bolt = ____exports.typescript_skywrath_mage_arcane_bolt
typescript_skywrath_mage_arcane_bolt.name = "typescript_skywrath_mage_arcane_bolt"
__TS__ClassExtends(typescript_skywrath_mage_arcane_bolt, BaseAbility)
function typescript_skywrath_mage_arcane_bolt.prototype.____constructor(self, ...)
    BaseAbility.prototype.____constructor(self, ...)
    self.sound_cast = "Hero_SkywrathMage.ArcaneBolt.Cast"
    self.sound_impact = "Hero_SkywrathMage.ArcaneBolt.Impact"
    self.projectile_arcane_bolt = "particles/units/heroes/hero_skywrath_mage/skywrath_mage_arcane_bolt.vpcf"
end
function typescript_skywrath_mage_arcane_bolt.prototype.OnSpellStart(self)
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
function typescript_skywrath_mage_arcane_bolt.prototype.OnProjectileHit(self, target, location)
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
typescript_skywrath_mage_arcane_bolt = __TS__Decorate(
    typescript_skywrath_mage_arcane_bolt,
    typescript_skywrath_mage_arcane_bolt,
    {registerAbility(nil)},
    {kind = "class", name = "typescript_skywrath_mage_arcane_bolt"}
)
____exports.typescript_skywrath_mage_arcane_bolt = typescript_skywrath_mage_arcane_bolt
return ____exports
