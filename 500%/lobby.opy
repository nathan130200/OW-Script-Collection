#!define MODE_DESC "CODE: H8RQ7\n\nEnjoy this funny combat in a tiny areas.\n\nHold 'INTERACT + CROUCH' to teleport behind walls & escape from enemy spam"

settings {
    "main": {
        "description": MODE_DESC,
        "modeName": "500%+"
    },
    "lobby": {
        "mapRotation": "afterGame",
        "returnToLobby": "never",
        "swapTeamsAfterMatch": false,
        "allowPlayersInQueue": true
    },
    "gamemodes": {
        "skirmish": {
            "enabledMaps": [
                "hollywood",
                #"watchpointGibraltar",
                #"dorado",
                #"kingsRowWinter",
                #"hanamuraWinter"
            ]
        },
        "general": {
            "enableHeroSwitching": false,
            "enableEnemyHealthBars": false,
            "gamemodeStartTrigger": "immediately",
            "heroLimit": "off",
            "enableKillCam": false,
            "enableKillFeed": false,
            "setValidControlPoints": "first",
            "enableRandomHeroes": true,
            "respawnTime%": 15
        }
    },
    "heroes": {
        "allTeams": {
            "ana": {
                "ability1Cooldown%": 14
            },
            "brigitte": {
                "shieldBashCooldown%": 9,
                "shieldBashKb%": 125
            },
            "baptiste": {
                "ability1Cooldown%": 5,
                "ability2Cooldown%": 8
            },
            "roadhog": {
                "ability1Cooldown%": 20,
                "ability2Cooldown%": 10
            },
            "mccree": {
                "ability1Cooldown%": 16
            },
            "moira": {
                "ability2Cooldown%": 15
            },
            "reaper": {
                "ability1Cooldown%": 16
            },
            "sombra": {
                "secondaryFireCooldown%": 18
            },
            "doomfist": {
                "enableInfiniteUlt": true,
            },
            "zarya": {
                "ability1Cooldown%": 15,
                "ability2Cooldown%": 10,
                "ultGen%": 250
            },
            "general": {
                "abilityCooldown%": 8,
                "enableInfiniteAmmo": true,
                "ultDuration%": 150,
                "ultGen%": 450,
                "combatUltGen%": 450,
                "passiveUltGen%": 350,
            }
        }
    },
    "workshop": {
        "Spawn Area": 1,
        "Total Match Time (Seconds)": 1800
    }
}