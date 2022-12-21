globalvar hudIndex
globalvar spawnData
globalvar statsData
globalvar clockData
globalvar scoreData
globalvar mapVariant

subroutine playRandVoiceline

playervar isInWalls
playervar wallStartPos
playervar isInWallsTime
playervar randVoiceLine

enum ScoreKey:
    PointsTeam1,
    PointsTeam2,
    PointsHiTeam1,
    PointsHiTeam2,

enum StatKey:
    DAMAGE,
    HEAL,
    ABILITY_USE,
    ULT_USE,
    DISTANCE_WALKED,

#!define hudHero(p) heroIcon(p.getCurrentHero()), p.getCurrentHero()
#!define scaleTime(t) "0{}".format(t) if t <= 9 else "{}".format(t)
#!define clock_Hour scaleTime(clockData[1])
#!define clock_Minutes scaleTime(clockData[2])
#!define clock_Seconds scaleTime(clockData[3])
#!define TELEPORT_MIN_CHARGE 1

#!define is(k) iconString(k)
#!define sd(k) scoreData[k]
#!define td(k) statsData[k]
#!define title_text rgb(230, 230, 230)
#!define team1_color rgb(153, 153, 255)
#!define team2_color rgb(255, 153, 204)
#!define generateStatsHelper(keys) __script__("ext/statHelper.js")

#!define scoreHud(text, color) hudSubtext(getAllPlayers(), text, HudPosition.LEFT, hidx,\
    color, HudReeval.VISIBILITY_SORT_ORDER_AND_STRING, SpecVisibility.DEFAULT)\
    hudIndex += 1

#!define statHud(key, fmt, color, icon) hudSubtext(getAllPlayers(), fmt.format(icon, statsData[key]), HudPosition.RIGHT, hidx, \
    color, HudReeval.VISIBILITY_SORT_ORDER_AND_STRING, SpecVisibility.DEFAULT)\
    hudIndex += 1

#!define statHudNew(key, fmt, color, icon, val) hudSubtext(getAllPlayers(), fmt.format(icon, val), HudPosition.RIGHT, hidx, \
    color, HudReeval.VISIBILITY_SORT_ORDER_AND_STRING, SpecVisibility.DEFAULT)\
    hudIndex += 1

#!define hidx evalOnce(hudIndex)

generateStatsHelper([
    { name: 'DAMAGE', type: 'StatKey.DAMAGE' },
    { name: 'HEALING', type: 'StatKey.HEAL' }
])