#include "nw_inc_nui"
#include "nw_inc_nui_insp"
#include "x0_i0_position" 
#include "nui_windows"


const string NUI_PM_SUMMONS_WINDOW = "nui_pm_summons";

//ranged
const string DEATH_KNIGHT_MASTER = "Death Knight Master Archer";
const string SPECTRAL_GRANDMASTER_ARCHER = "Spectral Grandmaster Archer";
const string GIANT_ARCHER = "Undead Giant Archer";

const string DEATH_KNIGHT_MASTER_PORTRAIT = "po_matmother_l";
const string SPECTRAL_GRANDMASTER_ARCHER_PORTRAIT = "po_lichking_l";
const string GIANT_ARCHER_PORTRAIT = "po_sk_pre01_l";

const string DEATH_KNIGHT_MASTER_DESC = "Death's own archer, a harbinger of the grave whose every arrow finds its mark with supernatural precision. Those foolish enough to approach this dread sentinel find their very life force withering away beneath its aura of decay.";
const string SPECTRAL_GRANDMASTER_ARCHER_DESC = "A ghostly figure of a master archer from ages past, it drifts silently across the battlefield. Its ethereal arrows pass through armor and flesh alike, striking with deadly precision and draining the life force of its victims.";
const string GIANT_ARCHER_DESC = "A towering skeletal behemoth armed with an enormous bow, its arrows are as large as spears. Though its decaying frame creaks with each movement, its shots are devastating, raining death from afar with overwhelming force.";

//melee
const string DEMONIC_NAMELESS_RACE = "Demonic Nameless Race";
const string SPEARTHRONE_COLOSSUS = "Spearthrone Colossus";
const string DEATH_SHADOW_DEVIL = "Death Shadow Devil";

const string DEMONIC_NAMELESS_RACE_PORTRAIT = "po_hu_m_07_l";
const string SPEARTHRONE_COLOSSUS_PORTRAIT = "po_sk_chief01_l";
const string DEATH_SHADOW_DEVIL_PORTRAIT = "po_lichkmasked_l";

const string DEMONIC_NAMELESS_RACE_DESC = "Twisted by infernal magic and the souls of drow captives, these demonic horrors are enslaved to the priesthood's will. With glowing eyes and corrupted forms, they patrol the city as ruthless enforcers of dark power.";
const string SPEARTHRONE_COLOSSUS_DESC = "An ancient skeletal giant armed with a massive spear and shield, bound by dark magic. Its towering frame and relentless strikes make it a fearsome guardian of the undead legions.";
const string DEATH_SHADOW_DEVIL_DESC = "po_hu_m_07_l";


json GetAvailableSummons(string suffix){
    json jCombo = JsonArray();

    string name1 ="";
    string name2 ="";

    if("A"==suffix){
        name1 = GIANT_ARCHER;
        name2 = DEMONIC_NAMELESS_RACE;
    }
    else if("B" == suffix){
        name1 = SPECTRAL_GRANDMASTER_ARCHER;
        name2 = SPEARTHRONE_COLOSSUS;
    }
    else if("C" == suffix){
        name1 = DEATH_KNIGHT_MASTER;
        name2 = DEATH_SHADOW_DEVIL;
    }

    json jDefault = NuiComboEntry(name1, 0);
    jCombo = JsonArrayInsert(jCombo, jDefault);

    json jQuest = NuiComboEntry(name2, 1);
    jCombo = JsonArrayInsert(jCombo, jQuest);

    return jCombo;
}

