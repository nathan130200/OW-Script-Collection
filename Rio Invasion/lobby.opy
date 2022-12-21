#!mainFile "main.opy"

settings {
    "main": {
        "modeName": "RIO'S INVASION",
        "description": "CODE: N0GWN\n\nNull sector, junker queen and your allies have taken lúcio base in Rio de Janeiro and have plans to build an illegal robot factory. Your team MUST infiltrate and clear the area.\n\n== CONFIG ==\nTEAM 1: ONLY BOTS\nTEAM 2: ONLY PLAYERS\n\n== REQUIRED BOTS ==\nJunker Queen (slot 1)\nJunkrat (slot 2)\nOrisa (slot 3)\nRoadhog (slot 4)\nBastion (slot 5)\n\nBOT SKILL LEVEL:\nLETHAL OR HIGER\n\n* Slots must follow order",
    },
    "lobby": {
        "allowPlayersInQueue": true,
        "mapRotation": "afterGame",
        "spectatorSlots": 5,
        "team1Slots": 5,
        "team2Slots": 5,
        "returnToLobby": "never",
        "swapTeamsAfterMatch": false
    },
    "gamemodes": {
        "hybrid": {
            "enabledMaps": {
                "paraiso": 0
            }
        },
        "general": {
            "captureSpeed%": 65,
            "gamemodeStartTrigger": "allSlotsFilled",
            "heroLimit": "off",
            "enableKillCam": false,
            "enableKillFeed": false,
            "payloadSpeed%": 65,
            "respawnTime%": 75,
            "spawnHealthPacks": "disabled"
        }
    },
    "heroes": {
        "allTeams": {
            "pharah": {
                "enableSecondaryFireUnlimitedFuel": true
            },
            "general": {
                "abilityCooldown%": 80
            }
        },
        "team2": {
            "general": {
                "abilityCooldown%": 75
            }
        }
    }
}