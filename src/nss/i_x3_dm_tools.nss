#include "nw_inc_nui"
#include "nw_inc_nui_insp"
#include "x0_i0_position" 
#include "nui_windows"
#include "i_quests"


const int MAX_NB_LOCATIONS = 20;

const string DM_TELEPORT_MGR_WINDOW = "dm-teleport-manager";
const string DM_PLACEABLE_MGR_WINDOW = "dm-placeable-manager";
const string DM_QUEST_MGR_WINDOW = "dm-quest-manager";
const string DM_VFX_MGR_WINDOW = "dm-vfx-manager";

const int TARGET_MODE_VFX_APPLY = 4;
const string NUI_DM_VFX_MGR_TOKEN = "nui_dm_vfx_mgr_token";

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
    if("green"== name) return NuiColor(32, 222, 32, 255);
    if("lightblue"== name) return NuiColor(110, 255, 254, 255);
    if("darkblue"== name) return NuiColor(38, 71, 255, 255);
    if("yellow"== name) return NuiColor(255, 255, 0, 255);
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


/*--------------------------------- DM Quest Manager ---------------------------------*/

json GetQuestComboElements(){
    json jQuestCombo = JsonArray();
    json jQuestDefault = NuiComboEntry("Select a quest", 0);
    jQuestCombo = JsonArrayInsert(jQuestCombo, jQuestDefault);

    //add generic quests
    int i = 1;
    for(i=1; i<= MAX_QUESTS; i++){
        string questName = GetQuestName(i);
        json jQuest = NuiComboEntry(questName, i);
        jQuestCombo = JsonArrayInsert(jQuestCombo, jQuest);
    }

    //add special quests
    // QUEST_KILLQUEST
    json jQuest = NuiComboEntry("Guard's assignment", MAX_QUESTS+1);
    jQuestCombo = JsonArrayInsert(jQuestCombo, jQuest);

    // QUEST_EXTENDQUEST
    jQuest = NuiComboEntry("Elijah's tasks", MAX_QUESTS+2);
    jQuestCombo = JsonArrayInsert(jQuestCombo, jQuest);

    // Signatures

    return jQuestCombo;
}

void RefreshQuestValue(object oDM, int nToken, int delta = 0){

    json jQuestValue = NuiGetBind(oDM, nToken, "dm_quest_mgr_quest_value");
    json jQuestValueMax = NuiGetBind(oDM, nToken, "dm_quest_mgr_quest_max");

    int nQuestValue = JsonGetInt(jQuestValue);
    int nQuestMax = JsonGetInt(jQuestValueMax);

    if(delta != 0){
        nQuestValue = nQuestValue + delta;
    }

    if(nQuestValue < 0){
        nQuestValue = 0;
    }
    NuiSetBind(oDM, nToken, "dm_quest_mgr_quest_value", JsonInt(nQuestValue));

    string sQuestMax = IntToString(nQuestMax);
    if(-1 == nQuestMax){
        sQuestMax = "?";
    }
    else{
        if(nQuestValue > nQuestMax){
            nQuestValue = nQuestMax;
        }        
    }

    NuiSetBind(oDM, nToken, "dm_quest_mgr_quest_value_display", JsonString(IntToString(nQuestValue) + " / " + sQuestMax));
}

int GetDigitValue(int nthDigit, int nValue){
    string sValue = IntToString(nValue);
    int nLength = GetStringLength(sValue);
    if(nthDigit >= nLength){
        return 0;
    }
    string sDigit = GetSubString(sValue, nthDigit, 1);
    return StringToInt(sDigit);
}

