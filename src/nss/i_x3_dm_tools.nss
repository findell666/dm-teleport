#include "nw_inc_nui"
#include "nw_inc_nui_insp"
#include "x0_i0_position" 
#include "nui_windows"


const int MAX_NB_LOCATIONS = 20;

const string DM_TELEPORT_MGR_WINDOW = "dm-teleport-manager";
const string DM_PLACEABLE_MGR_WINDOW = "dm-placeable-manager";

json CreateLocationButton(string buttonName = "<empty>", int id = 0);
json BindCurrentLocationButton(object oDM, json jContainer);

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

int GetDMLocationCount(object oDM){
    json jLocations = GetLocalJson(oDM, "dm_tp_mgr_locations");
    if(jLocations == JsonNull()){
        return 0;
    }
    return JsonGetLength(jLocations);
}

//add current location to json array
void AddDMLocation(object oDM){
    json jLocations = GetLocalJson(oDM, "dm_tp_mgr_locations");
    if(jLocations == JsonNull()){
        jLocations = JsonArray();
    }
    object oArea = GetArea(oDM);
    string name = GetName(oArea);
    json jObject = JsonObject();
    location loc = GetLocation(oDM);
    string areaTag = GetTag(oArea);
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

void SaveGoBackLocation(object oDM, int nToken, location prevLoc){

    object oArea = GetAreaFromLocation(prevLoc);
    string areaTag = GetTag(oArea);
    string name = GetName(oArea);
    vector position = GetPositionFromLocation(prevLoc);
    float facing = GetFacingFromLocation(prevLoc);

    json jObject = JsonObject();
    jObject = JsonObjectSet(jObject, "areaTag", JsonString(areaTag));
    jObject = JsonObjectSet(jObject, "name", JsonString(name));
    jObject = JsonObjectSet(jObject, "position", JsonVector(position));
    jObject = JsonObjectSet(jObject, "facing", JsonFloat(facing));

    NuiSetBind(oDM, nToken, "dm_tp_mgr_back_tooltip", JsonString(name));
    SetLocalJson(oDM, "dm_tp_mgr_prevLocation", jObject);
}

void DoJump(object oDM, json jObject, int nToken){
    string areaTag = JsonGetString(JsonObjectGet(jObject, "areaTag"));
    vector position = JsonGetVector(JsonObjectGet(jObject, "position"));
    float facing = JsonGetFloat(JsonObjectGet(jObject, "facing"));
    object area = GetObjectByTag(areaTag);
    if(area == OBJECT_INVALID){
        SendMessageToPC(oDM, "Area not found");
        return;
    }
    location loc = Location(area, position, facing);

    SaveGoBackLocation(oDM, nToken, GetLocation(oDM));

    AssignCommand(oDM, ClearAllActions());
    AssignCommand(oDM, ActionJumpToLocation(loc));    
}

void GoBackToPreviousLocation(object oDM, int nToken){
    json jObject = GetLocalJson(oDM, "dm_tp_mgr_prevLocation");
    DoJump(oDM, jObject, nToken);
}

void GoToDMLocation(object oDM, int nLocationIndex, int nToken){
    json jLocations = GetLocalJson(oDM, "dm_tp_mgr_locations");
    json jObject = JsonArrayGet(jLocations, nLocationIndex);
    DoJump(oDM, jObject, nToken);
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
    json jButtonBack = NuiId(NuiButton (JsonString("Prev jump location")), "dm_tp_mgr_back");
    jButtonBack = NuiTooltip (jButtonBack, NuiBind("dm_tp_mgr_back_tooltip"));
    jButtonBack = NuiWidth(jButtonBack, 140.0f);
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

/*--------------------------------- DM Placeable Manager ---------------------------------*/

json ListPlaceables(object oDM){
    object oArea = GetArea(oDM);
    json jPlaceables = JsonArray();
    object pl = GetFirstObjectInArea(oArea);
    while(GetIsObjectValid(pl)){
        if(GetObjectType(pl) == OBJECT_TYPE_PLACEABLE){
            string sTag = GetTag(pl);
            string sName = GetName(pl);
            json jPlaceable = JsonObject();
            jPlaceable = JsonObjectSet(jPlaceable, "tag", JsonString(sTag));
            jPlaceable = JsonObjectSet(jPlaceable, "name", JsonString(sName));
            jPlaceable = JsonObjectSet(jPlaceable, "ref", JsonString(ObjectToString(pl)));
            jPlaceables = JsonArrayInsert(jPlaceables, jPlaceable);
        }

        pl = GetNextObjectInArea(oArea);
    }
    return jPlaceables;
}

json CreateDeletePlaceableButton(int id = 0){
    string sIdButton = "pl_delete_"+IntToString(id);
    json jButton = NuiId(NuiButton(JsonString("x")), sIdButton);
    jButton = NuiStyleForegroundColor(jButton, GetNUIColorWithName("red"));
    jButton = NuiTooltip (jButton, JsonString("Remove placeable"));
    jButton = NuiWidth (jButton, 20.0f);
    jButton = NuiHeight (jButton, 20.0f);
    return jButton;
}

json CreatePlaceableButton(string buttonName = "<empty>", int id = 0){
    string sIdButton = "pl_"+IntToString(id);
    json jButton = NuiId(NuiButton(JsonString(buttonName)), sIdButton);
    jButton = NuiTooltip (jButton, JsonString(buttonName));
    jButton = NuiWidth (jButton, 240.0f);
    jButton = NuiHeight (jButton, 20.0f);
    return jButton;
}

void RefreshPlaceableContainer(object oDM, int nToken){
    json jPlaceables = ListPlaceables(GetArea(oDM));
    json jCol = JsonArray();
    int i =0;
    for(i = 0; i < JsonGetLength(jPlaceables); i++){
        json jLine = JsonArray();
        json jObject = JsonArrayGet(jPlaceables, i);
        string name = JsonGetString(JsonObjectGet(jObject, "name"));
        string tag = JsonGetString(JsonObjectGet(jObject, "tag"));
        json tpButton = CreatePlaceableButton(name + " - " + tag, i);
        jLine = JsonArrayInsert(jLine, tpButton);
        jLine = JsonArrayInsert(jLine, CreateDeletePlaceableButton(i));
        jLine = NuiRow(jLine);
        jCol = JsonArrayInsert(jCol, jLine);
    }
    jCol = NuiCol(jCol);
    NuiSetGroupLayout(oDM, nToken, "dm_placeable_mgr_container", jCol);
}

void GoToPlaceable(object oDM, int nLocationIndex, int nToken){
    json jPlaceables = ListPlaceables(GetArea(oDM));
    json jObject = JsonArrayGet(jPlaceables, nLocationIndex);
    object oPlaceable = StringToObject(JsonGetString(JsonObjectGet(jObject, "ref")));
    if(GetIsObjectValid(oPlaceable)){
        AssignCommand(oDM, ClearAllActions());
        AssignCommand(oDM, ActionJumpToObject(oPlaceable));
    }
}

void DeletePlaceable(object oDM, int nLocationIndex){
    json jPlaceables = ListPlaceables(GetArea(oDM));
    json jObject = JsonArrayGet(jPlaceables, nLocationIndex);
    object oPlaceable = StringToObject(JsonGetString(JsonObjectGet(jObject, "ref")));
    if(GetIsObjectValid(oPlaceable)){
        DestroyObject(oPlaceable);
        jPlaceables = JsonArrayDel(jPlaceables, nLocationIndex);
    }
}

void PopDMPlaceableManager(object oDM){
    float fWidth = 320.0f;
    float fHeight = 400.0f;
    
    // --- container
    json jContainer = JsonArray();
    jContainer = NuiRow(jContainer);
    jContainer = NuiGroup(jContainer, TRUE, NUI_SCROLLBARS_AUTO);
    jContainer = NuiWidth(jContainer, 290.0f);
    jContainer = NuiId(jContainer, "dm_placeable_mgr_container");
    

    json jColGlobal = JsonArray();
    jColGlobal = JsonArrayInsert(jColGlobal, jContainer);
    json jLayoutGlobal = NuiCol (jColGlobal);
    int nToken = SetWindow(oDM, jLayoutGlobal, DM_PLACEABLE_MGR_WINDOW, "DM Placeable Manager", -1.0f, -1.0f, fWidth, fHeight, TRUE, TRUE, TRUE, TRUE, TRUE);
    RefreshPlaceableContainer(oDM, nToken);
}