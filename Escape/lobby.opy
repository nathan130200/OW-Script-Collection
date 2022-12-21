#!disableOptimizations
#!mainFile "main.opy"

settings {
    "lobby": {
        "allowPlayersInQueue": true,
        "mapRotation": "afterGame",
        "team1Slots": 8,
        "team2Slots": 1,
        "returnToLobby": "never",
        "swapTeamsAfterMatch": false
    },
    "gamemodes": {
        "skirmish": {
            "enabledMaps": [
                "workshopIsland"
            ],
            "setValidControlPoints": "first"
        },
        "general": {
            "enableHeroSwitching": false,
            "enableEnemyHealthBars": false,
            "gamemodeStartTrigger": "immediately",
            "heroLimit": "off",
            "enableRandomHeroes": true,
            "respawnTime%": 50,
            "spawnHealthPacks": "disabled"
        }
    },
    "heroes": {
        "allTeams": {
            "general": {
                "abilityCooldown%": 80,
                "jumpVerticalSpeed%": 115,
                "movementSpeed%": 115
            }
        }
    }
}

