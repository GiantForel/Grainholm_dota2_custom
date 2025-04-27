import { reloadable } from "./lib/tstl-utils";
import { modifier_panic } from "./modifiers/modifier_panic";

const heroSelectionTime = 10;
const forceHero = "meepo";

declare global {
    interface CDOTAGameRules {
        Addon: GameMode;
    }
}

@reloadable
export class GameMode {
    public static Precache(this: void, context: CScriptPrecacheContext) {
        //Meepo Example
        PrecacheResource("particle", "particles/units/heroes/hero_meepo/meepo_earthbind_projectile_fx.vpcf", context);
        PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_meepo.vsndevts", context);
        PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_brewmaster.vsndevts", context)
        PrecacheResource("texture","particles/units/heroes/hero_juggernaut/juggernaut_healing_ward_eruption_ripple.vpcf", context);
        PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_earhshaker.vsndevts", context)
        PrecacheResource("particle", "particles/units/heroes/hero_ringmaster/funnel_cake_ground_anchors.vpcf", context);
        PrecacheResource("particle","particles/units/heroes/hero_juggernaut/juggernaut_healing_ward_eruption_ripple.vpcf", context);

    }

    public static Activate(this: void) {
        // When the addon activates, create a new instance of this GameMode class.
        GameRules.Addon = new GameMode();
    }

    constructor() {
        this.configure();

        // Register event listeners for dota engine events
        ListenToGameEvent("game_rules_state_change", () => this.OnStateChange(), undefined);
        ListenToGameEvent("npc_spawned", event => this.OnNpcSpawned(event), undefined);
        ListenToGameEvent("dota_inventory_item_added", event => this.OnHeroScrollGain(event), undefined);

        // Register event listeners for events from the UI
        CustomGameEventManager.RegisterListener("ui_panel_closed", (_, data) => {
            print(`Player ${data.PlayerID} has closed their UI panel.`);

            // Respond by sending back an example event
            const player = PlayerResource.GetPlayer(data.PlayerID)!;
            /*CustomGameEventManager.Send_ServerToPlayer(player, "example_event", {
                myNumber: 42,
                myBoolean: true,
                myString: "Hello!",
                myArrayOfNumbers: [1.414, 2.718, 3.142]
            });

            // Also apply the panic modifier to the sending player's hero
            const hero = player.GetAssignedHero();
            if (hero != undefined) { // Hero didn't spawn yet or dead
                //AddNewModifier(caster: CDOTA_BaseNPC | nil, ability: CDOTABaseAbility | nil, modifierName: string, modifierTable: table | nil): CDOTA_Buff
                hero.AddNewModifier(hero, undefined, modifier_panic.name, { duration: 5 });
            }*/
        });
    }

    private configure(): void {
        GameRules.SetCustomGameTeamMaxPlayers(DotaTeam.GOODGUYS, 4);
        GameRules.SetCustomGameTeamMaxPlayers(DotaTeam.BADGUYS, 4);

        //GameRules.SetShowcaseTime(0);
        //GameRules.SetHeroSelectionTime(heroSelectionTime);
        //maybe error when try to call function CustomGameSetup
        this.CustomGameSetup();
    }

    public CustomGameSetup(): void {
        GameRules.EnableCustomGameSetupAutoLaunch(true)
        GameRules.SetCustomGameSetupAutoLaunchDelay(0)
        GameRules.SetHeroSelectionTime(heroSelectionTime)
        GameRules.SetStrategyTime(0)
        GameRules.SetPreGameTime(0)
        GameRules.SetShowcaseTime(0)
        GameRules.SetPostGameTime(5)
        GameRules.SetTimeOfDay(14)

        //Disable annoying sound
        //maybe error then create const? I need in lua  local GameMode = GameRules:GetGameModeEntity()
        const GameMode = GameRules.GetGameModeEntity()
        GameMode.SetAnnouncerDisabled(true)
        GameMode.SetKillingSpreeAnnouncerDisabled(true)
        GameMode.SetDaynightCycleDisabled(true)
        GameMode.DisableHudFlip(true)
        GameMode.SetDeathOverlayDisabled(true)
        GameMode.SetWeatherEffectsDisabled(true)

        //disable music events
        //SetCustomGameAllowHeroPickMusic(allow: bool): nil
        GameRules.SetCustomGameAllowHeroPickMusic(false)
        GameRules.SetCustomGameAllowMusicAtGameStart(false)
        GameRules.SetCustomGameAllowBattleMusic(false)

        //remove start scroll ???????????????????
        //SetItemAddedToInventoryFilter(filterFunc: (event: ItemAddedToInventoryFilterEvent) → bool, context: table): nil
        //GameMode.SetItemAddedToInventoryFilter(, this.OnHeroScrollGain)
        if (forceHero !== undefined)
        {
            GameMode.SetCustomGameForceHero(forceHero);
            //GameMode.SetCustomHeroMaxLevel(levelup);
            

        }
    }

