rule "clock: update":
    @Event global
    clockData[0]--
    clockData[1] = round(clockData[0] / 3600)
    clockData[2] = round((clockData[0] % 3600) / 60)
    clockData[3] = round(clockData[0] % 60)
    wait(1)

    if clockData[0] == 15:
        getAllPlayers().communicate(Comms.GOODBYE)

    if clockData[0] <= 0:
        restartMatch()
        return

    goto RULE_START

rule "clock: restart match":
    @Event global
    @Condition clockData[0] <= 1
    getAllPlayers().setStatusEffect(hostPlayer, Status.FROZEN, 9999)
    wait(1)
    setMatchTime(0)