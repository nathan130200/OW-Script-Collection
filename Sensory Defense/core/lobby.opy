#!disableOptimizations

settings {
    "main": {
        "description": "Repair the protective shield power generators and defeat the omnics in the blackout crisis.",
        "modeName": "Sensory Defense"
    },
    "lobby": {
        "allowPlayersInQueue": true,
        "mapRotation": "afterGame",
        "team2Slots": 0,
        "minimumLatencyInNs": 150000000,
        "returnToLobby": "afterGame",
        "swapTeamsAfterMatch": false
    },
    "gamemodes": {
        "skirmish": {
            "enabledMaps": [
                "eichenwaldeHalloween"
            ],
            "setValidControlPoints": "first"
        },
        "general": {
            "gamemodeStartTrigger": "immediately",
            "enableKillCam": false,
            "respawnTime%": 50,
            "spawnHealthPacks": "disabled"
        }
    }
}

#!extension spawnMoreDummyBots