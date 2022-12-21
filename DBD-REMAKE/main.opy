#!include "lobby.opy"

enum CfgSection:
    GENERATOR = "Generator"

#!define cfgInt(name, section, min, max, def) createWorkshopSetting(int[min:max], section, name, def, 0)
#!define cfgFloat(name, section, min, max, def) createWorkshopSetting(float[min:max], section, name, def, 0)
#!define cfgBool(name, section, def) createWorkshopSetting(bool, section, name, def, 0)
#!define cfgHero(name, section, def) createWorkshopSetting(Hero, section, name, def, 0)
#!define cfgEnum(name, section, values, def) createWorkshopSetting(enum[values], section, name, def, 0)
#!define forEach(array, variable, key) __script__("forEach.js")

#!include "modules/quick_time_event.opy"
#!include "modules/generators.opy"