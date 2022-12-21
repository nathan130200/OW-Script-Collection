rule "teams: push score (earn elimination)":
    @Event playerEarnedElimination
    scoreData[ScoreKey.PointsTeam1 if victim.getTeam() == Team.2 else ScoreKey.PointsTeam2] += 1
    playRandVoiceline()

rule "teams: push score (final blow)":
    @Event playerDealtFinalBlow
    scoreData[ScoreKey.PointsTeam1 if victim.getTeam() == Team.1 else ScoreKey.PointsTeam2] -= 1

#!define updateHiScore(key1, key2) if scoreData[key1] > scoreData[key2]:\
    scoreData[key2] = scoreData[key1]

#!define updateDiffScore(key1, key2, key3) scoreData[key1] = scoreData[key2] - scoreData[key3]

rule "update score":
    @Event global

    updateHiScore(ScoreKey.PointsTeam1, ScoreKey.PointsHiTeam1)
    updateHiScore(ScoreKey.PointsTeam2, ScoreKey.PointsHiTeam2)

    wait(1)
    goto RULE_START