rule "debug: init info hud":
    @Event global
    @Disabled
    @Delimiter
    hudSubtext(localPlayer, "Current Hero: {} ({})".format(hudHero(localPlayer)), HudPosition.LEFT, -12, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
    hudSubtext(localPlayer, "Position: {}".format(localPlayer.getPosition()), HudPosition.LEFT, -11, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
    hudSubtext(localPlayer, "Facing: {}".format(localPlayer.getFacingDirection()), HudPosition.LEFT, -10, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
    hudSubtext(localPlayer, "Throttle: {}".format(localPlayer.getThrottle()), HudPosition.LEFT, -9, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
    hudSubtext(localPlayer, "Velocity: {}".format(localPlayer.getVelocity()), HudPosition.LEFT, -8, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
    hudSubtext(localPlayer, "Speed: {} m/s".format(localPlayer.getSpeed()), HudPosition.LEFT, -7, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
    hudSubtext(localPlayer, "Normalized Health: {}%".format(localPlayer.getNormalizedHealth() * 100), HudPosition.LEFT, -6, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
    hudSubtext(localPlayer, "Health / Max Health: {} of {}".format(localPlayer.getHealth(), localPlayer.getMaxHealth()), HudPosition.LEFT, -5, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)
    hudSubtext(localPlayer, "Ult Charge: {}%".format(localPlayer.getUltCharge()), HudPosition.LEFT, -4, Color.WHITE, HudReeval.VISIBILITY_AND_STRING, SpecVisibility.NEVER)

rule "init: mode hud":
    clockData[0] = createWorkshopSetting(int[60:3600], "Game", "Total Match Time (Seconds)", 1500, 0)
    mapVariant = createWorkshopSetting(int[1:2], "Game", "Spawn Area", 0, 0) - 1

    hudSubtext(getAllPlayers(), "Match Time: {}h {}m {}s".format(clock_Hour, clock_Minutes, clock_Seconds), HudPosition.RIGHT, -500, rgb(255, 204, 102), HudReeval.VISIBILITY_SORT_ORDER_AND_STRING, SpecVisibility.ALWAYS)
    hudSubheader(localPlayer, "TIP: Hold 'CROUCH + INTERACT' TO START TELEPORTING BEHIND WALLS\n", HudPosition.RIGHT, -499, Color.WHITE, HudReeval.VISIBILITY_SORT_ORDER_AND_STRING, SpecVisibility.ALWAYS)

    hudIndex = -400

    hudSubtext(localPlayer if localPlayer.isInWalls else null, "{} TELEPORTING BEHIND WALLS".format(is(Icon.EXCLAMATION_MARK)), HudPosition.TOP, hidx, Color.YELLOW, HudReeval.VISIBILITY, SpecVisibility.NEVER)
    hudIndex--

    hudSubtext(localPlayer if localPlayer.isInWalls else null, "{} HOLD 'INTERACT' TO KEEP TELEPORTING".format(is(Icon.RECYCLE)), HudPosition.TOP, hidx, Color.GREEN, HudReeval.VISIBILITY, SpecVisibility.NEVER)
    hudIndex--
    
    hudSubtext(localPlayer if localPlayer.isInWalls else null, "{} HOLD 'JUMP' TO CANCEL TELEPORTING".format(is(Icon.SKULL)), HudPosition.TOP, hidx, Color.RED, HudReeval.VISIBILITY, SpecVisibility.NEVER)
    hudIndex--
    
    progressBarHud(localPlayer if localPlayer.isInWalls or localPlayer.isInWallsTime != 100 else null, localPlayer.isInWallsTime, null, HudPosition.TOP, 0, Color.PURPLE, null, ProgressHudReeval.VISIBILITY_AND_VALUES, SpecVisibility.NEVER)
    hudIndex--

    hudSubtext(localPlayer if not localPlayer.isInWalls and localPlayer.isInWallsTime != 100 else null, "\u200b\n\n\n\n{} TELEPORT BEHIND WALLS CHARGE".format(is(Icon.BOLT)), HudPosition.TOP, -5, rgb(102, 255, 204), HudReeval.VISIBILITY, SpecVisibility.NEVER)
    hudIndex--

    scoreHud("- SCORES: ", title_text)
    scoreHud("Team 1: {}".format(sd(ScoreKey.PointsTeam1)), team1_color)
    scoreHud("Team 2: {}".format(sd(ScoreKey.PointsTeam2)), team2_color)
    scoreHud("\u200b\n- HIGH SCORE:", title_text)
    scoreHud("Team 1: {}".format(sd(ScoreKey.PointsHiTeam1)), team1_color)
    scoreHud("Team 2: {}".format(sd(ScoreKey.PointsHiTeam2)), team2_color)
    scoreHud("\u200b\n- SCORE DIFFERENCE:", title_text)
    scoreHud((sd(ScoreKey.PointsTeam1) - sd(ScoreKey.PointsTeam2)), rgb(51, 102, 204))

    statHudNew(StatKey.DAMAGE, "{}  TOTAL DAMAGE DONE: {}", rgb(204, 51, 0), is(Icon.SKULL), getFormatted_DAMAGE)
    statHudNew(StatKey.HEAL, "{}  TOTAL HEALING DONE: {}", rgb(255, 153, 0), is(Icon.HEART), getFormatted_HEALING)
    statHud(StatKey.ABILITY_USE, "{}  ABILITIES USED: {}", rgb(51, 204, 51), is(Icon.POISON_2))
    statHud(StatKey.ULT_USE, "{}  ULTIMATES USED: {}", rgb(102, 255, 217), is(Icon.BOLT))
    statHud(StatKey.DISTANCE_WALKED, "{}  DISTANCE MOVED: {} M", rgb(102, 102, 255), is(Icon.RECYCLE))