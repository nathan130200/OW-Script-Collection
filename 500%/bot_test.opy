#!define randVector(min, max) vect(random.uniform(min, max), random.uniform(min, max), random.uniform(min, max))

playervar pos

#code: N0GWN


rule "respawn bot: near objective":
    @Event playerDied
    @Team 1
    eventPlayer.pos = nearestWalkablePosition(getObjectivePosition(getCurrentObjective()) + randVector(-100, 100))

    if any([isInLoS(eventPlayer.pos, x, BarrierLos.PASS_THROUGH_BARRIERS) for x in getPlayers(Team.1)]):
        wait(0.5)
        goto RULE_START

    wait(random.randint(3, 5))

    eventPlayer.resurrect()
    eventPlayer.setHealth(eventPlayer.getMaxHealth())

rule "random ultimate: all bots":
    @Event eachPlayer
    @Team 1
    @Condition eventPlayer.isAlive()
    if random.randint(0, 100) <= 10:
        getPlayers(Team.2).setUltCharge(100)