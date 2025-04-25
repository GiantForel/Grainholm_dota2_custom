local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__ClassExtends = ____lualib.__TS__ClassExtends
local __TS__Decorate = ____lualib.__TS__Decorate
local __TS__SourceMapTraceBack = ____lualib.__TS__SourceMapTraceBack
__TS__SourceMapTraceBack(debug.getinfo(1).short_src, {["8"] = 1,["9"] = 1,["10"] = 1,["11"] = 3,["12"] = 4,["13"] = 3,["14"] = 4,["16"] = 4,["17"] = 10,["18"] = 3,["19"] = 6,["20"] = 7,["21"] = 6,["22"] = 13,["23"] = 14,["24"] = 15,["25"] = 13,["26"] = 17,["27"] = 19,["28"] = 20,["29"] = 22,["30"] = 23,["31"] = 24,["32"] = 24,["33"] = 24,["34"] = 24,["35"] = 24,["36"] = 24,["37"] = 24,["38"] = 24,["39"] = 24,["40"] = 24,["41"] = 24,["42"] = 35,["43"] = 37,["44"] = 38,["45"] = 38,["46"] = 38,["47"] = 38,["48"] = 38,["49"] = 38,["50"] = 37,["52"] = 49,["53"] = 52,["54"] = 52,["55"] = 52,["56"] = 53,["57"] = 63,["58"] = 63,["59"] = 63,["60"] = 63,["61"] = 63,["62"] = 75,["63"] = 76,["64"] = 76,["65"] = 76,["66"] = 77,["67"] = 78,["68"] = 76,["69"] = 76,["70"] = 52,["71"] = 52,["72"] = 17,["73"] = 4,["74"] = 4,["75"] = 4,["76"] = 3,["79"] = 4});
local ____exports = {}
local ____dota_ts_adapter = require("lib.dota_ts_adapter")
local BaseAbility = ____dota_ts_adapter.BaseAbility
local registerAbility = ____dota_ts_adapter.registerAbility
____exports.meepo_shovel_strike_ts = __TS__Class()
local meepo_shovel_strike_ts = ____exports.meepo_shovel_strike_ts
meepo_shovel_strike_ts.name = "meepo_shovel_strike_ts"
__TS__ClassExtends(meepo_shovel_strike_ts, BaseAbility)
function meepo_shovel_strike_ts.prototype.____constructor(self, ...)
    BaseAbility.prototype.____constructor(self, ...)
    self.sound_cast = "Hero_Brewmaster.ThunderClap"
end
function meepo_shovel_strike_ts.Precache(self, context)
    PrecacheResource("particle", "particles/units/heroes/hero_juggernaut/juggernaut_healing_ward_eruption_ripple.vpcf", context)
end
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
    target:EmitSound(self.sound_cast)
    Timers:CreateTimer(
        0.01,
        function()
            local effect = ParticleManager:CreateParticle("particles/units/heroes/hero_juggernaut/juggernaut_healing_ward_eruption_ripple.vpcf", PATTACH_WORLDORIGIN, nil)
            ParticleManager:SetParticleControl(
                effect,
                0,
                target:GetAbsOrigin()
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