void RefreshQuestContainer(object oDM, int nToken, int nQuestIndex){
    json jCol = JsonArray();

    json jData = NuiGetUserData(oDM, nToken);
    object oTarget = StringToObject(JsonGetString(jData));
    if(!GetIsObjectValid(oTarget)){

        json jLine = JsonArray();
        json jLabelPlayerNotFound = NuiLabel(JsonString("Invalid player, try again"), JsonInt(NUI_HALIGN_CENTER), JsonInt(NUI_VALIGN_MIDDLE)); 
        jLabelPlayerNotFound = NuiHeight(jLabelPlayerNotFound, 20.0f);
        jLine = JsonArrayInsert(jLine, jLabelPlayerNotFound);
        jCol = JsonArrayInsert(jCol, jLine);
        jCol = NuiCol(jCol);
        NuiSetGroupLayout(oDM, nToken, "dm_quest_mgr_container", jCol);
        return;
    }

    //get quest data
    string questName = GetQuestName(nQuestIndex);
    int nQuestValue = GetQuestInt(oTarget, nQuestIndex);
    int nQuestMax = QuestMaximum(oTarget, nQuestIndex);
    if(nQuestIndex > MAX_QUESTS){
        if(nQuestIndex == MAX_QUESTS+1){
            questName = "Guard's assignment";
        }
        else if(nQuestIndex == MAX_QUESTS+2){
            questName = "Elijah's tasks";
        }
    }

    NuiSetBind(oDM, nToken, "dm_quest_mgr_quest_name", JsonString(questName));
    NuiSetBind(oDM, nToken, "dm_quest_mgr_quest_value", JsonInt(nQuestValue));
    NuiSetBind(oDM, nToken, "dm_quest_mgr_quest_max", JsonInt(nQuestMax));

    // --- name
    json jLine = JsonArray();
    json jLabelQuestName = NuiLabel(JsonString("Edit quest : " + questName), JsonInt(NUI_HALIGN_CENTER), JsonInt(NUI_VALIGN_MIDDLE)); 
    jLabelQuestName = NuiHeight(jLabelQuestName, 20.0f);
    jLine = JsonArrayInsert(jLine, jLabelQuestName);
    jLine = NuiRow(jLine);
    jCol = JsonArrayInsert(jCol, jLine);


    // normal quest controls
    if(nQuestIndex <= MAX_QUESTS){

        // --- description
        json jLineDesc = JsonArray();
        json jDescription =  NuiText(JsonString("The description of the quest here, with detailled steps"), FALSE, NUI_SCROLLBARS_AUTO);
        jLineDesc = JsonArrayInsert(jLineDesc, jDescription);
        jLineDesc = NuiRow(jLineDesc);
        jCol = JsonArrayInsert(jCol, jLineDesc);

        // ---  < | value / maxValue | >
        json jLineValueEdit = JsonArray();
        json jButtonMinus = NuiId(NuiButton(JsonString("<")), "dm_quest_mgr_minus_"+IntToString(nQuestIndex));
        jButtonMinus = NuiTooltip(jButtonMinus, JsonString("Decrease quest value"));

        json jLabelQuestValue = NuiLabel(NuiBind("dm_quest_mgr_quest_value_display"), JsonInt(NUI_HALIGN_CENTER), JsonInt(NUI_VALIGN_MIDDLE));
        RefreshQuestValue(oDM, nToken);

        json jButtonPlus = NuiId(NuiButton(JsonString(">")), "dm_quest_mgr_plus_"+IntToString(nQuestIndex));
        jButtonPlus = NuiTooltip(jButtonPlus, JsonString("Increase quest value"));

        jLineValueEdit = JsonArrayInsert(jLineValueEdit, jButtonMinus);
        jLineValueEdit = JsonArrayInsert(jLineValueEdit, jLabelQuestValue);
        jLineValueEdit = JsonArrayInsert(jLineValueEdit, jButtonPlus);
        jLineValueEdit = NuiRow(jLineValueEdit);
        jCol = JsonArrayInsert(jCol, jLineValueEdit);
    }

    //special quests controls
    if(nQuestIndex == MAX_QUESTS+1){

        int iKQStatus = GetLocalInt(oTarget, QUEST_KILLQUEST);

        WriteTimestampedLogEntry("KQ status : " + IntToString(iKQStatus));

        int banditBoss = GetDigitValue(1 ,iKQStatus);

        WriteTimestampedLogEntry("Bandit boss : " + IntToString(banditBoss));
        int goblinBoss = GetDigitValue(2 ,iKQStatus);
        WriteTimestampedLogEntry("Goblin boss : " + IntToString(goblinBoss));
        int sshtlaBoss = GetDigitValue(3 ,iKQStatus);
        WriteTimestampedLogEntry("SShtla boss : " + IntToString(sshtlaBoss));
        int orcCaptain = GetDigitValue(4 ,iKQStatus);
        WriteTimestampedLogEntry("Orc captain : " + IntToString(orcCaptain));
        int ibCaptain = GetDigitValue(5 ,iKQStatus);
        WriteTimestampedLogEntry("IB captain : " + IntToString(ibCaptain));

        json jLineSpecial = JsonArray();
        jLineSpecial = JsonArrayInsert(jLineSpecial, NuiCheck(JsonString("Bandit boss's head"), JsonBool(banditBoss)));
        jLineSpecial = NuiRow(jLineSpecial);
        jCol = JsonArrayInsert(jCol, jLineSpecial);

        jLineSpecial = JsonArray();
        jLineSpecial = JsonArrayInsert(jLineSpecial, NuiCheck(JsonString("Goblin chief's head"), JsonBool(goblinBoss)));
        jLineSpecial = NuiRow(jLineSpecial);
        jCol = JsonArrayInsert(jCol, jLineSpecial);

        jLineSpecial = JsonArray();
        jLineSpecial = JsonArrayInsert(jLineSpecial, NuiCheck(JsonString("SSthla chied's head"), JsonBool(sshtlaBoss)));
        jLineSpecial = NuiRow(jLineSpecial);
        jCol = JsonArrayInsert(jCol, jLineSpecial);

        jLineSpecial = JsonArray();
        jLineSpecial = JsonArrayInsert(jLineSpecial, NuiCheck(JsonString("Orc captain's head"), JsonBool(orcCaptain)));
        jLineSpecial = NuiRow(jLineSpecial);
        jCol = JsonArrayInsert(jCol, jLineSpecial);

        jLineSpecial = JsonArray();
        jLineSpecial = JsonArrayInsert(jLineSpecial, NuiCheck(JsonString("IB Captain's head"), JsonBool(ibCaptain)));
        jLineSpecial = NuiRow(jLineSpecial);
        jCol = JsonArrayInsert(jCol, jLineSpecial);

    }

    if(nQuestIndex == MAX_QUESTS+2){

        int iKQStatus = GetLocalInt(oTarget, QUEST_EXTENDQUEST);

        int orccomm = GetDigitValue(1 ,iKQStatus);
        int bragg = GetDigitValue(2 ,iKQStatus);
        int be = GetDigitValue(3 ,iKQStatus);

        json jLineSpecial = JsonArray();
        jLineSpecial = JsonArrayInsert(jLineSpecial, NuiCheck(JsonString("Orc commander's head"), JsonBool(orccomm)));
        jLineSpecial = NuiRow(jLineSpecial);
        jCol = JsonArrayInsert(jCol, jLineSpecial);

        jLineSpecial = JsonArray();
        jLineSpecial = JsonArrayInsert(jLineSpecial, NuiCheck(JsonString("General Bragg's head"), JsonBool(bragg)));
        jLineSpecial = NuiRow(jLineSpecial);
        jCol = JsonArrayInsert(jCol, jLineSpecial);

        jLineSpecial = JsonArray();
        jLineSpecial = JsonArrayInsert(jLineSpecial, NuiCheck(JsonString("Bleeding Eye Chief's head"), JsonBool(be)));
        jLineSpecial = NuiRow(jLineSpecial);
        jCol = JsonArrayInsert(jCol, jLineSpecial);

    }

    //-- buttons

    jCol = NuiCol(jCol);
    NuiSetGroupLayout(oDM, nToken, "dm_quest_mgr_container", jCol);
}

