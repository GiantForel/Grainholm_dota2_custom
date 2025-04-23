local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__ClassExtends = ____lualib.__TS__ClassExtends
local __TS__Decorate = ____lualib.__TS__Decorate
local __TS__SourceMapTraceBack = ____lualib.__TS__SourceMapTraceBack
__TS__SourceMapTraceBack(debug.getinfo(1).short_src, {["8"] = 1,["9"] = 1,["10"] = 1,["11"] = 3,["12"] = 4,["13"] = 3,["14"] = 4,["15"] = 7,["16"] = 8,["17"] = 9,["18"] = 10,["19"] = 11,["20"] = 12,["23"] = 16,["24"] = 7,["25"] = 19,["26"] = 20,["27"] = 21,["29"] = 24,["30"] = 19,["31"] = 27,["32"] = 28,["33"] = 27,["34"] = 31,["35"] = 32,["36"] = 33,["37"] = 34,["38"] = 36,["39"] = 37,["40"] = 38,["41"] = 40,["42"] = 41,["43"] = 47,["44"] = 47,["45"] = 47,["46"] = 47,["47"] = 47,["48"] = 48,["49"] = 49,["50"] = 49,["51"] = 49,["52"] = 49,["53"] = 49,["54"] = 51,["55"] = 51,["56"] = 51,["57"] = 51,["58"] = 51,["59"] = 51,["60"] = 51,["61"] = 51,["62"] = 51,["63"] = 51,["64"] = 51,["65"] = 51,["66"] = 51,["67"] = 51,["68"] = 51,["69"] = 51,["70"] = 51,["71"] = 31,["72"] = 70,["73"] = 71,["74"] = 72,["75"] = 73,["76"] = 75,["77"] = 75,["78"] = 75,["79"] = 75,["80"] = 75,["81"] = 75,["82"] = 75,["83"] = 75,["84"] = 75,["85"] = 75,["86"] = 75,["87"] = 87,["88"] = 88,["89"] = 89,["91"] = 92,["92"] = 93,["93"] = 95,["94"] = 70,["95"] = 4,["96"] = 4,["97"] = 4,["98"] = 3,["101"] = 4});
local ____exports = {}
local ____dota_ts_adapter = require("lib.dota_ts_adapter")
local BaseAbility = ____dota_ts_adapter.BaseAbility
local registerAbility = ____dota_ts_adapter.registerAbility
____exports.meepo_earthbind_ts_example = __TS__Class()
local meepo_earthbind_ts_example = ____exports.meepo_earthbind_ts_example
meepo_earthbind_ts_example.name = "meepo_earthbind_ts_example"
__TS__ClassExtends(meepo_earthbind_ts_example, BaseAbility)
function meepo_earthbind_ts_example.prototype.GetCooldown(self)
    local cooldown = self:GetSpecialValueFor("cooldown")
    if IsServer() then
        local talent = self:GetCaster():FindAbilityByName("special_bonus_unique_meepo_3")
        if talent then
            cooldown = cooldown - talent:GetSpecialValueFor("value")
        end
    end
    return cooldown
end
function meepo_earthbind_ts_example.prototype.OnAbilityPhaseStart(self)
    if IsServer() then
        self:GetCaster():EmitSound("Hero_Meepo.Earthbind.Cast")
    end
    return true
end
function meepo_earthbind_ts_example.prototype.OnAbilityPhaseInterrupted(self)
    self:GetCaster():StopSound("Hero_Meepo.Earthbind.Cast")
end
function meepo_earthbind_ts_example.prototype.OnSpellStart(self)
    local caster = self:GetCaster()
    local point = self:GetCursorPosition()
    local projectileSpeed = self:GetSpecialValueFor("speed")
    local direction = (point - caster:GetAbsOrigin()):Normalized()
    direction.z = 0
    local distance = (point - caster:GetAbsOrigin()):Length()
    local radius = self:GetSpecialValueFor("radius")
    self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_meepo/meepo_earthbind_projectile_fx.vpcf", PATTACH_CUSTOMORIGIN, caster)
    ParticleManager:SetParticleControl(
        self.particle,
        0,
        caster:GetAbsOrigin()
    )
    ParticleManager:SetParticleControl(self.particle, 1, point)
    ParticleManager:SetParticleControl(
        self.particle,
        2,
        Vector(projectileSpeed, 0, 0)
    )
    ProjectileManager:CreateLinearProjectile({
        Ability = self,
        EffectName = "",
        vSpawnOrigin = caster:GetAbsOrigin(),
        fDistance = distance,
        fStartRadius = radius,
        fEndRadius = radius,
        Source = caster,
        bHasFrontalCone = false,
        iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_NONE,
        iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
        iUnitTargetType = DOTA_UNIT_TARGET_NONE,
        vVelocity = direction * projectileSpeed,
        bProvidesVision = true,
        iVisionRadius = radius,
        iVisionTeamNumber = caster:GetTeamNumber()
    })
end
function meepo_earthbind_ts_example.prototype.OnProjectileHit(self, _target, location)
    local caster = self:GetCaster()
    local duration = self:GetSpecialValueFor("duration")
    local radius = self:GetSpecialValueFor("radius")
    local units = FindUnitsInRadius(
        caster:GetTeamNumber(),
        location,
        nil,
        radius,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        bit.bor(DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_HERO),
        DOTA_UNIT_TARGET_FLAG_NONE,
        0,
        false
    )
    for ____, unit in ipairs(units) do
        unit:AddNewModifier(caster, self, "modifier_meepo_earthbind", {duration = duration})
        unit:EmitSound("Hero_Meepo.Earthbind.Target")
    end
    ParticleManager:DestroyParticle(self.particle, false)
    ParticleManager:ReleaseParticleIndex(self.particle)
    return true
end
meepo_earthbind_ts_example = __TS__Decorate(
    meepo_earthbind_ts_example,
    meepo_earthbind_ts_example,
    {registerAbility(nil)},
    {kind = "class", name = "meepo_earthbind_ts_example"}
)
____exports.meepo_earthbind_ts_example = meepo_earthbind_ts_example
return ____exports
