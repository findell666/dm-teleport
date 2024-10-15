#include "i_x3_dm_tools"
#include "x0_i0_position" 

void main()
{

    object oTarget = GetTargetingModeSelectedObject();
 
    object oOwner = GetLastPlayerToSelectTarget();

    if(TARGET_MODE_VFX_APPLY == GetLocalInt(oOwner, "TARGET_MODE_ID")){
        int nToken = GetLocalInt(oOwner, NUI_DM_VFX_MGR_TOKEN);
        vector vVector = GetTargetingModeSelectedPosition();
        location loc = Location(GetArea(oOwner), vVector, 0.0f);

        RunSelectedEffects(oOwner, nToken, loc);
    }
}