//TODO
//set quest value (savedb int etc), button reset / valider 
//use recall orb automatically + Floatingstring on PC

// log quest string just in case with comment etc
//search in journal not in journal
//special quests display checkboxes for heads / singatres / etc
//reward info, XP, item gomld what stage ?

void PopDMQuestManager(object oDM, object oPlayer){
    float fWidth = 550.0f;
    float fHeight = 400.0f;

    // --- header
    json jHeader = JsonArray();

    string playerName = GetName(oPlayer);
    int nLevel = GetHitDice(oPlayer);

    string playerInfo = playerName + " - Level " + IntToString(nLevel);

    json jLabelPlayerName = NuiLabel(JsonString(playerInfo), JsonInt(NUI_HALIGN_CENTER), JsonInt(NUI_VALIGN_MIDDLE)); 
    jLabelPlayerName = NuiHeight(jLabelPlayerName, 20.0f);
    jHeader = JsonArrayInsert(jHeader, jLabelPlayerName);


    // --- quest selection
    json jQuestSelection = JsonArray();
    json jQuestElements = GetQuestComboElements();

    json jQuestCombo = NuiCombo(jQuestElements, NuiBind("dm_quest_mgr_combo_value"));
    jQuestCombo = NuiId(jQuestCombo, "dm_quest_mgr_combo");
    jQuestCombo = NuiWidth(jQuestCombo, 200.0f);
    

    jQuestSelection = JsonArrayInsert(jQuestSelection, jQuestCombo);

    // --- container
    json jContainer = JsonArray();



    // --- make NuiRows
    jHeader = NuiRow(jHeader);
    jQuestSelection = NuiRow(jQuestSelection);
    jContainer = NuiRow(jContainer);


    jContainer = NuiGroup(jContainer, TRUE, NUI_SCROLLBARS_AUTO);
    jContainer = NuiId(jContainer, "dm_quest_mgr_container");
    jContainer = NuiWidth(jContainer, 520.0f);

    json jColGlobal = JsonArray();
    jColGlobal = JsonArrayInsert(jColGlobal, jHeader);
    jColGlobal = JsonArrayInsert(jColGlobal, jQuestSelection);
    jColGlobal = JsonArrayInsert(jColGlobal, jContainer);

    json jLayoutGlobal = NuiCol (jColGlobal);
    int nToken = SetWindow(oDM, jLayoutGlobal, DM_QUEST_MGR_WINDOW, "DM Quest Manager", -1.0f, -1.0f, fWidth, fHeight, TRUE, TRUE, TRUE, FALSE, TRUE);

    NuiSetBindWatch(oDM, nToken, "dm_quest_mgr_combo_value", TRUE);
    NuiSetUserData(oDM, nToken, JsonString(ObjectToString(oPlayer)));
}


