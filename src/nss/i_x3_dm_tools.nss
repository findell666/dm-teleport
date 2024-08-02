#include "nw_inc_nui"
#include "nw_inc_nui_insp"
#include "x0_i0_position" 


const int LAYOUT_HORIZONTAL = 1;
const int LAYOUT_VERTICAL = 2;

const string DM_TELEPORT_MGR_WINDOW = "dm-teleport-manager";

json CreateLocationButton(string buttonName = "<empty>", int id = 0);
json BindCurrentLocationButton(object oDM, json jContainer);

// return the middle of the screen for the x position.
// oPC using the menu.
// fMenuWidth - the width of the menu to display.
float GetGUIWidthMiddle (object oPC, float fMenuWidth){
    // Get players window information.
    float fGUI_Width = IntToFloat (GetPlayerDeviceProperty (oPC, PLAYER_DEVICE_PROPERTY_GUI_WIDTH));
    float fGUI_Scale = IntToFloat (GetPlayerDeviceProperty (oPC, PLAYER_DEVICE_PROPERTY_GUI_SCALE)) / 100.0;
    fMenuWidth = fMenuWidth * fGUI_Scale;
    return (fGUI_Width / 2.0) - (fMenuWidth / 2.0);
}

// return the middle of the screen for the y position.
// oPC using the menu.
// fMenuHeight - the height of the menu to display.
float GetGUIHeightMiddle (object oPC, float fMenuHeight){
    // Get players window information.
    float fGUI_Height = IntToFloat (GetPlayerDeviceProperty (oPC, PLAYER_DEVICE_PROPERTY_GUI_HEIGHT));
    float fGUI_Scale = IntToFloat (GetPlayerDeviceProperty (oPC, PLAYER_DEVICE_PROPERTY_GUI_SCALE)) / 100.0;
    fMenuHeight = fMenuHeight * fGUI_Scale;
    return (fGUI_Height / 2.0) - (fMenuHeight / 2.0);
}

// oPC is the PC using the menu.
// jLayout is the Layout of the menu.
// sWinID is the string ID for this window.
// slabel is the label of the menu.
// fX is the X position of the menu. if (-1.0) then it will center the x postion
// fY is the Y position of the menu. if (-1.0) then it will center the y postion
// fWidth is the width of the menu.
// fHeight is the height of the menu.
// bResize - TRUE will all it to be resized.
// bCollapse - TRUE will allow the window to be collapsable.
// bClose - TRUE will allow the window to be closed.
// bTransparent - TRUE makes the menu transparent.
// bBorder - TRUE makes the menu have a border.
// To remove the Title bar set sLabel to "FALSE" and bCollapse, bClose to FALSE.
int SetWindow (object oPC, json jLayout, string sWinID, string sLabel, float fX, float fY, float fWidth, float fHeight, int bResize, int bCollapse, int bClose, int bTransparent, int bBorder){
    // Create the window binding everything.
    json jWindow;
    if (sLabel == "FALSE"){
        jWindow = NuiWindow (jLayout, JsonBool (FALSE), NuiBind ("window_geometry"),
        NuiBind ("window_resizable"), JsonBool (FALSE), JsonBool (FALSE),
        NuiBind ("window_transparent"), NuiBind ("window_border"));
    }
    else{
        jWindow = NuiWindow (jLayout, NuiBind ("window_label"), NuiBind ("window_geometry"),
        NuiBind ("window_resizable"), JsonBool (bCollapse), NuiBind ("window_closable"),
        NuiBind ("window_transparent"), NuiBind ("window_border"));
    }
    // Create the window.
    int nToken = NuiCreate (oPC, jWindow, sWinID);
    if (fX == -1.0) fX = GetGUIWidthMiddle (oPC, fWidth);
    if (fY == -1.0) fY = GetGUIHeightMiddle (oPC, fHeight);
    NuiSetBind (oPC, nToken, "window_geometry", NuiRect (fX, fY, fWidth, fHeight));
    // Set the binds for the new window.
    // Set the window options.
    if (sLabel != "FALSE"){
        NuiSetBind (oPC, nToken, "window_label", JsonString (sLabel));
        NuiSetBind (oPC, nToken, "window_closable", JsonBool (bClose));
    }
    NuiSetBind (oPC, nToken, "window_resizable", JsonBool (bResize));
    NuiSetBind (oPC, nToken, "window_transparent", JsonBool (bTransparent));
    NuiSetBind (oPC, nToken, "window_border", JsonBool (bBorder));
    return nToken;
}

