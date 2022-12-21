
rule "process stat: damage":
    @Event playerTookDamage
    @Condition entityExists(attacker)
    @Condition attacker != victim
    td(StatKey.DAMAGE) += eventDamage

rule "process stat: healing":
    @Event playerReceivedHealing
    @Condition entityExists(healer)
    td(StatKey.HEAL) += eventHealing

rule "process stat: ability":
    @Event eachPlayer
    @Condition any([eventPlayer.isUsingAbility1(), eventPlayer.isUsingAbility2()])
    td(StatKey.ABILITY_USE)++

rule "process stat: ultimate ability":
    @Event eachPlayer
    @Condition eventPlayer.isUsingUltimate()
    td(StatKey.ULT_USE)++

rule "process stat: distance walked":
    @Event eachPlayer
    @Condition eventPlayer.isMoving()
    td(StatKey.DISTANCE_WALKED) += eventPlayer.getSpeed()
    wait(0.25)
    if RULE_CONDITION:
        goto RULE_START