/*--------------------------------- DM VFX Manager ---------------------------------*/

//naive approach, looping through 2DA again. Maybe save json list of all toggles buttons and put it in bindUserData
void RunSelectedEffects(object oDM, int nToken, location loc){

    int i = 0;
    string label = Get2DAString("3t-dm-vfx", "label", i);
    
    while(label != "" && i <100){
        
        json vfx = NuiGetBind(oDM, nToken, "button_vfx_toggle_"+IntToString(i));
        int isOn = JsonGetInt(vfx);
        if(isOn){
            string vfx_code = Get2DAString("3t-dm-vfx", "vfx_code", i);
            string vfx_duration = Get2DAString("3t-dm-vfx", "duration", i);
            float duration = StringToFloat(vfx_duration);
            if(duration > 0.0f){
                ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(StringToInt(vfx_code)), loc, duration);
            }
            else{
                ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(StringToInt(vfx_code)), loc);
            }
        }
        i++;
        label = Get2DAString("3t-dm-vfx", "label", i);
    }
}

void PopDMVFXManager(object oDM){
    float fWidth = 790.0f;
    float fHeight = 510.0f;
    
    int nColumns = 4;

    json jSelectorRow = JsonArray();
    json targetButton = NuiButtonImage(JsonString("gui_mp_magicu"));
    targetButton = NuiId(targetButton, "setTargetObject");
    targetButton = NuiWidth(targetButton, 75.0f);
    targetButton = NuiHeight(targetButton, 75.0f);
    jSelectorRow = JsonArrayInsert(jSelectorRow, targetButton);
    jSelectorRow = NuiRow(jSelectorRow);

    // --- container
    json jMatrix = JsonArray();

    int i = 0;
    
    json jMatrixRow = JsonArray();
    string label = Get2DAString("3t-dm-vfx", "label", i);
    while(label != "" && i <100){
        
        string vfx_code_label = Get2DAString("3t-dm-vfx", "vfx_code_label", i);
        string vfx_code = Get2DAString("3t-dm-vfx", "vfx_code", i);
        // string color = Get2DAString("3t-dm-vfx", "color", i);

        json jButton = NuiId(NuiButtonSelect(JsonString(label), NuiBind("button_vfx_toggle_"+IntToString(i))), "button_vfx_"+IntToString(i));
        // jButton = NuiStyleForegroundColor(jButton, GetNUIColorWithName(color));
        jButton = NuiTooltip(jButton, JsonString(label + " - " + vfx_code_label));
        jButton = NuiWidth(jButton, 190.0f);
        jButton = NuiHeight(jButton, 30.0f);
        jMatrixRow = JsonArrayInsert(jMatrixRow, jButton);

        if ((i + 1) % nColumns == 0)
        {
            jMatrixRow = NuiRow(jMatrixRow);
            jMatrix = JsonArrayInsert(jMatrix, jMatrixRow);
            jMatrixRow = JsonArray();
        }
        i++;

        label = Get2DAString("3t-dm-vfx", "label", i);
    }
    // make NuiRows ---
    jMatrix = NuiCol(jMatrix);

    json jColGlobal = JsonArray();
    jColGlobal = JsonArrayInsert(jColGlobal, jSelectorRow);
    jColGlobal = JsonArrayInsert(jColGlobal, jMatrix);
    json jLayoutGlobal = NuiCol (jColGlobal);
    int nToken = SetWindow(oDM, jLayoutGlobal, DM_VFX_MGR_WINDOW, "DM VFX Manager", -1.0f, -1.0f, fWidth, fHeight, TRUE, TRUE, TRUE, TRUE, TRUE);
    SetLocalInt(oDM, NUI_DM_VFX_MGR_TOKEN, nToken);
}