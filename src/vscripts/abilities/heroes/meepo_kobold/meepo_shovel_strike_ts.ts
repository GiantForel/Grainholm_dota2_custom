import { BaseAbility, registerAbility } from "../../../lib/dota_ts_adapter";

@registerAbility()
export class meepo_shovel_strike_ts extends BaseAbility {

    sound_cast: string =	"soundevents/game_sounds_heroes/game_sounds_centaur.vsndevts";
    particle: string = "particles/units/heroes/hero_centaur/centaur_double_edge.vpcf";
    //icon_texture: string = "/images/teamfancontent/season_9/8255756/spray5_png.vtex_c";

    OnSpellStart()
    {
        const target = this.GetCursorTarget();
        const shovel_vision = this.GetSpecialValueFor("shovel_vision");

        EmitSoundOn(this.sound_cast, this.GetCaster());
        //GetAbilityTextureNameForAbility(this.icon_texture);

    }

}


