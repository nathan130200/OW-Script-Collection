#!mainFile "../main.opy"

rule "prevent player stay in spawn room":
    @Event eachPlayer
    @Condition eventPlayer.isInSpawnRoom()
    @Team 1
    eventPlayer.teleport(nearestWalkablePosition(getObjectivePosition(getCurrentObjective())))
    eventPlayer.setStatusEffect(null, Status.PHASED_OUT, 6)