string GetElement(int i){
    switch(i){
        case 0: return "FIRE";
        case 1: return "EARTH";
        case 2: return "WATER";
        case 3: return "AIR";
        case 4: return "X";
        default:return "X";
    }
    return "X";
}

json GetNUIColorWithName(string name){
    if("red" == name){
        return NuiColor(255, 76, 36, 255);
    }
    if("green" == name){
        return NuiColor(32, 222, 32, 255);
    }
    if("FIRE"== name) return NuiColor(255, 76, 36, 255);
    if("EARTH"== name) return NuiColor(32, 222, 32, 255);
    if("WATER"== name) return NuiColor(110, 255, 254, 255);
    if("AIR"== name) return NuiColor(38, 71, 255, 255);
    return JsonNull();
}

json CreateLocationButton(string buttonName = "<empty>", int id = 0){
    string sIdButton = "tp_"+IntToString(id);
    json jButton = NuiId(NuiButton(JsonString(buttonName)), sIdButton);
    jButton = NuiTooltip (jButton, JsonString(buttonName));
    // jButton = NuiStyleForegroundColor(jButton, NuiBind("button_color_"+sIdButton));
    jButton = NuiEncouraged(jButton, NuiBind("encourage_"+sIdButton));
    jButton = NuiWidth (jButton, 120.0f);
    jButton = NuiHeight (jButton, 30.0f);
    return jButton;
}

json CreateDeleteLocationButton(int id = 0){
    string sIdButton = "tp_delete_"+IntToString(id);
    json jButton = NuiId(NuiButton(JsonString("x")), sIdButton);
    jButton = NuiStyleForegroundColor(jButton, GetNUIColorWithName("red"));
    jButton = NuiTooltip (jButton, JsonString("Remove location"));
    // jButton = NuiEncouraged(jButton, NuiBind("encourage_"+sIdButton));
    jButton = NuiWidth (jButton, 30.0f);
    jButton = NuiHeight (jButton, 30.0f);
    return jButton;
}

json JsonVector(vector vec){
    json jObject = JsonObject();
    jObject = JsonObjectSet(jObject, "x", JsonFloat(vec.x));
    jObject = JsonObjectSet(jObject, "y", JsonFloat(vec.y));
    jObject = JsonObjectSet(jObject, "z", JsonFloat(vec.z));
    return jObject;
}

vector JsonGetVector(json jVector){
    float x = JsonGetFloat(JsonObjectGet(jVector, "x"));
    float y = JsonGetFloat(JsonObjectGet(jVector, "y"));
    float z = JsonGetFloat(JsonObjectGet(jVector, "z"));
    return Vector(x, y, z);
}

//add current location to json array
void AddDMLocation(object oDM){
    json jLocations = GetLocalJson(oDM, "dm_tp_mgr_locations");
    if(jLocations == JsonNull()){
        jLocations = JsonArray();
    }
    object area = GetArea(oDM);
    string name = GetName(area);
    json jObject = JsonObject();
    location loc = GetLocation(oDM);
    string areaTag = GetTag(area);
    vector position = GetPositionFromLocation(loc);
    float facing = GetFacingFromLocation(loc);

    jObject = JsonObjectSet(jObject, "areaTag", JsonString(areaTag));
    jObject = JsonObjectSet(jObject, "name", JsonString(name));
    jObject = JsonObjectSet(jObject, "position", JsonVector(position));
    jObject = JsonObjectSet(jObject, "facing", JsonFloat(facing));

    jLocations = JsonArrayInsert(jLocations, jObject);
    SetLocalJson(oDM, "dm_tp_mgr_locations", jLocations);
}

void DeleteDMLocation(object oDM, int nLocationIndex){
    json jLocations = GetLocalJson(oDM, "dm_tp_mgr_locations");
    jLocations = JsonArrayDel(jLocations, nLocationIndex);
    SetLocalJson(oDM, "dm_tp_mgr_locations", jLocations);
}

