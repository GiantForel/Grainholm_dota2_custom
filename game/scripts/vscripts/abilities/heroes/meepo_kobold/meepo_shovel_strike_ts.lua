local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__ClassExtends = ____lualib.__TS__ClassExtends
local __TS__Decorate = ____lualib.__TS__Decorate
local __TS__SourceMapTraceBack = ____lualib.__TS__SourceMapTraceBack
__TS__SourceMapTraceBack(debug.getinfo(1).short_src, {["8"] = 1,["9"] = 1,["10"] = 1,["11"] = 3,["12"] = 4,["13"] = 3,["14"] = 4,["15"] = 7,["16"] = 8,["17"] = 9,["18"] = 7,["19"] = 11,["20"] = 13,["21"] = 14,["22"] = 16,["23"] = 17,["24"] = 18,["25"] = 18,["26"] = 18,["27"] = 18,["28"] = 18,["29"] = 18,["30"] = 18,["31"] = 18,["32"] = 18,["33"] = 18,["34"] = 18,["35"] = 29,["36"] = 31,["37"] = 32,["38"] = 32,["39"] = 32,["40"] = 32,["41"] = 32,["42"] = 32,["43"] = 31,["45"] = 43,["46"] = 45,["47"] = 50,["48"] = 55,["49"] = 55,["50"] = 55,["51"] = 55,["52"] = 55,["53"] = 61,["54"] = 61,["55"] = 61,["56"] = 61,["57"] = 61,["58"] = 66,["59"] = 66,["60"] = 66,["61"] = 66,["62"] = 66,["63"] = 71,["64"] = 74,["65"] = 74,["66"] = 74,["67"] = 75,["68"] = 76,["69"] = 77,["70"] = 78,["71"] = 74,["72"] = 74,["73"] = 11,["74"] = 4,["75"] = 4,["76"] = 4,["77"] = 3,["80"] = 4});
local ____exports = {}
local ____dota_ts_adapter = require("lib.dota_ts_adapter")
local BaseAbility = ____dota_ts_adapter.BaseAbility
local registerAbility = ____dota_ts_adapter.registerAbility
____exports.meepo_shovel_strike_ts = __TS__Class()
local meepo_shovel_strike_ts = ____exports.meepo_shovel_strike_ts
meepo_shovel_strike_ts.name = "meepo_shovel_strike_ts"
__TS__ClassExtends(meepo_shovel_strike_ts, BaseAbility)
function meepo_shovel_strike_ts.prototype.GetCooldown(self)
    local cooldown = self:GetSpecialValueFor("cooldown")
    return cooldown
end
function meepo_shovel_strike_ts.prototype.OnSpellStart(self)
    local target = self:GetCursorTarget()
    local caster = self:GetCaster()
    local damage = self:GetSpecialValueFor("edge_damage")
    local radius = self:GetSpecialValueFor("radius")
    local units = FindUnitsInRadius(
        caster:GetTeamNumber(),
        target:GetAbsOrigin(),
        nil,
        radius,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        bit.bor(DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_HERO),
        DOTA_UNIT_TARGET_FLAG_NONE,
        0,
        false
    )
    for ____, unit in ipairs(units) do
        ApplyDamage({
            attacker = self:GetCaster(),
            damage = damage,
            damage_type = DAMAGE_TYPE_MAGICAL,
            victim = unit,
            ability = self,
            damage_flags = DOTA_DAMAGE_FLAG_NONE
        })
    end
    target:EmitSound("sounds/items/searing_signet.vsnd")
    local effect = ParticleManager:CreateParticle("particles/units/heroes/hero_meepo/meepo_earthbind_projectile_fx.vpcf", PATTACH_WORLDORIGIN, nil)
    local effect2 = ParticleManager:CreateParticle("particles/units/heroes/hero_spectre/spectre_ambient_blade_fallback_low.vpcf", PATTACH_WORLDORIGIN, nil)
    ParticleManager:SetParticleControl(
        effect2,
        3,
        caster:GetAbsOrigin()
    )
    ParticleManager:SetParticleControl(
        effect,
        0,
        target:GetAbsOrigin()
    )
    ParticleManager:SetParticleControl(
        effect,
        1,
        Vector(radius + 300, radius + 300, radius + 300)
    )
    local duration = self:GetSpecialValueFor("effect_duration")
    Timers:CreateTimer(
        duration,
        function()
            ParticleManager:DestroyParticle(effect, false)
            ParticleManager:ReleaseParticleIndex(effect)
            ParticleManager:DestroyParticle(effect2, false)
            ParticleManager:ReleaseParticleIndex(effect2)
        end
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
