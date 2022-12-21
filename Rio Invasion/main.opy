#!include "lobby.opy"

playervar pos
playervar dist
playervar count

#!define teamPlayer Team.2
#!define teamBot Team.1
#!define initialDistance 50
#!define baseDistanceNearEnd 15

#!define randFlt(n) random.uniform(-n, n)
#!define randVec(n) vect(randFlt(n), randFlt(n), randFlt(n))

#!define resetBot(p) \
    p.resurrect()\
    p.setInvisibility(Invis.ALL)\
    p.setStatusEffect(null, Status.INVINCIBLE, 2)\
    p.teleport(p.pos)\
    p.setHealth(p.getMaxHealth())\
    p.dist = initialDistance if getPayloadProgressPercentage() <= 75 else baseDistanceNearEnd\
    wait(0.25)\
    p.setInvisibility(Invis.NONE)

rule "bot: init":
    @Event eachPlayer
    @Team teamBot
    eventPlayer.dist = initialDistance

rule "bot: invalid spawn check":
    @Event eachPlayer
    @Team teamBot
    @Condition eventPlayer.isAlive()

    if(any([distance(v, eventPlayer) <= 5 for v in getSpawnPoints(teamPlayer)])):
        kill(eventPlayer, eventPlayer)
        wait(5)

    wait(1)

    if RULE_CONDITION:
        goto RULE_START

rule "not enough players: restart match":
    @Condition isGameInProgress()
    @Condition len(getPlayers(teamPlayer)) <= 0
    wait(5, Wait.ABORT_WHEN_FALSE)
    restartMatch()

rule "bot: disable respawn":
    @Event playerDied
    @Team teamBot
    eventPlayer.disableRespawn()

rule "respawn bot: near objective":
    @Event playerDied
    @Team teamBot
    @Condition getPayloadProgressPercentage() <= 0.1
    eventPlayer.pos = nearestWalkablePosition(getObjectivePosition(getCurrentObjective()) + randVec(eventPlayer.dist))
    if any([isInLoS(eventPlayer.pos, player, BarrierLos.PASS_THROUGH_BARRIERS) for player in getPlayers(teamPlayer)]):
        wait(0.25)
        goto RULE_START
    wait(random.randint(6, 15))
    resetBot(eventPlayer)

rule "respawn bot: near payload":
    @Event playerDied
    @Team teamBot
    @Condition getPayloadProgressPercentage() > 0.1
    eventPlayer.pos = nearestWalkablePosition(getPayloadPosition() + randVec(eventPlayer.dist))
    if any([isInLoS(eventPlayer.pos, player, BarrierLos.PASS_THROUGH_BARRIERS) for player in getPlayers(teamPlayer)]):
        wait(0.25)
        goto RULE_START
    wait(random.randint(5, 10) if getPayloadProgressPercentage() <= 75 else random.randint(3, 7))
    resetBot(eventPlayer)

rule "trigger ultimate":
    @Event eachPlayer
    @Team teamBot
    @Condition eventPlayer.count >= 10
    getPlayers(teamBot).setUltCharge(100)
    getPlayers(teamBot).count = 0
    [p for p in getPlayers(teamBot) if p.isAlive()].forceButtonPress(Button.ULTIMATE)

rule "increment ultimate counter":
    @Event playerDied
    @Team teamBot
    eventPlayer.count++

rule "skip assemble heroes":
    @Event global
    @Condition isInSetup()
    setMatchTime(1)
    wait(1.5)
    setMatchTime(300)
    