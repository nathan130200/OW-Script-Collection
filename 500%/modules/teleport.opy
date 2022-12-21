rule "player: died reset behind wall state":
    @Event playerDied
    @Condition eventPlayer.isInWalls
    eventPlayer.stopForcingPosition()
    eventPlayer.setGravity(100)
    eventPlayer.isInWalls = false

rule "player: start teleport behind wall":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.INTERACT)
    @Condition eventPlayer.isHoldingButton(Button.CROUCH) 
    @Condition eventPlayer.isInWalls == false
    @Condition eventPlayer.isInWallsTime > TELEPORT_MIN_CHARGE + 10
    @Condition eventPlayer.isAlive()
    eventPlayer.isInWalls = true
    eventPlayer.wallStartPos = eventPlayer.getPosition()
    eventPlayer.startForcingPosition(eventPlayer.wallStartPos, true)
    eventPlayer.setGravity(0)

rule "player: auto trigger behind walls timeout":
    @Event eachPlayer
    @Condition eventPlayer.isInWalls
    @Condition eventPlayer.isAlive()
    @Condition eventPlayer.isInWallsTime <= TELEPORT_MIN_CHARGE
    eventPlayer.forceButtonPress(Button.JUMP)

rule "player: teleport behind walls while active":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.INTERACT)
    @Condition eventPlayer.isInWalls
    @Condition eventPlayer.isAlive()
    eventPlayer.wallStartPos += eventPlayer.getFacingDirection() * 0.16

    # 60Hz
    wait(0.016)

    if RULE_CONDITION:
        goto RULE_START

rule "player: disable teleport walls":
    @Event eachPlayer
    @Condition eventPlayer.isInWalls
    @Condition updateEveryTick(eventPlayer.isHoldingButton(Button.JUMP))
    @Condition eventPlayer.isAlive()
    eventPlayer.setGravity(100)
    eventPlayer.stopForcingPosition()
    eventPlayer.isInWalls = false

rule "player: check in walls timeout":
    @Event eachPlayer
    @Condition eventPlayer.isInWalls
    @Condition eventPlayer.isAlive()
    @Condition updateEveryTick(eventPlayer.isInWallsTime) > TELEPORT_MIN_CHARGE
    chase(eventPlayer.isInWallsTime, 0, rate=25, ChaseReeval.DESTINATION_AND_RATE)

    wait(0.25)

    if RULE_CONDITION:
        goto RULE_START

    eventPlayer.forceButtonPress(Button.JUMP)
    wait()
    chase(eventPlayer.isInWallsTime, 100, rate=10, ChaseReeval.DESTINATION_AND_RATE)

    eventPlayer.setGravity(100)
    eventPlayer.stopForcingPosition()
    eventPlayer.isInWalls = false

rule "player: in walls force outline":
    @Event eachPlayer
    @Condition eventPlayer.isInWalls
    @Condition eventPlayer.isAlive()
    eventPlayer.startForcingOutlineFor(getAllPlayers(), true, Color.TEAM_1, OutlineVisibility.ALWAYS)
    eventPlayer.disableEnvironmentCollision(false)

    wait(0.5)

    if RULE_CONDITION:
        goto RULE_START

    eventPlayer.stopForcingOutlineFor(getAllPlayers())
    eventPlayer.enableEnvironmentCollision()