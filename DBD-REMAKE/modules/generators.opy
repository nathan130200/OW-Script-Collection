#!mainFile "../main.opy"

globalvar generatorsConfig
globalvar generatorPositions
globalvar generatorStates
playervar playerState

enum PlayerState:
    IDLE,
    REPAIRING_GENERATOR,
    KNOCK_DOWN

#!define numOfGenerators generatorsConfig[0]
#!define generatorProgressScale generatorsConfig[1]
#!define generatorQuickTimeEventInterval generatorsConfig[2]

rule "[generators] init config":
    @Event eachPlayer
    generatorStates = []
    generatorsConfig = [
        cfgInt("Number of generators required to repair", CfgSection.GENERATOR, 3, 6, 3),
        cfgFloat("Time scale while repair generators", CfgSection.GENERATOR, 0.5, 3.0, 1.5),
        cfgFloat("Quick time event interval while repair generators", CfgSection.GENERATOR, 5.0, 60.0, 15.0),
    ]

globalvar arrayIterator

rule "make players impulse":
    @Event global
    
    forEach('getAllPlayers()', 'arrayIterator[0]', 'who')
        loopBody_who.applyImpulse(Vector.UP, 0.5, Relativity.TO_PLAYER, Impulse.CANCEL_CONTRARY_MOTION_XYZ)

        forEach('getAllPlayers()', 'arrayIterator[1]', 'subWho')
            playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.ORANGE, loopBody_subWho.getPosition(), 5)

        forEach('getAllPlayers()', 'arrayIterator[2]', 'subWho1')
            playEffect(getAllPlayers(), DynamicEffect.RING_EXPLOSION, Color.ORANGE, loopBody_subWho1.getPosition(), 5)

    wait(0.25)
    goto RULE_START