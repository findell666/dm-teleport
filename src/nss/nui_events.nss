#include "i_x3_dm_tools"


void ResetEncourageBinds(object oPC, int nToken){
    int i =0;
    for(i=0; i< 100; i++){
        NuiSetBind (oPC, nToken, "encourage_tp_"+IntToString(i), JsonBool(FALSE));
    }
}

void main() {
    
    object oPlayer   = NuiGetEventPlayer();
    int nToken       = NuiGetEventWindow();
    string sEvent    = NuiGetEventType();
    string sElement  = NuiGetEventElement();
    int nIndex       = NuiGetEventArrayIndex();
    string sWindowId = NuiGetWindowId(oPlayer, nToken);

    if (sWindowId == DM_TELEPORT_MGR_WINDOW){
        if (sEvent != "mouseup"){
            return;
        }
        if (sElement == "dm_tp_mgr_bind_current"){
            SendMessageToPC(oPlayer, "Bind current location");
            AddDMLocation(oPlayer);
            RefreshContainer(oPlayer, nToken);
        }
        else if(GetStringLeft(sElement, 10) == "tp_delete_"){
            string sLocationIndex = GetSubString(sElement, 10, GetStringLength(sElement) - 1);
            int nLocationIndex = StringToInt(sLocationIndex);
            DeleteDMLocation(oPlayer, nLocationIndex);
            RefreshContainer(oPlayer, nToken);
        }
        else if(GetStringLeft(sElement, 3) == "tp_"){
            string sLocationIndex = GetSubString(sElement, 3, GetStringLength(sElement) - 1);
            int nLocationIndex = StringToInt(sLocationIndex);
            GoToDMLocation(oPlayer, nLocationIndex);
            ResetEncourageBinds(oPlayer, nToken);
            NuiSetBind(oPlayer, nToken, "encourage_tp_"+sLocationIndex, JsonBool(TRUE));
        }
        else if (sElement == "dm_tp_mgr_back"){
            SendMessageToPC(oPlayer, "Go back to previous location");
        }
        else if (sElement == "dm_teleport_mgr_info"){
            SendMessageToPC(oPlayer, "Help");
        }
    }
}