//::///////////////////////////////////////////////
//:: DM Tool 2 Instant Feat
//:: x3_dm_tool02
//:: Copyright (c) 2007 Bioware Corp.
//:://////////////////////////////////////////////

#include "i_x3_dm_tools"

void main()
{
    object oUser = OBJECT_SELF;    

    SendMessageToPC(oUser, "VFX Manager opened");
    PopDMVFXManager(oUser);
}