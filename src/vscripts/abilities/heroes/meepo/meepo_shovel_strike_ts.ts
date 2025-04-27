import { BaseAbility, registerAbility } from "../../../lib/dota_ts_adapter";

@registerAbility()
export class meepo_shovel_strike_ts extends BaseAbility {
    particle?: ParticleID;
    public static Precache(context: CScriptPrecacheContext) {
        //PrecacheResource("particle","particles/units/heroes/hero_juggernaut/juggernaut_healing_ward_eruption_ripple.vpcf", context);

    }
    sound_cast: string = "Hero_Brewmaster.ThunderClap"


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
        
        target.EmitSound(this.sound_cast);

        //Particle. Need to wait one frame for the older particle to be destroyed
        Timers.CreateTimer(0.01, ()=>{
            const effect = ParticleManager.CreateParticle(
                "particles/units/heroes/hero_juggernaut/juggernaut_healing_ward_eruption_ripple.vpcf",
                ParticleAttachment.WORLDORIGIN,
                undefined,
            );

            //position - 0
            //direction - 1
            //scale -2
            //color - 3
            ParticleManager.SetParticleControl(
                effect,
                0,
                target.GetAbsOrigin(),
                //Vector(4,4,4)
            );
            //ParticleManager.SetParticleControl(
            //    effect,
             //   0,
            //    Vector(radius,radius,radius),
            //);
            
            const duration = this.GetSpecialValueFor("particle_duration");
            Timers.CreateTimer(duration, ()=> {
                ParticleManager.DestroyParticle(effect, false);
                ParticleManager.ReleaseParticleIndex(effect!); 
            });
    
        })
    }

}