json GetSummonSelectorColumn(string suffix){
    string abilityName = "";
    string description = "";
    string portrait;

    if("A" == suffix){
        abilityName = "Animate dead";
    }
    else if("B" == suffix){
        abilityName = "Summon undead";
    }
    else if("C" == suffix){
        abilityName = "Summon greater undead";
    }

    json jColLeft = JsonArray();

    json jAbility = NuiText(JsonString(abilityName), FALSE, NUI_SCROLLBARS_NONE);
    jAbility = NuiGroup(jAbility);
    jAbility = NuiWidth(jAbility, 200.0f);
    jAbility = NuiHeight(jAbility, 35.0f);
    jAbility = NuiStyleForegroundColor(jAbility, NuiColor(0, 0, 0)); //186
    jColLeft = JsonArrayInsert(jColLeft, jAbility);    

    //combo
    json jCombo = NuiCombo(GetAvailableSummons(suffix), NuiBind("pm_summon_list_"+suffix+"_value"));
    jCombo = NuiId(jCombo, "pm_summon_"+suffix+"_combo");
    jCombo = NuiWidth(jCombo, 199.0f);
    jColLeft = JsonArrayInsert(jColLeft, jCombo);

    //portrait
    json jPortrait = NuiImage(NuiBind("portrait_"+suffix), JsonInt(NUI_ASPECT_FILL), JsonInt(NUI_HALIGN_CENTER), JsonInt(NUI_VALIGN_TOP));
    jPortrait = NuiId(jPortrait, "setTargetObject");
    jPortrait = NuiGroup (jPortrait);
    float pWidth = 100.0f;
    jPortrait = NuiWidth (jPortrait, pWidth);
    jPortrait = NuiHeight (jPortrait, pWidth * 1.52f);

    json jPortraitContainer = JsonArray();
    jPortraitContainer = JsonArrayInsert(jPortraitContainer, NuiSpacer());
    jPortraitContainer = JsonArrayInsert(jPortraitContainer, jPortrait);
    jPortraitContainer = JsonArrayInsert(jPortraitContainer, NuiSpacer());
    jPortraitContainer = NuiRow(jPortraitContainer);
    jColLeft = JsonArrayInsert(jColLeft, jPortraitContainer);

    //description
    json jDescription = NuiText(NuiBind("description_"+suffix), FALSE, NUI_SCROLLBARS_NONE);
    jDescription = NuiGroup (jDescription);
    jDescription = NuiStyleForegroundColor(jDescription, NuiColor(0, 0, 0)); //186
    jColLeft = JsonArrayInsert(jColLeft, jDescription);

    jColLeft = NuiCol(jColLeft);
    jColLeft = NuiHeight(jColLeft, 450.0f);

    return jColLeft;
}

void PaleMasterSettingUpdateData(object oPlayer, int nToken){

    json jA = NuiGetBind(oPlayer, nToken, "pm_summon_list_A_value");
    int valueA = JsonGetInt(jA);

    json jB = NuiGetBind(oPlayer, nToken, "pm_summon_list_B_value");
    int valueB = JsonGetInt(jB);

    json jC = NuiGetBind(oPlayer, nToken, "pm_summon_list_C_value");
    int valueC = JsonGetInt(jC);

    
    if(valueA == 0){
        NuiSetBind(oPlayer, nToken, "portrait_A", JsonString(GIANT_ARCHER_PORTRAIT));
        NuiSetBind(oPlayer, nToken, "description_A", JsonString(GIANT_ARCHER_DESC));
    }
    else{
        NuiSetBind(oPlayer, nToken, "portrait_A", JsonString(DEMONIC_NAMELESS_RACE_PORTRAIT));
        NuiSetBind(oPlayer, nToken, "description_A", JsonString(DEMONIC_NAMELESS_RACE_DESC));
    }

    
    if(valueB == 0){
        NuiSetBind(oPlayer, nToken, "portrait_B", JsonString(SPECTRAL_GRANDMASTER_ARCHER_PORTRAIT));
        NuiSetBind(oPlayer, nToken, "description_B", JsonString(SPECTRAL_GRANDMASTER_ARCHER_DESC));
    }
    else{
        NuiSetBind(oPlayer, nToken, "portrait_B", JsonString(SPEARTHRONE_COLOSSUS_PORTRAIT));
        NuiSetBind(oPlayer, nToken, "description_B", JsonString(SPEARTHRONE_COLOSSUS_DESC));
    }

    if(valueC == 0){
        NuiSetBind(oPlayer, nToken, "portrait_C", JsonString(DEATH_KNIGHT_MASTER_PORTRAIT));
        NuiSetBind(oPlayer, nToken, "description_C", JsonString(DEATH_KNIGHT_MASTER_DESC));
    }
    else{
        NuiSetBind(oPlayer, nToken, "portrait_C", JsonString(DEATH_SHADOW_DEVIL_PORTRAIT));
        NuiSetBind(oPlayer, nToken, "description_C", JsonString(DEATH_SHADOW_DEVIL_DESC));
    }

    //set player setting here, with framework
    // int valueA = GetLocalInt(oPlayer, "PM_SUMMON_LIST_A");
    // int valueB = GetLocalInt(oPlayer, "PM_SUMMON_LIST_B");
    // int valueC = GetLocalInt(oPlayer, "PM_SUMMON_LIST_C");
}

