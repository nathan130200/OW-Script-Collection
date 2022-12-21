#!disableOptimizations
#!extension buffStatusEffects
#!extension buffAndDebuffSounds

settings {
    "main": {
        "description": "Workshop version from Mei's Snowball Offensive",
        "modeName": "Mei Snowball Offensive"
    },
    "lobby": {
        "mapRotation": "afterGame",
        "returnToLobby": "afterGame"
    },
    "gamemodes": {
        "hybrid": {
            
        },
        "general": {
            "enableHeroSwitching": false,
            "enableCompetitiveRules": true,
            "gamemodeStartTrigger": "manual",
            "enableKillCam": false,
            "roleLimit": "1Tank2Offense2Support",
            "respawnTime%": 50
        }
    },
    "heroes": {
        "allTeams": {
            "enabledHeroes": [
                "mei"
            ]
        }
    }
}

#!define s_maxAmmo 27

#!define loopAtRate(time)\
    wait(time)\
    if RULE_CONDITION:\
        goto RULE_START

globalvar hudIndex

#!define pushHudIndex(p) hudIndex[p] = hudIndex[p] - 1
#!define popHudIndex(p) hudIndex[p] = hudIndex[p] + 1 
#!define getHudIndex(p) evalOnce(hudIndex[p])
#!define defaultSelector p.hudTime == true

#!define SPACES_WIDTH "                                                                                                                                                              "

#!define mainInfoHud(text, color, slot, fn) hudSubtext([p for p in getAllPlayers() if fn], "{}{}".format(text, SPACES_WIDTH), HudPosition.LEFT, getHudIndex(slot), color, HudReeval.VISIBILITY_SORT_ORDER_STRING_AND_COLOR, SpecVisibility.DEFAULT)\
    popHudIndex(slot)\
    wait()

playervar hudTime
playervar baseDmgCalc
playervar baseEffectCalc
playervar cloneEffect

rule "skip assemble heroes":
    @Event global
    @Condition isAssemblingHeroes()
    setMatchTime(1)
    waitUntil(isInSetup(), 9999)
    setMatchTime(15)

rule "player: init":
    @Event global
    hudIndex[0] = -10
    mainInfoHud("\u200b\n\nHold '{}' to throw an snowball on enemy.".format(buttonString(Button.SECONDARY_FIRE)), Color.ORANGE, 0, defaultSelector)
    mainInfoHud("Once snowball hit will temporary freeze enemy.", Color.YELLOW, 0, defaultSelector)
    mainInfoHud("Critical hits instantly kill enemy.", Color.ORANGE, 0, defaultSelector)
    mainInfoHud("Less ammo deal less damage, always keep full charge of snowball.", Color.YELLOW, 0, defaultSelector)
    mainInfoHud("Snowball Damage Percent: {}%".format(localPlayer.baseDmgCalc), Color.TURQUOISE, 0, p.isAlive())
    mainInfoHud("Freeze Effect Duration: {}%".format(localPlayer.baseEffectCalc), Color.LIME_GREEN, 0, p.isAlive())

rule "mei: respawned":
    @Event eachPlayer
    @Condition eventPlayer.hasSpawned()
    @Condition eventPlayer.isInSpawnRoom()
    @Condition eventPlayer.hudTime == false
    eventPlayer.hudTime = true
    waitUntil(eventPlayer.isMoving(), 9999)
    wait(5)
    eventPlayer.hudTime = false
    
rule "mei: init effect":
    @Event playerJoined
    eventPlayer.preloadHero(Hero.MEI)
    wait()
    createEffect(getAllPlayers(), Effect.ECHO_CLONING, null, eventPlayer, 0, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.cloneEffect[0] = getLastCreatedEntity()
    createEffect(getAllPlayers(), Effect.ECHO_CLONING_SOUND, null, eventPlayer, 50, EffectReeval.VISIBILITY_POSITION_AND_RADIUS)
    eventPlayer.cloneEffect[1] = getLastCreatedEntity()

rule "mei: release effect":
    @Event playerLeft
    destroyEffect(eventPlayer.cloneEffect[0])
    destroyEffect(eventPlayer.cloneEffect[1])
    eventPlayer.cloneEffect = null

rule "mei: spawned":
    @Event eachPlayer
    @Condition eventPlayer.hasSpawned()
    eventPlayer.setAllowedHeroes(Hero.MEI)
    eventPlayer.setPrimaryFireEnabled(false)
    eventPlayer.setSecondaryFireEnabled(true)
    eventPlayer.setReloadEnabled(false)
    eventPlayer.setAbility1Enabled(false)
    eventPlayer.setAmmo(0, s_maxAmmo)
    eventPlayer.setDamageReceived(80)

rule "mei: update":
    @Event eachPlayer
    @Condition eventPlayer.isAlive()
    eventPlayer.setMaxAmmo(0, s_maxAmmo)
    eventPlayer.baseDmgCalc = max(10, ((eventPlayer.getAmmo(0) / s_maxAmmo) * 100) + 15)
    eventPlayer.baseEffectCalc = max(((eventPlayer.getAmmo(0) / s_maxAmmo) - 0.5), 0.016)
    eventPlayer.setDamageDealt(eventPlayer.baseDmgCalc)
    loopAtRate(1)

rule "mei: out of ammo":
    @Event eachPlayer
    @Condition updateEveryTick(eventPlayer.getAmmo(0)) < s_maxAmmo
    @Condition eventPlayer.isFiringSecondaryFire() == false
    @Condition eventPlayer.isInSpawnRoom() == false
    eventPlayer.setAmmo(0, eventPlayer.getAmmo(0) + 1)
    loopAtRate(0.16)
    
    if eventPlayer.getAmmo(0) == s_maxAmmo:
        playEffect(eventPlayer, DynamicEffect.BAD_PICKUP_EFFECT, Color.LIME_GREEN, eventPlayer.getPosition(), 35)
        playEffect(eventPlayer, DynamicEffect.BUFF_IMPACT_SOUND, Color.RED, eventPlayer.getPosition(), 45)
        smallMessage(eventPlayer, "Snowball weapon was fully recharged")

    loopAtRate(1)

rule "mei: apply damage":
    @Event playerTookDamage
    @Condition eventAbility == Button.SECONDARY_FIRE
    @Condition attacker.getCurrentHero() == Hero.MEI

    playEffect(getAllPlayers(), DynamicEffect.GOOD_EXPLOSION, Color.SKY_BLUE, victim.getPosition(), 5)
    playEffect(getAllPlayers(), DynamicEffect.DEBUFF_IMPACT_SOUND, Color.SKY_BLUE, victim.getPosition(), 45)

    if eventWasCriticalHit:
        kill(victim, attacker)

        if attacker.getNormalizedHealth() <= 0.15:
            attacker.startHoT(attacker, 3.5, 5)

        playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.PURPLE, eventPlayer.getPosition(), 7)
        playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION_SOUND, Color.RED, eventPlayer, 35)
    else:
        playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.RED, eventPlayer.getPosition(), 7)
        playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION_SOUND, Color.RED, eventPlayer, 35)
        # Prevent stacking same frozen effect that make enemy too vulnerable.
        victim.setStatusEffect(attacker, Status.FROZEN, attacker.baseEffectCalc if not victim.hasStatusEffect(Status.FROZEN) else 0.033)

rule "mei: melee attack":
    @Event playerTookDamage
    @Condition attacker.getCurrentHero() == Hero.MEI
    @Condition eventAbility == Button.MELEE
    victim.applyImpulse(vect(0, 7, 4), 5, Relativity.TO_PLAYER, Impulse.CANCEL_CONTRARY_MOTION_XYZ)