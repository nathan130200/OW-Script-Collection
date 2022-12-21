#!mainFile "../main.opy"

enum QuickTimeEventType:
    FAILED,
    UNSAFE_COMPLETED,
    COMPLETED

playervar qteActive
playervar pbColor
playervar qteRanges
playervar qteDesc
playervar qteProgress
playervar qteRate
playervar qteType

#!define startQuickTimeEvent(player, task) player.qteDesc = task\
    player.qteActive = true

rule "[quick time event] setup global":
    @Event global
    progressBarHud(localPlayer if localPlayer.qteActive else null, localPlayer.qteProgress, "QUICK TIME EVENT", HudPosition.TOP, 10, localPlayer.pbColor, Color.ORANGE, ProgressHudReeval.VISIBILITY_VALUES_AND_COLOR, SpecVisibility.NEVER)

    hudSubtext(localPlayer if localPlayer.qteActive else null, localPlayer.qteDesc, HudPosition.TOP, 11, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)

rule "[quick time event] triggered":
    @Event eachPlayer
    @Condition eventPlayer.qteActive == true
    eventPlayer.qteProgress = 0
    eventPlayer.qteRate = 10
    eventPlayer.qteRanges[0] = random.randint(20, 80)
    eventPlayer.qteRanges[1] = eventPlayer.qteRanges[0] + 8
    eventPlayer.qteRanges[2] = eventPlayer.qteRanges[1] + 6
    chase(eventPlayer.qteProgress, 100, rate=eventPlayer.qteRate, ChaseReeval.DESTINATION_AND_RATE)

rule "[quick time event] update":
    @Event eachPlayer
    @Condition eventPlayer.qteActive
    @Condition eventPlayer.qteProgress < 100
    if eventPlayer.qteProgress >= eventPlayer.qteRanges[0] and eventPlayer.qteProgress <= eventPlayer.qteRanges[1]:
        eventPlayer.qteRate = 7
        eventPlayer.pbColor = Color.YELLOW
        eventPlayer.qteType = QuickTimeEventType.UNSAFE_COMPLETED
    elif eventPlayer.qteProgress > eventPlayer.qteRanges[1] and eventPlayer.qteProgress <= eventPlayer.qteRanges[2]:
        eventPlayer.qteRate = 9
        eventPlayer.qteType = QuickTimeEventType.COMPLETED
        eventPlayer.pbColor = Color.GREEN
    else:
        eventPlayer.qteRate = 15
        eventPlayer.pbColor = Color.RED
        eventPlayer.qteType = QuickTimeEventType.FAILED

    wait(0.5)

    if RULE_CONDITION:
        goto RULE_START

    eventPlayer.qteActive = false

rule "[quick time event] test player jump in right time":
    @Event eachPlayer
    @Disabled
    @Condition eventPlayer.isAlive()
    @Condition eventPlayer.isHoldingButton(Button.INTERACT)
    @Condition eventPlayer.qteActive == false
    startQuickTimeEvent(eventPlayer, "JUMP IN RIGHT TIME")

    while eventPlayer.qteActive:
        if eventPlayer.isJumping():
            if eventPlayer.qteType == QuickTimeEventType.FAILED:
                bigMessage(eventPlayer, "Quick time event failed!")
                wait(1)
                kill(eventPlayer, null)
                break
            else:
                if eventPlayer.qteType == QuickTimeEventType.UNSAFE_COMPLETED:
                    bigMessage(eventPlayer, "QTE completed. Too close to die!")
                else:
                    bigMessage(eventPlayer, "QTE completed. In right time!")

                break

        wait(0.25)

    eventPlayer.qteActive = false