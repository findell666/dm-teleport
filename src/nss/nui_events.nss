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

        if(sEvent == "open"){
            SetLocalInt(oPlayer, "nToken", nToken);
        }
        
        if (sEvent != "mouseup"){
            return;
        }
        if (sElement == "dm_tp_mgr_bind_current"){
            SendMessageToPC(oPlayer, "Add current location");

            if(GetDMLocationCount(oPlayer) >= MAX_NB_LOCATIONS){
                SendMessageToPC(oPlayer, "You have reached the maximum number of locations (" + IntToString(MAX_NB_LOCATIONS)+")");
                return;
            }

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
            GoToDMLocation(oPlayer, nLocationIndex, nToken);
            ResetEncourageBinds(oPlayer, nToken);
            NuiSetBind(oPlayer, nToken, "encourage_tp_"+sLocationIndex, JsonBool(TRUE));
        }
        else if (sElement == "dm_tp_mgr_back"){
            GoBackToPreviousLocation(oPlayer, nToken);
            SendMessageToPC(oPlayer, "Go back to previous location");
        }
        else if (sElement == "dm_teleport_mgr_info"){
            SendMessageToPC(oPlayer, "Help");
        }
    }

    if (sWindowId == DM_PLACEABLE_MGR_WINDOW){

        if (sEvent != "mouseup"){
            return;
        }

        if(GetStringLeft(sElement, 10) == "pl_delete_"){
            string sPlaceableIndex = GetSubString(sElement, 10, GetStringLength(sElement) - 1);
            int nPlaceableIndex = StringToInt(sPlaceableIndex);
            DeletePlaceable(oPlayer, nPlaceableIndex);
            DelayCommand(1.0f, RefreshPlaceableContainer(oPlayer, nToken));
        }
        else if(GetStringLeft(sElement, 3) == "pl_"){
            string sPlaceableIndex = GetSubString(sElement, 3, GetStringLength(sElement) - 1);
            int nPlaceableIndex = StringToInt(sPlaceableIndex);
            GoToPlaceable(oPlayer, nPlaceableIndex, nToken);
        }

    }
}