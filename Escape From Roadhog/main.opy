#!disableOptimizations
#!extension spawnMoreDummyBots
#!include "common.opy"
#!include "lobby.opy"

rule "setup: global":
    @Event global
    @Condition isReady == false
    
    while true:
        sourceBot = getPlayersInSlot(0, Team.2)
        sourceBot.setPrimaryFireEnabled(false)

        if entityExists(sourceBot):
            isReady = 1
        else:
            isReady = false
            bigMessage(getAllPlayers(), "Missing an standard bot in team 2 for this works!")
            wait(6)

        wait(1)

rule "skip setup phase":
    @Condition isInSetup()
    setMatchTime(5)

#!include "impl/bot.opy"
#!include "impl/player.opy"