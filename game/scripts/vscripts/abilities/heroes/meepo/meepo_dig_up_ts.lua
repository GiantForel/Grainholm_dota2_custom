local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__ClassExtends = ____lualib.__TS__ClassExtends
local __TS__Decorate = ____lualib.__TS__Decorate
local __TS__SourceMapTraceBack = ____lualib.__TS__SourceMapTraceBack
__TS__SourceMapTraceBack(debug.getinfo(1).short_src, {["8"] = 8,["9"] = 8,["10"] = 8,["11"] = 10,["12"] = 10,["13"] = 13,["14"] = 14,["15"] = 13,["16"] = 14,["18"] = 14,["19"] = 16,["20"] = 17,["21"] = 18,["22"] = 22,["23"] = 23,["24"] = 29,["25"] = 36,["26"] = 37,["27"] = 13,["28"] = 32,["29"] = 33,["30"] = 34,["31"] = 32,["32"] = 39,["33"] = 40,["34"] = 39,["35"] = 43,["36"] = 14,["37"] = 43,["38"] = 48,["39"] = 49,["40"] = 50,["41"] = 51,["42"] = 52,["43"] = 53,["44"] = 54,["45"] = 55,["46"] = 59,["47"] = 60,["48"] = 48,["49"] = 64,["50"] = 65,["51"] = 64,["52"] = 68,["53"] = 70,["54"] = 68,["55"] = 73,["56"] = 84,["57"] = 73,["58"] = 88,["59"] = 92,["60"] = 93,["61"] = 93,["62"] = 93,["63"] = 93,["64"] = 93,["65"] = 93,["66"] = 93,["67"] = 93,["68"] = 93,["69"] = 93,["70"] = 93,["71"] = 104,["72"] = 106,["73"] = 107,["74"] = 107,["75"] = 107,["76"] = 107,["77"] = 107,["78"] = 107,["79"] = 106,["81"] = 118,["82"] = 118,["83"] = 118,["84"] = 119,["85"] = 129,["86"] = 129,["87"] = 129,["88"] = 129,["89"] = 129,["90"] = 134,["91"] = 134,["92"] = 134,["93"] = 134,["94"] = 134,["95"] = 140,["96"] = 141,["97"] = 141,["98"] = 141,["99"] = 142,["100"] = 143,["101"] = 141,["102"] = 141,["103"] = 118,["104"] = 118,["105"] = 88,["106"] = 14,["107"] = 14,["108"] = 14,["109"] = 13,["112"] = 14});
local ____exports = {}
local ____dota_ts_adapter = require("lib.dota_ts_adapter")
local BaseAbility = ____dota_ts_adapter.BaseAbility
local registerAbility = ____dota_ts_adapter.registerAbility
local ____modifier_meepo_dig_up_ts = require("modifiers.heroes.meepo.modifier_meepo_dig_up_ts")
local modifier_meepo_dig_up_ts = ____modifier_meepo_dig_up_ts.modifier_meepo_dig_up_ts
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
    self.spawn_aoe = 0
    self.sound_dig = "sounds/weapons/hero/centaur/retaliate_cast.vsnd"
    self.sound_spawn = ""
end
function meepo_dig_up_ts.prototype.Precache(self, context)
    PrecacheResource("particle", "particles/units/heroes/heroes_underlord/abyssal_underlord_dust_impact_loadout.vpcf", context)
    PrecacheResource("sound", "sounds/weapons/hero/centaur/retaliate_cast.vsnd", context)
end
function meepo_dig_up_ts.prototype.GetIntrinsicModifierName(self)
    return modifier_meepo_dig_up_ts.name
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
    self.caster:AddNewModifier(self.caster, self, modifier_meepo_dig_up_ts.name, {duration = self.channeling_time})
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