void GoToDMLocation(object oDM, int nLocationIndex){
    json jLocations = GetLocalJson(oDM, "dm_tp_mgr_locations");
    json jObject = JsonArrayGet(jLocations, nLocationIndex);
    string areaTag = JsonGetString(JsonObjectGet(jObject, "areaTag"));
    vector position = JsonGetVector(JsonObjectGet(jObject, "position"));
    float facing = JsonGetFloat(JsonObjectGet(jObject, "facing"));
    object area = GetObjectByTag(areaTag);
    if(area == OBJECT_INVALID){
        SendMessageToPC(oDM, "Area not found");
        return;
    }
    location loc = Location(area, position, facing);
    AssignCommand(oDM, ClearAllActions());
    AssignCommand(oDM, ActionJumpToLocation(loc));
}

void RefreshContainer(object oDM, int nToken){
    json jLocations = GetLocalJson(oDM, "dm_tp_mgr_locations");
    json jCol = JsonArray();
    int i =0;
    for(i = 0; i < JsonGetLength(jLocations); i++){
        json jLine = JsonArray();
        json jObject = JsonArrayGet(jLocations, i);
        string name = JsonGetString(JsonObjectGet(jObject, "name"));
        json tpButton = CreateLocationButton(name, i);
        jLine = JsonArrayInsert(jLine, tpButton);
        jLine = JsonArrayInsert(jLine, CreateDeleteLocationButton(i));
        jLine = NuiRow(jLine);
        jCol = JsonArrayInsert(jCol, jLine);
    }
    jCol = NuiCol(jCol);
    NuiSetGroupLayout(oDM, nToken, "dm_tp_mgr_container", jCol);
}

void PopDMTeleportManager(object oDM){
    float fWidth = 210.0f;
    float fHeight = 400.0f;
    
    // --- header
    json jHeader = JsonArray();

    json jButtonAddLocation = NuiId(NuiButton (JsonString("+")), "dm_tp_mgr_bind_current");
    jButtonAddLocation = NuiTooltip (jButtonAddLocation, JsonString("Bind current location"));
    jButtonAddLocation = NuiWidth(jButtonAddLocation, 120.0f);
    jButtonAddLocation = NuiHeight(jButtonAddLocation, 30.0f);
    jHeader = JsonArrayInsert(jHeader, jButtonAddLocation);

    json jButtonInfo = NuiId(NuiButton (JsonString("?")), "dm_teleport_mgr_info");
    jButtonInfo = NuiTooltip (jButtonInfo, JsonString("Help"));
    jButtonInfo = NuiWidth(jButtonInfo, 25.0f);
    jButtonInfo = NuiHeight(jButtonInfo, 25.0f);

    jHeader = JsonArrayInsert(jHeader, jButtonInfo);

    // --- container
    json jContainer = JsonArray();
    // jContainer = BindCurrentLocationButton(oDM, jContainer);

    // --- footer
    json jFooter = JsonArray();
    json jButtonBack = NuiId(NuiButton (JsonString("Prev location")), "dm_tp_mgr_back");
    jButtonBack = NuiTooltip (jButtonBack, JsonString("Go back to previous location"));
    jButtonBack = NuiWidth(jButtonBack, 120.0f);
    jButtonBack = NuiHeight(jButtonBack, 30.0f);
    jFooter = JsonArrayInsert(jFooter, jButtonBack);

    // make NuiRows ---
    jHeader = NuiRow(jHeader);
    jContainer = NuiRow(jContainer);
    jContainer = NuiGroup(jContainer, TRUE, NUI_SCROLLBARS_Y);
    jContainer = NuiWidth(jContainer, 190.0f);
    jContainer = NuiId(jContainer, "dm_tp_mgr_container");
    jFooter = NuiRow(jFooter);
    

    json jColGlobal = JsonArray();
    jColGlobal = JsonArrayInsert(jColGlobal, jHeader);
    jColGlobal = JsonArrayInsert(jColGlobal, jContainer);
    jColGlobal = JsonArrayInsert(jColGlobal, jFooter);
    json jLayoutGlobal = NuiCol (jColGlobal);
    int nToken = SetWindow(oDM, jLayoutGlobal, DM_TELEPORT_MGR_WINDOW, "DM Teleport Manager", -1.0f, -1.0f, fWidth, fHeight, TRUE, TRUE, TRUE, TRUE, TRUE);
    RefreshContainer(oDM, nToken);
}