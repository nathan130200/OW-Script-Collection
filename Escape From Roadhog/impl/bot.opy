#!mainFile "../main.opy"

globalvar botIterator

rule "spawn bots":
    @Condition isGameInProgress()
    @Condition isReady
    sourceBot.setMoveSpeed(95)
    sourceBot.setStatusEffect(null, Status.FROZEN, 9999)
    sourceBot.setPrimaryFireEnabled(false)
    sourceBot.setSecondaryFireEnabled(false)
    sourceBot.setAbility1Enabled(false)
    sourceBot.setAbility2Enabled(false)
    sourceBot.setUltEnabled(false)
    sourceBot.disallowButton(Button.MELEE)
    sourceBot.disallowButton(Button.JUMP)
    sourceBot.disallowButton(Button.INTERACT)
    sourceBot.setUltCharge(0)
    sourceBot.setInvisibility(Invis.ALL)
    sourceBot.disablePlayerCollision()
    sourceBot.setDamageDealt(0)
    sourceBot.setDamageReceived(0)

    botIterator[0] = createWorkshopSetting(int[1:6], "Core", "Bot Count To Spawn", 3, 0)

    while botIterator[1] < botIterator[0]:
        createDummy(Hero.REINHARDT, Team.2, botIterator[1] + 1, random.choice(getSpawnPoints(Team.2)), Vector.FORWARD)
        botIterator[1]++
        wait(0.25)

    wait()
    
    sourceBot.setKnockbackReceived(25)
    sourceBot.clearStatusEffect(Status.FROZEN)
    sourceBot.setPrimaryFireEnabled(true)

playervar randomOffset

rule "init: bot":
    @Event eachPlayer
    @Team 2
    @Condition eventPlayer.isDummy()
    eventPlayer.setKnockbackReceived(25)
    eventPlayer.disablePlayerCollision()
    eventPlayer.setMoveSpeed(95)
    eventPlayer.randomOffset = vect(random.randint(-3, 3), random.randint(-3, 3), random.randint(-3, 3))
    eventPlayer.startFacing(directionTowards(sourceBot, getClosestPlayer(eventPlayer, Team.1)), 75, Relativity.TO_WORLD, FacingReeval.DIRECTION_AND_TURN_RATE)
    eventPlayer.startThrottleInDirection(vectorTowards(eventPlayer, sourceBot) + eventPlayer.randomOffset, 1 if distance(eventPlayer, sourceBot) >= 2 else 0, Relativity.TO_WORLD, Throttle.REPLACE_EXISTING, ThrottleReeval.DIRECTION_AND_MAGNITUDE)

rule "update random offset":
    @Event eachPlayer
    @Team 2
    @Condition eventPlayer.isDummy()
    @Condition entityExists(eventPlayer)
    eventPlayer.randomOffset = vect(random.uniform(-3, 3), 0, random.uniform(-3, 3))
    eventPlayer.startForcingOutlineFor(getAllPlayers(), true, Color.ORANGE, OutlineVisibility.ALWAYS)
    wait(2)
    
    if RULE_CONDITION:
        goto RULE_START

rule "teleport source bot to closest position in objective":
    @Event eachPlayer
    @Team 2
    @Condition eventPlayer == sourceBot
    @Condition eventPlayer.isInSpawnRoom()
    eventPlayer.randomOffset = vect(cos(random.randint(0, 360)), sin(random.randint(0, 360)), 0)
    eventPlayer.randomOffset = getObjectivePosition(getCurrentObjective()) + eventPlayer.randomOffset
    eventPlayer.randomOffset *= random.uniform(3, 5)
    eventPlayer.randomOffset = nearestWalkablePosition(eventPlayer.randomOffset)
    eventPlayer.teleport(eventPlayer.randomOffset)

rule "source too far from other bots":
    @Event eachPlayer
    @Team 2
    @Condition eventPlayer.isDummy()
    @Condition distance(sourceBot, eventPlayer) >= 3
    wait(3, Wait.ABORT_WHEN_FALSE)
    eventPlayer.teleport(sourceBot)

rule "sync bot death":
    @Condition len([p.isDead() for p in getPlayers(Team.2)]) == botIterator[0]
    kill(sourceBot, sourceBot)

playervar path
playervar track