#include "i_x3_dm_tools"
#include "x0_i0_position" 

void main()
{

    object oTarget = GetTargetingModeSelectedObject();
 
    object oOwner = GetLastPlayerToSelectTarget();


    WriteTimestampedLogEntry("Target script called");
    WriteTimestampedLogEntry(GetName(oTarget) + " " + GetName(oOwner));

    WriteTimestampedLogEntry(IntToString(GetLocalInt(oOwner, "TARGET_MODE_ID")));

    if(TARGET_MODE_VFX_APPLY == GetLocalInt(oOwner, "TARGET_MODE_ID")){

        int nToken = GetLocalInt(oOwner, NUI_DM_VFX_MGR_TOKEN);

        WriteTimestampedLogEntry("oOwner " + GetName(oOwner));
        WriteTimestampedLogEntry("Ntoekn " + IntToString(nToken));

        vector vVector = GetTargetingModeSelectedPosition();

        location loc = Location(GetArea(oOwner), vVector, 0.0f);

        WriteTimestampedLogEntry("icici " + LocationToString(loc));
        RunSelectedEffects(oOwner, nToken, loc);
    }
}
