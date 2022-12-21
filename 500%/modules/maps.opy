rule "init map: hollywood":
    @Condition getCurrentMap() in Map.HOLLYWOOD
    @Delimiter
    spawnData[0] = vect(-53.316, 5.399, -149.526)
    spawnData[1] = vect(-13.052, 5.313, -147.603)

rule "init map: watchpoint gibraltar":
    @Condition getCurrentMap() == Map.WATCHPOINT_GIBRALTAR

    if mapVariant == 0:
        spawnData[0] = vect(49.614, -1.591, -13.443)
        spawnData[1] = vect(35.69, 4.396, -23.396)
    else:
        spawnData[0] = vect(-5.273, -0.901, -100.072)
        spawnData[1] = vect(-3.312, -3.329, -75.935)

rule "init map: king's row":
    @Condition getCurrentMap() in [Map.KINGS_ROW, Map.KINGS_ROW_WINTER]
    if mapVariant == 0:
        spawnData[0] = vect(0.245, 2.009, -56.728)
        spawnData[1] = vect(2.608, 1.229, -38.564)
    else:
        spawnData[0] = vect(-65.379, 2.701, 0.856)
        spawnData[1] = vect(-54.593, 5.703, -10.825)

rule "init map: hannamura":
    @Condition getCurrentMap() in [Map.HANAMURA, Map.HANAMURA_WINTER]
    spawnData[0] = vect(13.93, 1.056, 12.481)
    spawnData[1] = vect(-13.813, 0.301, 12.834)

rule "init map: dorado":
    @Condition getCurrentMap() == Map.DORADO
    spawnData[0] = vect(51.347, 8.396, -39.388)
    spawnData[1] = vect(67.047, 9.832, -52.912)