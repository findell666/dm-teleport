//::///////////////////////////////////////////////
//:: DM Tool 2 Instant Feat
//:: x3_dm_tool02
//:: Copyright (c) 2007 Bioware Corp.
//:://////////////////////////////////////////////

#include "i_x3_dm_tools"

void main()
{
    object oUser = OBJECT_SELF;    
    object oTarget = GetSpellTargetObject();

    // if(GetIsPC(oTarget) && !GetIsDM(oTarget)){
        SendMessageToPC(oUser, "DM Player Quest manager opened for " + GetName(oTarget));
        PopDMQuestManager(oUser, oUser);
    // }
}