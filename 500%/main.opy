#!disableOptimizations

#!include "lobby.opy"
#!include "common.opy"

# ================================================================================================ #

rule "player: teleport to area":
    @Event eachPlayer
    @Condition eventPlayer.isAlive()
    @Condition eventPlayer.isInSpawnRoom()
    wait()
    
    chase(eventPlayer.isInWallsTime, 100, rate=6.6, ChaseReeval.DESTINATION_AND_RATE)
    eventPlayer.disableGamemodeHud()
    eventPlayer.teleport(spawnData[0 if eventPlayer.getTeam() == Team.1 else 1])
    eventPlayer.setStatusEffect(hostPlayer, Status.INVINCIBLE, random.uniform(4, 5))
    eventPlayer.disablePlayerCollision()
    eventPlayer.disableGamemodeInWorldUi()
    eventPlayer.disableMessages()
    wait()

    if RULE_CONDITION:
        goto RULE_START

    playRandVoiceline()

# ================================================================================================ #

#!include "modules/hud.opy"
#!include "modules/maps.opy"
#!include "modules/scoring.opy"
#!include "modules/teleport.opy"
#!include "modules/timer.opy"

# ================================================================================================ #

#!include "misc/stats.opy"
#!include "misc/tweaks.opy"
