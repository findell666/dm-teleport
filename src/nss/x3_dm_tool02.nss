//::///////////////////////////////////////////////
//:: DM Tool 1 Instant Feat
//:: x3_dm_tool01
//:: Copyright (c) 2007 Bioware Corp.
//:://////////////////////////////////////////////

#include "i_x3_dm_tools"

void main()
{
    object oUser = OBJECT_SELF;    

    if(GetIsDM(oUser)){
        SendMessageToPC(oUser, "DM Teleport manager opened");
        PopDMPlaceableManager(oUser);
    }
}