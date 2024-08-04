#include "nwnx_events"

void main()
{

    NWNX_Events_SubscribeEvent("NWNX_ON_DM_GOTO_BEFORE", "evt_dm_goto_bef");
    NWNX_Events_SubscribeEvent("NWNX_ON_DM_JUMP_TO_POINT_BEFORE", "evt_dm_jump_bef");

    


    SetEventScript(GetModule(), EVENT_SCRIPT_MODULE_ON_NUI_EVENT, "nui_events");

    SetTlkOverride(111674, "DM Teleport tool");
    SetTlkOverride(111675, "DM Placeable Mgr tool");
    SetTlkOverride(111676, "DM Player Quest Mgr tool");
}
