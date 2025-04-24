local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__ClassExtends = ____lualib.__TS__ClassExtends
local __TS__Decorate = ____lualib.__TS__Decorate
local __TS__SourceMapTraceBack = ____lualib.__TS__SourceMapTraceBack
__TS__SourceMapTraceBack(debug.getinfo(1).short_src, {["8"] = 1,["9"] = 1,["10"] = 1,["11"] = 3,["12"] = 4,["13"] = 3,["14"] = 4,["15"] = 7,["16"] = 8,["17"] = 9,["18"] = 10,["19"] = 11,["20"] = 12,["23"] = 16,["24"] = 7,["25"] = 19,["26"] = 20,["27"] = 21,["29"] = 24,["30"] = 19,["31"] = 27,["32"] = 28,["33"] = 27,["34"] = 39,["35"] = 40,["36"] = 41,["37"] = 42,["38"] = 44,["39"] = 45,["40"] = 46,["41"] = 48,["42"] = 49,["43"] = 55,["44"] = 55,["45"] = 55,["46"] = 55,["47"] = 55,["48"] = 56,["49"] = 57,["50"] = 57,["51"] = 57,["52"] = 57,["53"] = 57,["54"] = 59,["55"] = 59,["56"] = 59,["57"] = 59,["58"] = 59,["59"] = 59,["60"] = 59,["61"] = 59,["62"] = 59,["63"] = 59,["64"] = 59,["65"] = 59,["66"] = 59,["67"] = 59,["68"] = 59,["69"] = 59,["70"] = 59,["71"] = 39,["72"] = 78,["73"] = 79,["74"] = 80,["75"] = 81,["76"] = 83,["77"] = 83,["78"] = 83,["79"] = 83,["80"] = 83,["81"] = 83,["82"] = 83,["83"] = 83,["84"] = 83,["85"] = 83,["86"] = 83,["87"] = 95,["88"] = 96,["89"] = 97,["91"] = 100,["92"] = 101,["93"] = 103,["94"] = 78,["95"] = 4,["96"] = 4,["97"] = 4,["98"] = 3,["101"] = 4});
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
