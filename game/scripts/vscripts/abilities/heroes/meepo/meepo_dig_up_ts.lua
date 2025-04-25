local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__ClassExtends = ____lualib.__TS__ClassExtends
local __TS__Decorate = ____lualib.__TS__Decorate
local __TS__SourceMapTraceBack = ____lualib.__TS__SourceMapTraceBack
__TS__SourceMapTraceBack(debug.getinfo(1).short_src, {["8"] = 8,["9"] = 8,["10"] = 8,["11"] = 9,["12"] = 11,["13"] = 12,["14"] = 11,["15"] = 12,["17"] = 12,["18"] = 14,["19"] = 15,["20"] = 16,["21"] = 20,["22"] = 21,["23"] = 22,["24"] = 27,["25"] = 34,["26"] = 35,["27"] = 11,["28"] = 30,["29"] = 31,["30"] = 32,["31"] = 30,["32"] = 37,["33"] = 12,["34"] = 37,["35"] = 42,["36"] = 43,["37"] = 44,["38"] = 45,["39"] = 46,["40"] = 47,["41"] = 48,["42"] = 49,["43"] = 53,["44"] = 54,["45"] = 42,["46"] = 58,["47"] = 59,["48"] = 58,["49"] = 62,["50"] = 64,["51"] = 62,["52"] = 67,["53"] = 78,["54"] = 67,["55"] = 82,["56"] = 86,["57"] = 87,["58"] = 87,["59"] = 87,["60"] = 87,["61"] = 87,["62"] = 87,["63"] = 87,["64"] = 87,["65"] = 87,["66"] = 87,["67"] = 87,["68"] = 98,["69"] = 100,["70"] = 101,["71"] = 101,["72"] = 101,["73"] = 101,["74"] = 101,["75"] = 101,["76"] = 100,["78"] = 112,["79"] = 112,["80"] = 112,["81"] = 113,["82"] = 123,["83"] = 123,["84"] = 123,["85"] = 123,["86"] = 123,["87"] = 128,["88"] = 128,["89"] = 128,["90"] = 128,["91"] = 128,["92"] = 134,["93"] = 135,["94"] = 135,["95"] = 135,["96"] = 136,["97"] = 137,["98"] = 135,["99"] = 135,["100"] = 112,["101"] = 112,["102"] = 82,["103"] = 12,["104"] = 12,["105"] = 12,["106"] = 11,["109"] = 12});
local ____exports = {}
local ____dota_ts_adapter = require("lib.dota_ts_adapter")
local BaseAbility = ____dota_ts_adapter.BaseAbility
local registerAbility = ____dota_ts_adapter.registerAbility
require("modifiers.heroes.meepo.modifier_meepo_dig_up_ts")
____exports.meepo_dig_up_ts = __TS__Class()
local meepo_dig_up_ts = ____exports.meepo_dig_up_ts
meepo_dig_up_ts.name = "meepo_dig_up_ts"
__TS__ClassExtends(meepo_dig_up_ts, BaseAbility)
function meepo_dig_up_ts.prototype.____constructor(self, ...)
    BaseAbility.prototype.____constructor(self, ...)
    self.caster = self:GetCaster()
    self.initial_delay = 0.1
    self.channeling_mode = false
    self.target_point = Vector(0, 0, 0)
    self.damage = 0
    self.modifier_dig_up = "modifier_meepo_dig_up_ts"
    self.spawn_aoe = 0
    self.sound_dig = "sounds/weapons/hero/centaur/retaliate_cast.vsnd"
    self.sound_spawn = ""
end
function meepo_dig_up_ts.prototype.Precache(self, context)
    PrecacheResource("particle", "particles/units/heroes/hero_arc_warden/arc_warden_magnetic_tempest_start.vpcf", context)
    PrecacheResource("sound", "sounds/weapons/hero/centaur/retaliate_cast.vsnd", context)
end
function meepo_dig_up_ts.prototype.GetChannelTime(self)
    return BaseAbility.prototype.GetChannelTime(self)
end
function meepo_dig_up_ts.prototype.OnSpellStart(self)
    self.target_point = self:GetCursorPosition()
    self.spawn_aoe = self:GetSpecialValueFor("dig_radius")
    self.channeling_mana = self:GetSpecialValueFor("dig_mana_per_dig")
    self.delay_between_dig = self:GetSpecialValueFor("dig_interval")
    self.damage = self:GetSpecialValueFor("dig_damage")
    self.channeling_time = self:GetSpecialValueFor("dig_channel_time")
    EmitSoundOn(self.sound_dig, self.caster)
    self.caster:AddNewModifier(self.caster, self, self.modifier_dig_up, {duration = self.channeling_time})
    self:OnChannelThink(self.delay_between_dig)
end
function meepo_dig_up_ts.prototype.GetChannelAnimation(self)
    return ACT_DOTA_CHANNEL_ABILITY_3
end
function meepo_dig_up_ts.prototype.OnChannelFinish(self, interrupted)
    StopSoundOn(self.sound_dig, self.caster)
end
function meepo_dig_up_ts.prototype.ChannelingManaSpend(self)
    self.caster:SpendMana(self.channeling_mana, self)
end
function meepo_dig_up_ts.prototype.OnChannelThink(self, interval)
    EmitSoundOn(self.sound_dig, self.caster)
    local units = FindUnitsInRadius(
        self.caster:GetTeamNumber(),
        self.target_point,
        nil,
        self.spawn_aoe,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        bit.bor(DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_HERO),
        DOTA_UNIT_TARGET_FLAG_NONE,
        0,
        false
    )
    for ____, unit in ipairs(units) do
        ApplyDamage({
            attacker = self:GetCaster(),
            damage = self.damage,
            damage_type = DAMAGE_TYPE_MAGICAL,
            victim = unit,
            ability = self,
            damage_flags = DOTA_DAMAGE_FLAG_NONE
        })
    end
    Timers:CreateTimer(
        0.01,
        function()
            local effect = ParticleManager:CreateParticle("particles/units/heroes/hero_arc_warden/arc_warden_magnetic_tempest_start.vpcf", PATTACH_WORLDORIGIN, nil)
            ParticleManager:SetParticleControl(
                effect,
                2,
                self.caster:GetAbsOrigin()
            )
            ParticleManager:SetParticleControl(
                effect,
                0,
                Vector(self.spawn_aoe, self.spawn_aoe, self.spawn_aoe)
            )
            local duration = self:GetSpecialValueFor("dig_particle_duration")
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
meepo_dig_up_ts = __TS__Decorate(
    meepo_dig_up_ts,
    meepo_dig_up_ts,
    {registerAbility(nil)},
    {kind = "class", name = "meepo_dig_up_ts"}
)
____exports.meepo_dig_up_ts = meepo_dig_up_ts
return ____exports
