// _______________________________________
// ## DM Jump Events
// - NWNX_ON_DM_JUMP_TO_POINT_BEFORE
// - NWNX_ON_DM_JUMP_TO_POINT_AFTER
// - NWNX_ON_DM_JUMP_TARGET_TO_POINT_BEFORE
// - NWNX_ON_DM_JUMP_TARGET_TO_POINT_AFTER
// - NWNX_ON_DM_JUMP_ALL_PLAYERS_TO_POINT_BEFORE
// - NWNX_ON_DM_JUMP_ALL_PLAYERS_TO_POINT_AFTER

// `OBJECT_SELF` = The DM

// Event Data Tag        | Type   | Notes |
// ----------------------|--------|-------|
// TARGET_AREA           | object | Convert to object with StringToObject() |
// POS_X                 | float  | |
// POS_Y                 | float  | |
// POS_Z                 | float  | |
// NUM_TARGETS           | int    | Only valid for NWNX_ON_DM_JUMP_TARGET_TO_POINT_* |
// TARGET_*              | object | * = 1 <= NUM_TARGETS, Only valid for NWNX_ON_DM_JUMP_TARGET_TO_POINT_* |

#include "i_x3_dm_tools"

void main(){
    int nToken = GetLocalInt(OBJECT_SELF, "nToken");
    SaveGoBackLocation(OBJECT_SELF, nToken, GetLocation(OBJECT_SELF));
}

