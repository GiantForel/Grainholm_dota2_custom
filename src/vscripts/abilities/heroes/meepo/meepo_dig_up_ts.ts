// способность с задержкой будет вызывать рандомную руну из 3х баунти, волшебство и вода -  вскопка
// мб вообще вещи с низкой вероятностью или хилки в виде итема
//в идеале вскопка будет 10сек и на каждую секу будет шанс выкопа
// the channeling ability will call a random rune from 3 bounty, magic water  -  dig up
// may be dig up items with low chance or heal salve
//  in ideal dig up will channeling in 10 sec, and every 1 sec will be chance dig up

import { BaseAbility, registerAbility } from "../../../lib/dota_ts_adapter";
//import "../../../modifiers/heroes/meepo/modifier_meepo_dig_up_ts.ts";
import { modifier_meepo_dig_up_ts } from "../../../modifiers/heroes/meepo/modifier_meepo_dig_up_ts";


@registerAbility()
export class meepo_dig_up_ts extends BaseAbility{
    // Ability properties
    caster:CDOTA_BaseNPC = this.GetCaster();
    initial_delay: number = 0.1;
    channeling_mode: boolean = false;
    channeling_mana?: number;
    channeling_time?: number; 
    delay_between_dig?: number;
    target_point: Vector = Vector(0,0,0);
    damage: number = 0;
    //modifier_dig_up: string = "modifier_meepo_dig_up_ts";
    

    // Ability specials
    max_rune?: number;
    spawn_aoe: number = 0;
    rune_duration?: number;

    Precache(context: CScriptPrecacheContext){
        PrecacheResource("particle", "particles/units/heroes/heroes_underlord/abyssal_underlord_dust_impact_loadout.vpcf", context);
        PrecacheResource("sound", "sounds/weapons/hero/centaur/retaliate_cast.vsnd", context);
    }
    sound_dig: string = "sounds/weapons/hero/centaur/retaliate_cast.vsnd";
    sound_spawn: string = "";

    GetIntrinsicModifierName(): string {
		return modifier_meepo_dig_up_ts.name;
	}

    GetChannelTime(): number {
		// Reimagined: Endless Barrage: Can be set to auto cast to increase the max channel time to x seconds, firing a wave of arrows every y seconds. However, each wave drains z mana. Lasts until no mana is left to fire an additional wave, the channeling is interrupted, or the duration elapses.
		return super.GetChannelTime();
	}

    OnSpellStart() {
        this.target_point = this.GetCursorPosition() as Vector;
        this.spawn_aoe = this.GetSpecialValueFor("dig_radius");
        this.channeling_mana = this.GetSpecialValueFor("dig_mana_per_dig");
        this.delay_between_dig = this.GetSpecialValueFor("dig_interval")
        this.damage = this.GetSpecialValueFor("dig_damage");
        this.channeling_time = this.GetSpecialValueFor("dig_channel_time")
        EmitSoundOn(this.sound_dig, this.caster);
        


        this.caster.AddNewModifier(this.caster, this, modifier_meepo_dig_up_ts.name, { duration: this.channeling_time });
        this.OnChannelThink(this.delay_between_dig);
 
    }

    GetChannelAnimation(): GameActivity_t {
        return GameActivity.DOTA_CHANNEL_ABILITY_3;
    }

    OnChannelFinish(interrupted: boolean): void {
		// Stop the multishot sound
		StopSoundOn(this.sound_dig, this.caster);
	}

    ChannelingManaSpend(): void {
		// Check if we're currently in Endless Barrage mode, ignore otherwise
		// if (this.channeling_mode) {
		// 	// Check if there's enough mana to spend; otherwise, stop the channel
		// 	if (this.caster.GetMana() < this.channeling_mana!) {
		// 		this.caster.InterruptChannel();
		// 	}

		// 	// Spend mana
		// 	this.caster.SpendMana(this.channeling_mana!, this);
		// }
        this.caster.SpendMana(this.channeling_mana!, this);
	}
    

    OnChannelThink(interval: number): void {
        

		// Play attack sound
		EmitSoundOn(this.sound_dig, this.caster);
        const units = FindUnitsInRadius(
            this.caster.GetTeamNumber(),
            this.target_point,
            undefined,
            this.spawn_aoe,
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
                    damage: this.damage,
                    damage_type: DamageTypes.MAGICAL,
                    victim: unit,
                    ability: this,
                    damage_flags: DamageFlag.NONE
                }
            );
        }

		Timers.CreateTimer(0.01, ()=>{
            const effect = ParticleManager.CreateParticle(
                "particles/units/heroes/hero_arc_warden/arc_warden_magnetic_tempest_start.vpcf",
                ParticleAttachment.WORLDORIGIN,
                undefined,
            );

            //position - 0
            //direction - 1
            //scale -2
            //color - 3
            ParticleManager.SetParticleControl(
                effect,
                2,
                this.caster.GetAbsOrigin(),
            );
            ParticleManager.SetParticleControl(
                effect,
                0,
                Vector(this.spawn_aoe,this.spawn_aoe,this.spawn_aoe),
            );
            
            const duration = this.GetSpecialValueFor("dig_particle_duration");
            Timers.CreateTimer(duration, ()=> {
                ParticleManager.DestroyParticle(effect, false);
                ParticleManager.ReleaseParticleIndex(effect!); 
            })
    
        })
	}

}