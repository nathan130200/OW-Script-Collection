#!mainFile "../main.opy"

globalvar mainBot
globalvar dummyBots
globalvar isReady
playervar state

enum MoiraState:
    IDLE,
    FIRING,
    HEALING,
    THROWN_ORB_1,
    THROWN_ORB_2,
    ESCAPE

rule "init: main bot hud":
    hudHeader(hostPlayer if not isReady else null, "MISSING STANDARD BOT ON SLOT 1 IN TEAM 2", HudPosition.RIGHT, -99, Color.YELLOW, HudReeval.VISIBILITY, SpecVisibility.NEVER)

rule "init: main bot":
    @Event global

    if not entityExists(mainBot):
        mainBot = getPlayersInSlot(0, Team.2)

    if not entityExists(mainBot):
        isReady = false
        destroyAllDummies()
        wait(0.5)
    else:
        isReady = true
    
    wait(0.5)
    goto RULE_START

rule "setup: main bot":
    @Event eachPlayer
    @Condition eventPlayer == mainBot
    @Condition isReady
    eventPlayer.disablePlayerCollision()
    eventPlayer.disallowButton(Button.PRIMARY_FIRE)
    eventPlayer.disallowButton(Button.ABILITY_1)
    eventPlayer.disallowButton(Button.ABILITY_2)
    eventPlayer.disallowButton(Button.ULTIMATE)
    eventPlayer.disallowButton(Button.MELEE)
    eventPlayer.setStatusEffect(hostPlayer, Status.INVINCIBLE, 9999)
    eventPlayer.setStatusEffect(hostPlayer, Status.PHASED_OUT, 9999)
    eventPlayer.setInvisibility(Invis.ALL)
    eventPlayer.setDamageDealt(0)

    for Z in range(0, 6):
        createDummy(Hero.MOIRA, eventPlayer.getTeam(), Z + 1, nearestWalkablePosition(eventPlayer.getPosition()), eventPlayer.getFacingDirection())
        wait()

playervar throttleRate

#!define setState(entity, value) # Entity enter in state 'value'"\
    entity.state = value

rule "init: assist bot":
    @Event eachPlayer
    @Condition eventPlayer.isDummy()
    @Condition isReady
    dummyBots.append(eventPlayer)

rule "bot: update throttle":
    @Event eachPlayer
    @Condition eventPlayer.isAlive()
    @Condition eventPlayer.isDummy()
    @Condition isReady
    eventPlayer.throttleRate[0] = random.uniform(2, 5)
    eventPlayer.throttleRate[1] = 0 if distance(eventPlayer, mainBot) <= eventPlayer.throttleRate[0] else 1
    loopWhenTrue(0.25)

rule "bot: update state":
    @Event eachPlayer
    @Condition eventPlayer.isAlive()
    @Condition eventPlayer.isDummy()
    @Condition isReady
    if eventPlayer.state == MoiraState.IDLE:
        eventPlayer.startFacing(mainBot.getFacingDirection(), 250, Relativity.TO_WORLD, FacingReeval.DIRECTION_AND_TURN_RATE)

        if random.uniform(0, 1) <= 0.16 and eventPlayer.getAbilityCooldown(Button.ABILITY_1) <= 0:
            setState(eventPlayer, MoiraState.ESCAPE)
        else:
            if eventPlayer.getNormalizedHealth() <= 0.5:
                if eventPlayer.getAbilityCooldown(Button.ABILITY_2) <= 0:
                    setState(eventPlayer, MoiraState.THROWN_ORB_2)
                else if eventPlayer.getNormalizedHealth() <= 0.25 and eventPlayer.getAbilityCharge(Button.PRIMARY_FIRE) >= 0.1:
                    setState(eventPlayer, MoiraState.HEALING)
            else:
                if random.uniform(0, 1) <= 0.13 and eventPlayer.getAbilityCooldown(Button.ABILITY_2) <= 0:
                    setState(eventPlayer, MoiraState.THROWN_ORB_1)
                else:
                    setState(eventPlayer, MoiraState.FIRING)
            
    loopWhenTrue(0.25)
        
rule "moira: fire":
    @Event eachPlayer
    @Condition eventPlayer.isDummy()
    @Condition eventPlayer.state == MoiraState.FIRING
    eventPlayer.startForcingButton(Button.SECONDARY_FIRE)
    eventPlayer.startFacing(directionTowards(eventPlayer, getClosestPlayer(eventPlayer, Team.1)), 150, Relativity.TO_PLAYER, FacingReeval.DIRECTION_AND_TURN_RATE)
    wait(5)
    eventPlayer.stopForcingButton(Button.SECONDARY_FIRE)
    setState(eventPlayer, MoiraState.IDLE)

rule "moira: escape":
    @Event eachPlayer
    @Condition eventPlayer.isDummy()
    @Condition eventPlayer.state == MoiraState.ESCAPE
    eventPlayer.forceButtonPress(Button.ABILITY_1)
    wait()
    setState(eventPlayer, MoiraState.IDLE)

rule "moira: heal":
    @Event eachPlayer
    @Condition eventPlayer.isDummy()
    @Condition eventPlayer.state == MoiraState.HEALING
    eventPlayer.startForcingButton(Button.PRIMARY_FIRE)
    wait(5)
    eventPlayer.stopForcingButton(Button.PRIMARY_FIRE)
    setState(eventPlayer, MoiraState.IDLE)

rule "moira: damage orb":
    @Event eachPlayer
    @Condition eventPlayer.isDummy()
    @Condition eventPlayer.state == MoiraState.THROWN_ORB_1
    eventPlayer.forceButtonPress(Button.ABILITY_2)
    wait(0.25)
    eventPlayer.forceButtonPress(Button.SECONDARY_FIRE)
    setState(eventPlayer, MoiraState.IDLE)

rule "moira: healing orb":
    @Event eachPlayer
    @Condition eventPlayer.isDummy()
    @Condition eventPlayer.state == MoiraState.THROWN_ORB_2
    eventPlayer.forceButtonPress(Button.ABILITY_2)
    wait(0.25)
    eventPlayer.forceButtonPress(Button.PRIMARY_FIRE)
    setState(eventPlayer, MoiraState.IDLE)