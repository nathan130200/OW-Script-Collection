settings {
    "lobby": {
        "mapRotation": "paused",
        "returnToLobby": "afterGame"
    },
    "gamemodes": {
        "push": {
            "enabledMaps": [
                "esperanca"
            ]
        }
    }
}

playervar noClipState
playervar noClipPos
playervar noClipSpeed


rule "NoClip: Enable":
    @Event eachPlayer
    @Condition eventPlayer.noClipState == false
    @Condition eventPlayer.isHoldingButton(Button.MELEE) == true
    
    eventPlayer.noClipState = true
    eventPlayer.noClipPos = eventPlayer.getPosition()
    eventPlayer.startForcingPosition(eventPlayer.noClipPos, true)
    eventPlayer.disableEnvironmentCollision(true)


rule "NoClip: Disable":
    @Event eachPlayer
    @Condition eventPlayer.noClipState == true
    @Condition eventPlayer.isHoldingButton(Button.CROUCH) == true
    
    eventPlayer.noClipState = false
    eventPlayer.stopForcingPosition()
    eventPlayer.enableEnvironmentCollision()


rule "NoClip: Update Position":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.INTERACT) == true
    @Condition eventPlayer.noClipState == true
    
    eventPlayer.noClipPos += eventPlayer.getFacingDirection() * eventPlayer.noClipSpeed
    #Update at 30Hz - For 60Hz use 0.016 instead (may cause server lagging/crashes)
    wait(0.022)
    if RULE_CONDITION:
        goto RULE_START


rule "NoClip: Setup":
    hudHeader(localPlayer, "No Clip Speed: {0}".format(localPlayer.noClipSpeed), HudPosition.LEFT, -5, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.DEFAULT)


rule "NoClip: Setup":
    @Event eachPlayer
    
    eventPlayer.disallowButton(Button.PRIMARY_FIRE)
    eventPlayer.disallowButton(Button.SECONDARY_FIRE)
    eventPlayer.noClipSpeed = 0.75


rule "NoClip: Decrease Speed":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.PRIMARY_FIRE) == true
    
    eventPlayer.noClipSpeed -= 0.01
    wait(0.025)
    if RULE_CONDITION:
        goto RULE_START


rule "NoClip: Increase Speed":
    @Event eachPlayer
    @Condition eventPlayer.isHoldingButton(Button.SECONDARY_FIRE) == true
    
    eventPlayer.noClipSpeed += 0.01
    wait(0.025)
    if RULE_CONDITION:
        goto RULE_START