//::///////////////////////////////////////////////
//:: DM Tool 1 Instant Feat
//:: x3_dm_tool01
//:: Copyright (c) 2007 Bioware Corp.
//:://////////////////////////////////////////////

#include "i_x3_dm_tools"

void main()
{
    object oUser = OBJECT_SELF;    
    SendMessageToPC(oUser, "DM Tool 2");
    SendMessageToPC(oUser, GetName(oUser));
}