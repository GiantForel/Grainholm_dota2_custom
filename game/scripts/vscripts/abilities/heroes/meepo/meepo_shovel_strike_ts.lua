local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__ClassExtends = ____lualib.__TS__ClassExtends
local __TS__Decorate = ____lualib.__TS__Decorate
local __TS__SourceMapTraceBack = ____lualib.__TS__SourceMapTraceBack
__TS__SourceMapTraceBack(debug.getinfo(1).short_src, {["8"] = 1,["9"] = 1,["10"] = 1,["11"] = 3,["12"] = 4,["13"] = 3,["14"] = 4,["15"] = 7,["16"] = 8,["17"] = 9,["18"] = 7,["19"] = 11,["20"] = 13,["21"] = 14,["22"] = 16,["23"] = 17,["24"] = 18,["25"] = 18,["26"] = 18,["27"] = 18,["28"] = 18,["29"] = 18,["30"] = 18,["31"] = 18,["32"] = 18,["33"] = 18,["34"] = 18,["35"] = 29,["36"] = 31,["37"] = 32,["38"] = 32,["39"] = 32,["40"] = 32,["41"] = 32,["42"] = 32,["43"] = 31,["45"] = 43,["46"] = 46,["47"] = 46,["48"] = 46,["49"] = 47,["50"] = 57,["51"] = 57,["52"] = 57,["53"] = 57,["54"] = 57,["55"] = 62,["56"] = 62,["57"] = 62,["58"] = 62,["59"] = 62,["60"] = 68,["61"] = 69,["62"] = 69,["63"] = 69,["64"] = 70,["65"] = 71,["66"] = 69,["67"] = 69,["68"] = 46,["69"] = 46,["70"] = 11,["71"] = 4,["72"] = 4,["73"] = 4,["74"] = 3,["77"] = 4});
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
    target:EmitSound("sounds/searing_signet.vsnd")
    Timers:CreateTimer(
        0.01,
        function()
            local effect = ParticleManager:CreateParticle("particles/units/heroes/hero_meepo/meepo_earthbind_projectile_fx.vpcf", PATTACH_WORLDORIGIN, nil)
            ParticleManager:SetParticleControl(
                effect,
                2,
                target:GetAbsOrigin()
            )
            ParticleManager:SetParticleControl(
                effect,
                0,
                Vector(radius, radius, radius)
            )
            local duration = self:GetSpecialValueFor("particle_duration")
            Timers:CreateTimer(
                duration,
                function()
                    ParticleManager:DestroyParticle(effect, false)
                    ParticleManager:ReleaseParticleIndex(effect)
                end
            )
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