    public OnStateChange(): void {
        const state = GameRules.State_Get();

        // Add 4 bots to lobby in tools
        // if (IsInToolsMode() && state == GameState.CUSTOM_GAME_SETUP) {
        //     for (let i = 0; i < 4; i++) {
        //         Tutorial.AddBot("npc_dota_hero_lina", "", "", false);
        //     }
        // }

        if (state === GameState.CUSTOM_GAME_SETUP) {
            // Automatically skip setup in tools
            if (IsInToolsMode()) {
                Timers.CreateTimer(3, () => {
                    GameRules.FinishCustomGameSetup();
                });
            }
        }

        // Start game once pregame hits
        if (state === GameState.PRE_GAME) {
            Timers.CreateTimer(0.2, () => this.StartGame());
        }
    }

    private StartGame(): void {
        print("Game starting!");

        // Do some stuff here
    }

    // Called on script_reload
    public Reload() {
        print("Script reloaded!");

        // Do some stuff here
    }
    public OnHeroScrollGain(event: DotaInventoryItemAddedEvent)
    {
        const item = EntIndexToHScript(event.item_entindex) as CDOTA_Item;

        // Проверяем, является ли предмет свитком телепорта и не имеет покупателя
        if (item.GetAbilityName() === "item_tpscroll" && item.GetPurchaser() == null) {
            return false; // Запрещаем добавление предмета в инвентарь
        }
        else return true;
        //  dota_inventory_item_added: DotaInventoryItemAddedEvent;
    }
    public OnNpcSpawned(event: NpcSpawnedEvent) {
        // interface NpcSpawnedEvent {
        //     entindex: EntityIndex;
        //     is_respawn: number;
        // }
        
        // After a hero unit spawns, apply modifier_panic for 8 seconds
        const npc = EntIndexToHScript(event.entindex) as CDOTA_BaseNPC; // Cast to npc since this is the 'npc_spawned' event
        // Give all real heroes (not illusions) the meepo_earthbind_ts_example spell
        // if (unit.IsRealHero()) {
        //     if (!unit.HasAbility("meepo_earthbind_ts_example")) {
        //         // Add lua ability to the unit
        //         unit.AddAbility("meepo_earthbind_ts_example");
        //     }
        // }
        //print("[BAREBONES] NPC Spawned");
        //DeepPrintTable(event);

        //const npc = EntIndexToHScript(keys.entindex);
        if (npc.IsRealHero()) {
        } else if (npc.GetUnitName() == "npc_dota_neutral_kobold") {
            Timers.CreateTimer(() => {
                const units = FindUnitsInRadius(npc.GetTeamNumber(), npc.GetAbsOrigin(), undefined, 500,
                                                UnitTargetTeam.ENEMY, UnitTargetType.BASIC | UnitTargetType.HERO,
                                                UnitTargetFlags.NONE, FindOrder.ANY, false);
                
                for (const unit of units) {
                    unit.ForceKill(true);
                }
            });
        }
        // if (npc.IsRealHero() && npc.bFirstSpawned == undefined) {
        //     npc.bFirstSpawned = true;
        //     OnHeroInGame(npc);
        // } else if (npc.GetUnitName() == "npc_dota_neutral_kobold") {
        //     Timers.CreateTimer(() => {
        //         const units = FindUnitsInRadius(npc.GetTeamNumber(), npc.GetAbsOrigin(), undefined, 500,
        //                                         UnitTargetTeam.ENEMY, UnitTargetType.Basic | UnitTargetType.HERO,
        //                                         UnitTargetFlags.NONE, FindOrder.FIND_ANY_ORDER, false);
                
        //         for (const unit of units) {
        //             unit.ForceKill(true);
        //         }
        //     });
        // }
        
        
    }

    
}

