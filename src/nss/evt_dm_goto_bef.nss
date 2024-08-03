// _______________________________________
// ## DM Single Object Action Events
// - NWNX_ON_DM_GOTO_BEFORE
// - NWNX_ON_DM_GOTO_AFTER
// - NWNX_ON_DM_POSSESS_BEFORE
// - NWNX_ON_DM_POSSESS_AFTER
// - NWNX_ON_DM_POSSESS_FULL_POWER_BEFORE
// - NWNX_ON_DM_POSSESS_FULL_POWER_AFTER
// - NWNX_ON_DM_TOGGLE_LOCK_BEFORE
// - NWNX_ON_DM_TOGGLE_LOCK_AFTER
// - NWNX_ON_DM_DISABLE_TRAP_BEFORE
// - NWNX_ON_DM_DISABLE_TRAP_AFTER

// `OBJECT_SELF` = The DM

// Event Data Tag        | Type   | Notes
// ----------------------|--------|-------
// TARGET                | object | Convert to object with StringToObject()

// @note If `TARGET` is `OBJECT_INVALID` for `NWNX_ON_DM_POSSESS_*`, the DM is unpossessing.

#include "i_x3_dm_tools"

void main(){
    int nToken = GetLocalInt(OBJECT_SELF, "nToken");
    SaveGoBackLocation(OBJECT_SELF, nToken, GetLocation(OBJECT_SELF));
}