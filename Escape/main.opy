#!extension spawnMoreDummyBots

#!define loopWhenTrue(time) wait(time)\
    if RULE_CONDITION:\
        goto RULE_START

#!include "lobby.opy"
#!include "impl/bot.opy"