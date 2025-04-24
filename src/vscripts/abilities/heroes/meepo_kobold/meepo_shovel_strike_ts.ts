import { BaseAbility, registerAbility } from "../../../lib/dota_ts_adapter";

@registerAbility()
export class meepo_shovel_strike_ts extends BaseAbility {
    particle?: ParticleID;

    GetCooldown(){
        let cooldown = this.GetSpecialValueFor("cooldown");
        return cooldown;
    }
    OnSpellStart()
    {
        const target = this.GetCursorTarget() as CDOTA_BaseNPC ;
        const caster = this.GetCaster() as CDOTA_BaseNPC;

        const damage = this.GetSpecialValueFor("edge_damage");
        const radius = this.GetSpecialValueFor("radius");
        const units = FindUnitsInRadius(
            caster.GetTeamNumber(),
            target.GetAbsOrigin(),
            undefined,
            radius,
            UnitTargetTeam.ENEMY,
            UnitTargetType.BASIC | UnitTargetType.HERO,
            UnitTargetFlags.NONE,
            0,
            false,
        );
        for (const unit of units) {
        //ApplyDamage({victim = self:GetParent(), attacker = caster, ability = ability, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
            ApplyDamage(
                {
                    attacker: this.GetCaster(),
                    damage: damage,
                    damage_type: DamageTypes.MAGICAL,
                    victim: unit,
                    ability: this,
                    damage_flags: DamageFlag.NONE
                }
            );
        }
        
        target.EmitSound("sounds/items/searing_signet.vsnd");

        const effect = ParticleManager.CreateParticle(
            "particles/units/heroes/hero_meepo/meepo_earthbind_projectile_fx.vpcf",
            ParticleAttachment.WORLDORIGIN,
            undefined,
        );
        const effect2 = ParticleManager.CreateParticle(
            "particles/units/heroes/hero_spectre/spectre_ambient_blade_fallback_low.vpcf",
            ParticleAttachment.WORLDORIGIN,
            undefined,
        );
        ParticleManager.SetParticleControl(
            effect2,
            3,
            caster.GetAbsOrigin(),
        );

        ParticleManager.SetParticleControl(
            effect,
            0,
            target.GetAbsOrigin(),
        );
        ParticleManager.SetParticleControl(
            effect,
            1,
            Vector(radius+300,radius+300,radius+300),
        );
        const duration = this.GetSpecialValueFor("effect_duration");

        
        Timers.CreateTimer(duration, ()=> {
            ParticleManager.DestroyParticle(effect, false);
            ParticleManager.ReleaseParticleIndex(effect!);
            ParticleManager.DestroyParticle(effect2, false);
            ParticleManager.ReleaseParticleIndex(effect2!);
            
        })

        // CreateParticle(
        //     particleName: string,
        //     particleAttach: ParticleAttachment_t,
        //     owner: CBaseEntity | undefined,
        // ): ParticleID;
    }

}


