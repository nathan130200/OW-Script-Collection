def playRandVoiceline():
    @Name "player: random voice line"
     #!define ifRand(n, c) if (eventPlayer.randVoiceLine % 5) == n:\
        eventPlayer.communicate(c)

    while eventPlayer.isAlive():
        ifRand(1, Comms.VOICE_LINE_UP)
        ifRand(2, Comms.VOICE_LINE_DOWN)
        ifRand(3, Comms.VOICE_LINE_LEFT)
        ifRand(4, Comms.VOICE_LINE_RIGHT)
        eventPlayer.randVoiceLine++

        wait(1)

        if not eventPlayer.isCommunicatingVoiceline():
            if (eventPlayer.randVoiceLine % 5) == 0:
                eventPlayer.communicate(Comms.HELLO)
                break
        else:
            break

        wait(0.5)

rule "prevent respawn untill ultimate is active":
    @Event eachPlayer
    @Condition eventPlayer.isDead()
    @Condition eventPlayer.isUsingUltimate()
    eventPlayer.disableRespawn()
    wait(1)
    waitUntil(not eventPlayer.isUsingUltimate(), 15)
    wait(1)
    eventPlayer.enableRespawn()

rule "sombra: hacked status improvements":
    @Event eachPlayer
    @Condition eventPlayer.hasStatusEffect(Status.HACKED)
    eventPlayer.startTransformingThrottle(-1, -1, eventPlayer.getFacingDirection())
    waitUntil(not eventPlayer.hasStatusEffect(Status.HACKED), 9999)
    eventPlayer.stopTransformingThrottle()

rule "all heroes: small chance to stun on melee":
    @Event playerDealtDamage
    @Condition eventAbility == Button.MELEE
    @Condition random.uniform(0, 1) <= 0.2
    victim.setStatusEffect(attacker, Status.ASLEEP, 0.5)