#!mainFile "main.opy"

settings {
    "main": {
        "description": "Fight with an angry reinhardt team\n\nFor updates use this code: MWMK7",
        "modeName": "ANGRY REINHARDT"
    },
    "lobby": {
        "team1Slots": 8,
        "team2Slots": 1,
        "returnToLobby": "never",
        "mapRotation": "afterGame",
        "allowPlayersInQueue": true,
        "teamBalancing": "off",
        "swapTeamsAfterMatch": false,
        "spectatorSlots": 8
    },
    "gamemodes": {
       /*"skirmish": {
            "enabledMaps": [
                #"dorado",
                #"eichenwaldeHalloween",
                #"hanamuraWinter",
                #"havana",
                #"hollywoodHalloween",
                #"ilios",
                #"junkertown",
                #"kingsRowWinter",
                #"lijiangTowerLny",
                #"nepal",
                "paris",
                #"oasis",
                #"rialto",
                #"route66",
            ]
       },*/
       "assault": {
            "enabledMaps": [
                "paris"
            ],
            "captureSpeed%": 30
       },
        "general": {
            "enableHeroSwitching": false,
            "gamemodeStartTrigger": "immediately",
            "heroLimit": "off",
            "enableKillCam": false,
            "enableRandomHeroes": true,
            "spawnHealthPacks": "disabled"
        }
    }
}