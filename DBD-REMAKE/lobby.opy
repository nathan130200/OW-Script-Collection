#!mainFile "main.opy"
#!disableOptimizations

settings {
    "main": {
        "modeName": "DEAD BY DAYLIGHT (REMAKE)"
    },
    "lobby": {
        "mapRotation": "afterGame",
        "team1Slots": 5,
        "team2Slots": 1,
        "returnToLobby": "afterGame"
    },
    "gamemodes": {
        "skirmish": {
            "enabledMaps": [
                "paris"
            ],
            "setValidControlPoints": "first"
        },
        "general": {
            "gamemodeStartTrigger": "immediately",
            "respawnTime%": 50,
            "spawnHealthPacks": "disabled"
        }
    },
    "heroes": {
        "allTeams": {
            "general": {
                "abilityCooldown%": 75,
                "ammoClipSize%": 125,
                "health%": 125,
                "jumpVerticalSpeed%": 115,
                "movementSpeed%": 115
            }
        }
    }
}

#Activated extensions

#!extension beamEffects
#!extension beamSounds
#!extension buffStatusEffects
#!extension debuffStatusEffects
#!extension buffAndDebuffSounds
#!extension energyExplosionEffects
#!extension kineticExplosionEffects
#!extension explosionSounds
#!extension playMoreEffects
#!extension spawnMoreDummyBots