void PopPaleMasterSummonChooser(object oPlayer){

    float fWidth = 850.0f;
    float fHeight = 600.0;
    
    float buttonsWidthBig = 160.0f;
    float buttonsHeightBig = 60.0f;
    float buttonsWidthMedium = 125.0f;

    json jImage = NuiDrawListImage(
        JsonBool(TRUE),
        JsonString("pm_bg_dalle2"),
        NuiRect(0.0, 0.0, fWidth, fHeight),
        JsonInt(NUI_ASPECT_STRETCH),
        JsonInt(NUI_HALIGN_CENTER),
        JsonInt(NUI_VALIGN_MIDDLE),
        NUI_DRAW_LIST_ITEM_ORDER_BEFORE,
        NUI_DRAW_LIST_ITEM_RENDER_ALWAYS);

    json jGroupImageRow = JsonArray();
    // jGroupImageRow = JsonArrayInsert(jGroupImageRow, jFirstText);
    jGroupImageRow = JsonArrayInsert(jGroupImageRow, NuiWidth(NuiSpacer(), 125.0f));
    jGroupImageRow = JsonArrayInsert(jGroupImageRow, GetSummonSelectorColumn("A"));
    jGroupImageRow = JsonArrayInsert(jGroupImageRow, GetSummonSelectorColumn("B"));
    jGroupImageRow = JsonArrayInsert(jGroupImageRow, GetSummonSelectorColumn("C"));
    jGroupImageRow = JsonArrayInsert(jGroupImageRow, NuiWidth(NuiSpacer(), 125.0f));


    json jContainerButton = JsonArray();
        json jButton = NuiId(NuiButton(JsonString("x")), "pm_summons_close");
        jButton = NuiStyleForegroundColor(jButton,  NuiColor(255, 76, 36, 255));
        jButton = NuiTooltip (jButton, JsonString("Close"));
        jButton = NuiWidth (jButton, 30.0f);
        jButton = NuiHeight (jButton, 30.0f);
        jContainerButton = JsonArrayInsert(jContainerButton, NuiWidth(NuiSpacer(), 820.0f));
        jContainerButton = JsonArrayInsert(jContainerButton, jButton);
        jContainerButton = NuiRow(jContainerButton);
        jContainerButton = NuiHeight(jContainerButton, 35.0f);

    json jGroupImageCol = JsonArray();
        jGroupImageCol = JsonArrayInsert(jGroupImageCol, jContainerButton);
        jGroupImageCol = JsonArrayInsert(jGroupImageCol, NuiHeight(NuiSpacer(), 30.0f));
        jGroupImageCol = JsonArrayInsert(jGroupImageCol, NuiRow(jGroupImageRow));

    json jGroupImage = NuiGroup(NuiCol(jGroupImageCol), FALSE, NUI_SCROLLBARS_NONE);

    json jImageList = JsonArray();
    jImageList = JsonArrayInsert(jImageList, jImage);
    json jList = NuiDrawList(jGroupImage, JsonBool(FALSE), jImageList);

    json jColGlobal = JsonArray();
    jColGlobal = JsonArrayInsert(jColGlobal, jList);

    json jLayoutGlobal = NuiCol(jColGlobal);
    int nToken = SetWindow(oPlayer, jLayoutGlobal, NUI_PM_SUMMONS_WINDOW, "FALSE", -1.0f, -1.0f, fWidth, fHeight, FALSE, FALSE, FALSE, TRUE, FALSE);    

    NuiSetBindWatch(oPlayer, nToken, "pm_summon_list_A_value", TRUE);
    NuiSetBindWatch(oPlayer, nToken, "pm_summon_list_B_value", TRUE);
    NuiSetBindWatch(oPlayer, nToken, "pm_summon_list_C_value", TRUE);
    PaleMasterSettingUpdateData(oPlayer, nToken);
}


/*

#include "nui_pm_summons"
void main(){
    PopPaleMasterSummonChooser(OBJECT_SELF);
}


*/