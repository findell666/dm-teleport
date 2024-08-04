//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// i_quests
// Scytale
// Quest functions
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

// QUEST FUNCTIONS
int GetQuestInt(object oPC, int QuestNumber);
string GetQuestName(int iQuest);
void SetQuestInt(object oPC, int iQuestNumber, int iQuestSetting);
string SetDefaultQuestString(object oPC);
string GetQuestString(object oPC);
void ConvertQuestInfo(object oPC);
void UpdateJournal(object oPC, int iQuest, int iAlert = TRUE);
void UpdateJournalKillQuest(object oPC);
void GiveQuestItem(object oPC, int iQuest);
string GenerateRewardItem(object oPC, int iList =0);
void RewardPlayerItem(object oPC);
void UpdateSigsJournal(object oPC, int iNumSigs = 6);
void RewardPlayerFinal(object oPC, int iQuest,int iGiveXP = TRUE, int iGiveGold = TRUE, int iGiveRep = FALSE, int iGiveItem = FALSE);
//rewards based on variables
void RewardPlayerGold(object oPC, int iReward = 1000);
void RewardPlayerXP(object oPC, int iReward = 1000);
// Counts the weirdling artifacts on the PC.
int CountArtifacts(object oPC);
void ChkPortalQuest(object oPC,int iQuestSetting);
// Calculate xp reward based on difficulty and level
int CalcXPReward (int iDifficulty , int iLevel);
string GetQuestItem(int iQuest, object oRewarded = OBJECT_INVALID);

const string QUESTS = "quests";
const string QUEST_KILLQUEST = "KillQuest";
const string QUEST_EXTENDQUEST = "ExtendQuest";
const string QUEST_SIGS = "sigs";

// STANDARD QUEST CONSTANTS
const int MAX_QUESTS = 72;          // <-- Update this when you add a new quest
const int QUEST_WHEATON_MILL = 1;
const int QUEST_TINNELY = 2;
const int QUEST_FRIAMMIRRI = 3;
const int QUEST_DISAPPEARANCES = 4;
const int QUEST_DELORFIN = 5;
const int QUEST_ORDEAL = 6;
const int QUEST_SPYQUEST = 7;
const int QUEST_DUERGAR = 8;
const int QUEST_DROWQUEST = 9;
const int QUEST_DROWHEAD = 10;
const int QUEST_MOUNTAIN_DWARF = 11;
const int QUEST_PIXIE = 12;
const int QUEST_STALKER = 13;
const int QUEST_SEFTEW = 14;
const int QUEST_NAZHUN = 15;
const int QUEST_GUARDIANS = 16;
const int QUEST_WOODELVES = 17; //this is now for all of the portal quest
const int QUEST_HARATA_MANONERA = 18;
const int QUEST_WARRIOR_KING = 19;
const int QUEST_LONELY = 20;
const int QUEST_STORMS = 21;
const int QUEST_ORKS = 22;
const int QUEST_DELIVERY = 23;
const int QUEST_BACKDOOR = 24;
const int QUEST_SCROLLS = 25;
const int QUEST_MINERS = 26;
const int QUEST_EXPLORE = 27;
const int QUEST_METTLE = 28;
const int QUEST_FURNACE = 29;
const int QUEST_RESSES = 30;
const int QUEST_DREAMS = 31;
const int QUEST_ISLEOFICE = 32;
const int QUEST_DRAGON = 33;
const int QUEST_SANTA = 34;
const int QUEST_OUKPRIS = 35;
const int QUEST_ASABIATS = 36;
const int QUEST_DRACOLICH = 37;
const int QUEST_TWINS = 38;
const int QUEST_UNCLE_SID = 39;
const int QUEST_BALANCE = 40;
const int QUEST_DENGAR = 41;
const int QUEST_RECIPE = 42;
const int QUEST_VARUL_EAR = 43;
const int QUEST_FIGHTPIT = 44;
const int QUEST_ARTIFACT = 45;
const int QUEST_FARMER = 46;
const int QUEST_SACRIFICE = 47;
const int QUEST_COMBINATION = 48;
const int QUEST_SURVIVAL = 49;
const int QUEST_GRINDEL = 50;
const int QUEST_FINAL_ELIJAH = 51;
const int QUEST_FINAL_BALANCE = 52;
const int QUEST_FINAL_EXILE = 53;
const int QUEST_FINAL_DROW = 54;
const int QUEST_DEEPWALKER = 55;
const int QUEST_DISEASE = 56;
const int QUEST_MIRRORS = 57;
const int QUEST_PALE_SOUL = 58;
const int QUEST_BOOKS = 59;
const int QUEST_OCCIDIO = 60;
const int QUEST_PTL_ELVES = 61;
const int QUEST_PTL_UD = 62;
const int QUEST_PTL_CAEN = 63;
const int QUEST_PTL_ICIES = 64;
const int QUEST_PTL_VARUL = 65;
const int QUEST_NCCULT = 66;
const int QUEST_WINDRACER = 67;
const int QUEST_SALIOS = 68;
const int QUEST_SEND_QUEEN = 69;
const int QUEST_SEND_CLARESSA = 70;
const int QUEST_SEND_ITEM1 = 71;
const int QUEST_SEND_ITEM2 = 72;
//const int QUEST_PIRATES = 73;
//const int QUEST_NCDOCS = 74;

/*const int BLANK = 61;
*/                                   // <-- Next free quest int - just rename me and move the comment dow

const string QUEST_DEFAULT = "C0310041100100407000004090705001019121208160805000711080000050004080005100300040803030301010303161503120020000700000005000000000000091403010100000000000000000000";

// Currently spaces for 80 quests

//  Fix for quests - resets quest string to latest default
//  -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
int questfix(object oPC) {
    string qst = GetQuestString(oPC);
    if (GetSubString(qst, 0, 1) != "C") {
        //  Old quest string - convert to new string
        // DeleteLocalString(oPC, QUESTS);
        SetDefaultQuestString(oPC);
        return 1;
    }
    return 0;
}

// Returns a quest int based on the quest
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
int GetQuestInt(object oPC, int iQuest) {
    // Normal quests
    string qst = GetQuestString(oPC);

    // Find the correct string
    int iSetting;
    iQuest = (iQuest*2)-1;
    string sQuest = GetSubString(qst, iQuest, 2);
    //SendMessageToPC(oPC, "Value: " + sQuest + " @:" + IntToString(iQuest));
    if (sQuest == "")
        iSetting = 0;
    else
        iSetting = StringToInt(sQuest);

    //SendMessageToPC(oPC, "Reading Quest: " + IntToString(iQuest) + " - Value: " + IntToString(iSetting));
    // and return
    return iSetting;
}

// Returns the string of quest variables and loads from DB if necessary
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
string GetQuestString(object oPC) {
    return QUEST_DEFAULT;
}


// Marks a quest at a new setting
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
void SetQuestInt(object oPC, int iQuestNumber, int iQuestSetting) {
    // Orion3T - Double check we arent trying to set an invalid quest as this corrupts the quest string
    if (iQuestNumber == FALSE) {
        string sName = GetName(OBJECT_SELF);
        if (sName != "Elradrien Jr'eiwaluin")
            SendMessageToAllDMs("Incorrect Quest setting: NPC = " + sName);
        return;
    }
    //SendMessageToAllDMs("Quest Debugging:  SetQuestInt:  Quest " + IntToString(iQuestNumber) + " Setting " + IntToString(iQuestSetting));
    string qst = GetQuestString(oPC);
    int iLoc = (iQuestNumber*2)-1;
    //SendMessageToAllDMs("iLoc = " + IntToString(iLoc));
    string newQst = GetStringLeft(qst, iLoc);
    //SendMessageToAllDMs("Quest string = " + qst + "Length = " + IntToString(GetStringLength(qst)));
    //SendMessageToAllDMs("Beginning of string = " + newQst);

    // Put back double digits
    if (iQuestSetting < 10) {
        newQst += "0" + IntToString(iQuestSetting);
        //SendMessageToAllDMs("Adding 0"+ IntToString(iQuestSetting) + " to string");
    }
    else {
        newQst += IntToString(iQuestSetting);
        //SendMessageToAllDMs("Adding " + IntToString(iQuestSetting) + " to string");
    }
    int nRestlength = (GetStringLength(qst) - (iLoc+2));
    string sRest = GetStringRight(qst, nRestlength);
    newQst += sRest;//GetStringRight(qst, GetStringLength(qst) - (iLoc+2));
    //SendMessageToAllDMs("Length of Remainder = " + IntToString(nRestlength) + "Length of new string = " + IntToString(GetStringLength(newQst)));
    //SendMessageToAllDMs("Remainder of string = " + sRest);
    //SendMessageToAllDMs("Full String = " + newQst);

    //SendMessageToPC(oPC, "Setting Quest: " + IntToString(iQuestNumber) + " - Value: " + IntToString(iQuestSetting));

    //SendMessageToPC(oPC, "Setting: " + GetLocalString(oPC, QUESTS));
    //portal quest update
    if ( iQuestNumber==17){
        ChkPortalQuest(oPC,iQuestSetting);
    }

}


// Sets the default quest string
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
string SetDefaultQuestString(object oPC) {
    return QUEST_DEFAULT;
}

// Returns the Quest Maximum
int QuestMaximum(object oPC, int iQuest) {
    switch (iQuest) {
        case QUEST_FRIAMMIRRI:      return 9; break;
        case QUEST_SEFTEW:          return 4; break;
        case QUEST_WOODELVES:       return 0; break;
        case QUEST_DRACOLICH:       return 3; break;
        case QUEST_LONELY:          return 8; break;
        case QUEST_ORKS:            return 8; break;
        case QUEST_DELIVERY:        return 5; break;
        case QUEST_DRAGON:          return 3; break;
        case QUEST_TWINS:           return 5; break;
        case QUEST_BALANCE:         return 8; break;
        case QUEST_ARTIFACT:        return 8; break;
        case QUEST_MIRRORS:         return 3; break;
        default:
            break;
    }

    return -1;
}


// Returns True if the quest has been completed
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
int IsQuestComplete(object oPC, int iQuest) {
    int iSetting = GetQuestInt(oPC, iQuest);

    if (iSetting == 0)
        return FALSE;

    switch (iQuest) {
    case QUEST_FRIAMMIRRI:      if (iSetting == 9) return TRUE; break;
    case QUEST_SEFTEW:          if (iSetting == 4) return TRUE; break;
    case QUEST_WOODELVES:       if (iSetting == 0) return TRUE; break;
    case QUEST_DRACOLICH:        if (iSetting == 3) return TRUE; break;
    case QUEST_LONELY:          if (iSetting == 8) return TRUE; break;
    case QUEST_ORKS:            if (iSetting == 8) return TRUE; break;
    case QUEST_DELIVERY:        if (iSetting == 5) return TRUE; break;
    case QUEST_DRAGON:          if (iSetting == 3) return TRUE; break;
    case QUEST_TWINS:           if (iSetting == 5) return TRUE; break;
    case QUEST_BALANCE:         if (iSetting == 8) return TRUE; break;
    case QUEST_ARTIFACT:       if (iSetting == 8) return TRUE; break;
    case QUEST_MIRRORS:       if (iSetting == 3) return TRUE; break;
    default:
        // Nothing to do
        break;
    }

    return FALSE;
}

//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// PARTY SETTINGS
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

// Sets a party to the quest value
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
void SetPartyQuestInt(object oPC, int iQuest, int iSetting, int iReq, int iXP=0,int bFinal = FALSE) {
    if (GetIsPC(oPC) || GetIsPC(GetMaster(oPC))) {
        object oFactionMember = GetFirstFactionMember(oPC, TRUE);
        while (GetIsObjectValid(oFactionMember) == TRUE) {
            if(GetArea(oFactionMember) == GetArea(oPC)) {
                if (GetQuestInt(oFactionMember, iQuest) == iReq) {
                    SetQuestInt(oFactionMember, iQuest, iSetting);
                    UpdateJournal(oFactionMember, iQuest);
                    if(iXP>0){
                        GiveXPToCreature(oFactionMember, iXP);
                    }
                    if(bFinal){
                        RewardPlayerFinal(oFactionMember, iQuest);
                    }
                }
            }
            oFactionMember = GetNextFactionMember(oPC, TRUE);
        }
    }
}

// Gives the whole party the quest item
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
void SetPartyQuestItem(object oPC, int iQuest, int iSetting, string sItem) {
    object oFactionMember = GetFirstFactionMember(oPC, TRUE);
    while (GetIsObjectValid(oFactionMember) == TRUE) {
        if(GetArea(oFactionMember) == GetArea(oPC)) {
            if ((GetQuestInt(oFactionMember, iQuest) == iSetting) || ((iQuest == 0) && (iSetting == 0))) {
                object oItem = CreateItemOnObject(sItem, oFactionMember);
            }
        }
        oFactionMember = GetNextFactionMember(oPC, TRUE);
    }
}



// Gives a standard reward, for use in partial quest completion
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
void RewardPlayerGold(object oPC, int iReward = 1000) {
    GiveGoldToCreature(oPC, iReward);
}
// Gives a standard XP reward, for use in partial quest completion
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
void RewardPlayerXP(object oPC, int iReward = 1000) {

    GiveXPToCreature(oPC, iReward);
}


// Gives a reward item as defined by variable "reward_item" on the NPC
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
void RewardPlayerItem(object oPC) {
    string iRewardItem = GetLocalString(OBJECT_SELF, "reward_item");
    object oItem = CreateItemOnObject(iRewardItem, oPC);
    string sTier = GetStringLeft(GetTag(oItem),5);
}

// Rewards the player with guild status
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
void RewardPlayerWithStatus(object oPC, object oNPC) {

}

//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// JOURNAL UPDATES
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

// Returns the name of the quest
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
string GetQuestName(int iQuest) {
    string sQuest;
    switch (iQuest) {
    case QUEST_FRIAMMIRRI:      sQuest = "Friam and Mirri"; break;
    case QUEST_WHEATON_MILL:    sQuest = "Wheaton Mill"; break;
    case QUEST_TINNELY:         sQuest = "Tinnely"; break;
    case QUEST_DISAPPEARANCES:  sQuest = "Disappearances"; break;
    case QUEST_DELORFIN:        sQuest = "Missing Brother"; break;
    case QUEST_ORDEAL:          sQuest = "Monks Ordeal"; break;
    case QUEST_SPYQUEST:        sQuest = "Spy in the Eye"; break;
    case QUEST_DUERGAR:         sQuest = "Duergars"; break;
    case QUEST_DROWQUEST:       sQuest = "Drow mission"; break;
    case QUEST_DROWHEAD:        sQuest = "Drow Head"; break;
    case QUEST_MOUNTAIN_DWARF:  sQuest = "Mountain Dwarves"; break;
    case QUEST_PIXIE:           sQuest = "Pixie Isle"; break;
    case QUEST_SEFTEW:          sQuest = "Harata/seftew"; break;
    case QUEST_NAZHUN:          sQuest = "Nazhun"; break;
    case QUEST_GUARDIANS:       sQuest = "Guardians Quest"; break;
    case QUEST_WOODELVES:       sQuest = "Ancient Portal"; break;
    case QUEST_HARATA_MANONERA: sQuest = "Harata - Manonera"; break;
    case QUEST_WARRIOR_KING:    sQuest = "Warrior King"; break;
    case QUEST_LONELY:          sQuest = "Lonely Caves"; break;
    case QUEST_STORMS:          sQuest = "Isle of Storms"; break;
    case QUEST_ORKS:            sQuest = "Ork Totem"; break;
    case QUEST_DELIVERY:        sQuest = "Simple delivery"; break;
    case QUEST_BACKDOOR:        sQuest = "Outlaw message"; break;
    case QUEST_SCROLLS:         sQuest = "Scrolls of the Damned"; break;
    case QUEST_MINERS:          sQuest = "Miners"; break;
    case QUEST_EXPLORE:         sQuest = "Manonera Exploration"; break;
    case QUEST_METTLE:          sQuest = "Exile 1"; break;
    case QUEST_FURNACE:         sQuest = "Exile 2"; break;
    case QUEST_RESSES:          sQuest = "Ressurections"; break;
    case QUEST_DRAGON:          sQuest = "Fer Merchant"; break;
    case QUEST_SANTA:           sQuest = "Santa"; break;
    case QUEST_OUKPRIS:         sQuest = "Oukrata Prisoners"; break;
    case QUEST_ISLEOFICE:       sQuest = "Isle of Ice"; break;
    case QUEST_ASABIATS:        sQuest = "Asabiats"; break;
    case QUEST_DRACOLICH:       sQuest = "Hetep'Ka"; break;
    case QUEST_TWINS:           sQuest = "Twins"; break;
    case QUEST_UNCLE_SID:       sQuest = "Uncle Sid"; break;
    case QUEST_BALANCE:         sQuest = "Balance"; break;
    case QUEST_DENGAR:          sQuest = "Dengar"; break;
    case QUEST_RECIPE:          sQuest = "Recipe"; break;
    case QUEST_VARUL_EAR:       sQuest = "Varul Ear"; break;
    case QUEST_FIGHTPIT:        sQuest = "Fight Pit"; break;
    case QUEST_ARTIFACT:        sQuest = "Artifacts"; break;
    case QUEST_FARMER:          sQuest = "Wheaton Farmer"; break;
    case QUEST_SACRIFICE:       sQuest = "Sacrifice"; break;
    case QUEST_COMBINATION:     sQuest = "Kobold Secrets"; break;
    case QUEST_STALKER:         sQuest = "Something in the woods"; break;
    case QUEST_SURVIVAL:        sQuest = "Desert Survival"; break;
    case QUEST_GRINDEL:         sQuest = "Grindel Chief"; break;
    case QUEST_FINAL_ELIJAH:    sQuest = "Finale Elijah"; break;
    case QUEST_FINAL_BALANCE:   sQuest = "Finale Balance"; break;
    case QUEST_FINAL_EXILE:     sQuest = "Finale exile"; break;
    case QUEST_FINAL_DROW:      sQuest = "Finale Drow"; break;
    case QUEST_DEEPWALKER:      sQuest = "Deepwalkers"; break;
    case QUEST_DISEASE:         sQuest = "Diseased"; break;
    case QUEST_MIRRORS:         sQuest = "Hall of Mirrors"; break;
    case QUEST_PALE_SOUL:       sQuest = "Palesoul"; break;
    case QUEST_BOOKS:           sQuest = "Bookworm"; break;
    case QUEST_PTL_ELVES :      sQuest = "portal elves "; break;
    case QUEST_PTL_UD :         sQuest = "portal_ud "; break;
    case QUEST_PTL_CAEN :       sQuest = "portal_caen "; break;
    case QUEST_PTL_ICIES :      sQuest = "portal_icies "; break;
    case QUEST_PTL_VARUL :      sQuest = "portal_varul "; break;
    case QUEST_NCCULT :         sQuest = "New Caendryl "; break;
    case QUEST_WINDRACER :      sQuest = "Pirate Trouble "; break;
    case QUEST_SALIOS :         sQuest = "Strange Creatures "; break;
    case QUEST_SEND_QUEEN :     sQuest = "The Sendauntra Queen "; break;
    case QUEST_SEND_CLARESSA :  sQuest = "Finding Claressa "; break;
    case QUEST_SEND_ITEM1 :      sQuest = "Sendaunt Leg "; break;
    case QUEST_SEND_ITEM2 :      sQuest = "A Posionous Sendaunt "; break;

    default:                    sQuest = "Invalid Quest"; break;
    }

    return sQuest;
}

//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// QUEST ITEMS
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
string GetQuestItem(int iQuest, object oRewarded = OBJECT_INVALID) {
    string sTag;
    switch (iQuest) {
    case QUEST_WHEATON_MILL:    sTag = "RatHead001"; break;
    case QUEST_DELIVERY:        sTag = "ShipmentRecords"; break;
    case QUEST_DRAGON:          sTag = "IT_DRAGONTOOTH"; break;
    case QUEST_ORKS:            sTag = "rewardbag"; break;// Magic Bag -40%
    case QUEST_SCROLLS:         sTag = "IT_HARATASCROLL"; break;
    case QUEST_EXPLORE:         sTag = "it_boatslip"; break;
    case QUEST_DRACOLICH:       sTag = "IT_HETEP_STONE"; break;
    case QUEST_MOUNTAIN_DWARF:  sTag = "OgreChiefsHead"; break;
    case QUEST_MINERS:          sTag = "IT_MINEKEY"; break;
    case QUEST_DELORFIN:        sTag = "HeadofIsenduil"; break;
    case QUEST_GUARDIANS:       sTag = "DwarfTreaty"; break;
    case QUEST_DUERGAR:         sTag = "EliathiasCharm"; break;
    case QUEST_SANTA:           sTag = GenerateRewardItem(oRewarded);break;
    case QUEST_OUKPRIS:         sTag = "OukrataCellKeys"; break;
    case QUEST_PIXIE:           sTag = "FAIRY_WOOD"; break;
    case QUEST_DROWQUEST:       sTag = "DwarfCaptainsAmulet"; break;
    case QUEST_ASABIATS:        sTag = "gorgonscales"; break;
    case QUEST_TWINS:           sTag = GenerateRewardItem(oRewarded); break;
    case QUEST_UNCLE_SID:       sTag = "importantdocumen"; break;
    case QUEST_BALANCE:         sTag = "balanceaccords"; break;
    case QUEST_VARUL_EAR:       sTag = "EarMistLord"; break;
    case QUEST_FARMER:          sTag = "farmersterms"; break;
    case QUEST_SACRIFICE:       sTag = "boysskull"; break;
    case QUEST_ISLEOFICE:       sTag = GenerateRewardItem(oRewarded);break;
    case QUEST_FINAL_ELIJAH:    sTag = "ahembooks"; break;
    case QUEST_FINAL_BALANCE:   sTag = "ahembooks"; break;
    case QUEST_FINAL_EXILE:     sTag = "ahembooks"; break;
    case QUEST_FINAL_DROW:      sTag = "ahembooks"; break;
    case QUEST_DEEPWALKER:      sTag = "ratinasack"; break;
    case QUEST_MIRRORS:         sTag = "cadishmemoryd"; break;
    case QUEST_ORDEAL:          sTag = "chree_quest001"; break;
    case QUEST_SEND_QUEEN :     sTag = "cl_sendaunt_head "; break;
    case QUEST_SEND_ITEM1 :     sTag = "sendauntleg"; break;
    case QUEST_SEND_ITEM2 :     sTag = "cl_sendaunt_fang"; break;
    default: break;
    }
    return sTag;
}

void GiveQuestItem(object oPC, int iQuest) {
    string sTag = GetStringLowerCase(GetQuestItem(iQuest));
    if (sTag != "")
        CreateItemOnObject(sTag, oPC, 1);
}

void TakeQuestItem(object oPC, int iQuest) {
    string sTag = GetQuestItem(iQuest);
    object oItem = GetItemPossessedBy(oPC, sTag);
    if (oItem != OBJECT_INVALID)
        DestroyObject(oItem);
}

int HasQuestItem(object oPC, int iQuest) {
    string sTag = GetQuestItem(iQuest);
    if (GetItemPossessedBy(oPC, sTag) != OBJECT_INVALID)
        return TRUE;
    else
        return FALSE;
}

//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Updates the journal with the relevent quest
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
void UpdateJournal(object oPC, int iQuest, int iAlert = TRUE) {
    int iSetting = GetQuestInt(oPC, iQuest);

    if (iSetting == 0)
        return;

    switch (iQuest) {
        case QUEST_FRIAMMIRRI:      AddJournalQuestEntry("jFriamMirri", iSetting, oPC, FALSE, FALSE, FALSE); break;
        case QUEST_WHEATON_MILL:    AddJournalQuestEntry("jWheatonMill", iSetting, oPC, FALSE, FALSE, FALSE); break;
        case QUEST_TINNELY:         AddJournalQuestEntry("jTinnely", iSetting, oPC, FALSE, FALSE, FALSE); break;
        case QUEST_DISAPPEARANCES:  AddJournalQuestEntry("jDisappearances", iSetting, oPC, FALSE, FALSE, FALSE); break;
        case QUEST_DELORFIN:        AddJournalQuestEntry("jmissingbrother", iSetting, oPC, FALSE, FALSE, FALSE); break;
        case QUEST_ORDEAL:          AddJournalQuestEntry("jordeal", iSetting, oPC, FALSE, FALSE, FALSE); break;
        case QUEST_SPYQUEST:        AddJournalQuestEntry("jthespyintheeye", iSetting, oPC, FALSE, FALSE, FALSE); break;
        case QUEST_DUERGAR:         AddJournalQuestEntry("jDuergarAlliance", iSetting, oPC, FALSE, FALSE, FALSE); break;
        case QUEST_DROWQUEST:       AddJournalQuestEntry("jDrowAlliance", iSetting, oPC, FALSE, FALSE, FALSE); break;
        case QUEST_DROWHEAD:        AddJournalQuestEntry("jDrowHeadQuest", iSetting, oPC, FALSE, FALSE, FALSE); break;
        case QUEST_MOUNTAIN_DWARF:  AddJournalQuestEntry("jMountainDwarf", iSetting, oPC, FALSE, FALSE, FALSE); break;
        case QUEST_PIXIE:           AddJournalQuestEntry("PixieQuest", iSetting, oPC, FALSE, FALSE, FALSE); break;
        case QUEST_SEFTEW:          AddJournalQuestEntry("jHarata", iSetting, oPC, FALSE, FALSE, FALSE); break;
        case QUEST_NAZHUN:          AddJournalQuestEntry("jNazuhn", iSetting, oPC, FALSE, FALSE, FALSE); break;
        case QUEST_GUARDIANS:       AddJournalQuestEntry("jGuardian", iSetting, oPC, FALSE, FALSE, FALSE); break;
        case QUEST_WOODELVES:       AddJournalQuestEntry("jPortal", iSetting, oPC, FALSE, FALSE, FALSE); break;
        case QUEST_HARATA_MANONERA: AddJournalQuestEntry("jManonera", iSetting, oPC, FALSE, FALSE, FALSE); break;
        case QUEST_WARRIOR_KING:    AddJournalQuestEntry("jWarriorKing", iSetting, oPC, FALSE, FALSE, FALSE); break;
        case QUEST_LONELY:          AddJournalQuestEntry("jLonelyCaves", iSetting, oPC, FALSE, FALSE, FALSE); break;
        case QUEST_STORMS:          AddJournalQuestEntry("jStorms", iSetting, oPC, FALSE, FALSE, FALSE); break;
        case QUEST_ORKS:            AddJournalQuestEntry("jOrks", iSetting, oPC, FALSE, FALSE, FALSE); break;
        case QUEST_DELIVERY:        AddJournalQuestEntry("jDelivery", iSetting, oPC, FALSE, FALSE, FALSE); break;
        case QUEST_BACKDOOR:        AddJournalQuestEntry("jOutlaw", iSetting, oPC, FALSE, FALSE, FALSE); break;
        case QUEST_SCROLLS:         AddJournalQuestEntry("jScrolls", iSetting, oPC, FALSE, FALSE, FALSE); break;
        case QUEST_MINERS:          AddJournalQuestEntry("jMiners", iSetting, oPC, FALSE, FALSE, FALSE); break;
        case QUEST_EXPLORE:          AddJournalQuestEntry("jTemple", iSetting, oPC, FALSE, FALSE, FALSE); break;
        case QUEST_METTLE:          AddJournalQuestEntry("jExile", iSetting, oPC, FALSE, FALSE, FALSE); break;
        case QUEST_FURNACE:         AddJournalQuestEntry("jExile2", iSetting, oPC, FALSE, FALSE, FALSE); break;
        case QUEST_RESSES:          AddJournalQuestEntry("jResses", iSetting, oPC, FALSE, FALSE, TRUE); break;
        case QUEST_DRAGON:          AddJournalQuestEntry("jDragon", iSetting, oPC, FALSE, FALSE, FALSE); break;
        case QUEST_OUKPRIS:         AddJournalQuestEntry("jOukrataPris", iSetting, oPC, FALSE, FALSE, FALSE); break;
        case QUEST_ISLEOFICE:       AddJournalQuestEntry("jIsleofIce", iSetting, oPC, FALSE, FALSE, FALSE); break;
        case QUEST_ASABIATS:        AddJournalQuestEntry("jAsabiats", iSetting, oPC, FALSE, FALSE, FALSE); break;
        case QUEST_DRACOLICH:       AddJournalQuestEntry("jDracolich", iSetting, oPC, FALSE, FALSE, FALSE); break;
        case QUEST_TWINS:           AddJournalQuestEntry("jTwins", iSetting, oPC, FALSE, FALSE, FALSE); break;
        case QUEST_UNCLE_SID:       AddJournalQuestEntry("jUncleSid", iSetting, oPC, FALSE, FALSE, FALSE); break;
        case QUEST_BALANCE:         UpdateSigsJournal(oPC, iSetting-1); break;
        case QUEST_DENGAR:          AddJournalQuestEntry("jDengar", iSetting, oPC, FALSE, FALSE, FALSE); break;
        case QUEST_RECIPE:          AddJournalQuestEntry("jKaranga", iSetting, oPC, FALSE, FALSE, FALSE); break;
        case QUEST_VARUL_EAR:       AddJournalQuestEntry("jMistlord", iSetting, oPC, FALSE, FALSE, FALSE); break;
        case QUEST_FIGHTPIT:        AddJournalQuestEntry("jFightpit", iSetting, oPC, FALSE, FALSE, FALSE); break;
        case QUEST_ARTIFACT:        AddJournalQuestEntry("jArtifacts", iSetting, oPC, FALSE, FALSE, FALSE); break;
        case QUEST_FARMER:          AddJournalQuestEntry("jFarmer", iSetting, oPC, FALSE, FALSE, FALSE); break;
        case QUEST_SACRIFICE:       AddJournalQuestEntry("jSacrifice", iSetting, oPC, FALSE, FALSE, FALSE); break;
        case QUEST_COMBINATION:     AddJournalQuestEntry("jCombination", iSetting, oPC, FALSE, FALSE, FALSE); break;
        case QUEST_STALKER:         AddJournalQuestEntry("jStalker", iSetting, oPC, FALSE, FALSE, FALSE); break;
        case QUEST_SURVIVAL:        AddJournalQuestEntry("jSurvival", iSetting, oPC, FALSE, FALSE, FALSE); break;
        case QUEST_GRINDEL:         AddJournalQuestEntry("jGrindel", iSetting, oPC, FALSE, FALSE, FALSE); break;
        case QUEST_FINAL_ELIJAH:    AddJournalQuestEntry("jFElijah", iSetting, oPC, FALSE, FALSE, FALSE); break;
        case QUEST_FINAL_BALANCE:   AddJournalQuestEntry("jFBalance", iSetting, oPC, FALSE, FALSE, FALSE); break;
        case QUEST_FINAL_EXILE:     AddJournalQuestEntry("jFExile", iSetting, oPC, FALSE, FALSE, FALSE); break;
        case QUEST_FINAL_DROW:      AddJournalQuestEntry("jFDrow", iSetting, oPC, FALSE, FALSE, FALSE); break;
        case QUEST_DEEPWALKER:      AddJournalQuestEntry("jDeepwalker", iSetting, oPC, FALSE, FALSE, FALSE); break;
        case QUEST_DISEASE:         AddJournalQuestEntry("jDisease", iSetting, oPC, FALSE, FALSE, FALSE); break;
        case QUEST_MIRRORS:         AddJournalQuestEntry("jMirrors", iSetting, oPC, FALSE, FALSE, FALSE); break;
        case QUEST_PALE_SOUL:       AddJournalQuestEntry("jPaleSoul", iSetting, oPC, FALSE, FALSE, FALSE); break;
        case QUEST_BOOKS:           AddJournalQuestEntry("jBooks", iSetting, oPC, FALSE, FALSE, FALSE); break;
        case QUEST_PTL_ELVES :      AddJournalQuestEntry("jprtelves" , iSetting, oPC, FALSE, FALSE, FALSE); break;
        case QUEST_PTL_UD :         AddJournalQuestEntry("jprtud" , iSetting, oPC, FALSE, FALSE, FALSE); break;
        case QUEST_PTL_CAEN :       AddJournalQuestEntry("jprtcaen" , iSetting, oPC, FALSE, FALSE, FALSE); break;
        case QUEST_PTL_ICIES :      AddJournalQuestEntry("jprticies" , iSetting, oPC, FALSE, FALSE, FALSE); break;
        case QUEST_PTL_VARUL :      AddJournalQuestEntry("jprtvarul" , iSetting, oPC, FALSE, FALSE, FALSE); break;
        case QUEST_NCCULT :         AddJournalQuestEntry("jNewCaen" , iSetting, oPC, FALSE, FALSE, FALSE); break;
        case QUEST_WINDRACER :      AddJournalQuestEntry("jPirates" , iSetting, oPC, FALSE, FALSE, FALSE); break;
        case QUEST_SALIOS :         AddJournalQuestEntry("jSalios" , iSetting, oPC, FALSE, FALSE, FALSE); break;
        case QUEST_SEND_QUEEN :     AddJournalQuestEntry("jSendauntra1" , iSetting, oPC, FALSE, FALSE, FALSE); break;
        case QUEST_SEND_CLARESSA :  AddJournalQuestEntry("jSendauntra2" , iSetting, oPC, FALSE, FALSE, FALSE); break;
        case QUEST_SEND_ITEM1 :     AddJournalQuestEntry("jSendauntra3" , iSetting, oPC, FALSE, FALSE, FALSE); break;
        case QUEST_SEND_ITEM2 :     AddJournalQuestEntry("jSendauntra4" , iSetting, oPC, FALSE, FALSE, FALSE); break;
        default:
        // Nothing to do
        break;
    }
    // Tell the player they got an update
    if (iAlert){
        FloatingTextStringOnCreature("**Your Journal has been updated**", oPC, FALSE);
        SetPanelButtonFlash(oPC, PANEL_BUTTON_JOURNAL, TRUE);
    }
}

//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// Updates the journal with the relevent quests, and allow them to overwrite higher levels.
// For use with DM wands when adjusting quests.
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
void UpdateJournalRetroactive(object oPC, int iQuest, int iAlert = TRUE) {
    int iSetting = GetQuestInt(oPC, iQuest);
    string sQuest;
    switch (iQuest) {
        case QUEST_FRIAMMIRRI:      sQuest = "jFriamMirri"; break;
        case QUEST_WHEATON_MILL:    sQuest = "jWheatonMill"; break;
        case QUEST_TINNELY:         sQuest = "jTinnely"; break;
        case QUEST_DISAPPEARANCES:  sQuest = "jDisappearances"; break;
        case QUEST_DELORFIN:        sQuest = "jmissingbrother"; break;
        case QUEST_ORDEAL:          sQuest = "jordeal"; break;
        case QUEST_SPYQUEST:        sQuest = "jthespyintheeye"; break;
        case QUEST_DUERGAR:         sQuest = "jDuergarAlliance"; break;
        case QUEST_DROWQUEST:       sQuest = "jDrowAlliance"; break;
        case QUEST_DROWHEAD:        sQuest = "jDrowHeadQuest"; break;
        case QUEST_MOUNTAIN_DWARF:  sQuest = "jMountainDwarf"; break;
        case QUEST_PIXIE:           sQuest = "PixieQuest"; break;
        case QUEST_SEFTEW:          sQuest = "jHarata"; break;
        case QUEST_NAZHUN:          sQuest = "jNazuhn"; break;
        case QUEST_GUARDIANS:       sQuest = "jGuardian"; break;
        case QUEST_WOODELVES:       sQuest = "jPortal"; break;
        case QUEST_DRACOLICH:       sQuest = "jManonera"; break;
        case QUEST_WARRIOR_KING:    sQuest = "jWarriorKing"; break;
        case QUEST_LONELY:          sQuest = "jLonelyCaves"; break;
        case QUEST_STORMS:          sQuest = "jStorms"; break;
        case QUEST_ORKS:            sQuest = "jOrks"; break;
        case QUEST_DELIVERY:        sQuest = "jDelivery"; break;
        case QUEST_BACKDOOR:        sQuest = "jOutlaw"; break;
        case QUEST_SCROLLS:         sQuest = "jScrolls"; break;
        case QUEST_MINERS:          sQuest = "jMiners"; break;
        case QUEST_EXPLORE:         sQuest = "jTemple"; break;
        case QUEST_METTLE:          sQuest = "jExile"; break;
        case QUEST_FURNACE:         sQuest = "jExile2"; break;
        case QUEST_RESSES:          sQuest = "jResses"; break;
        case QUEST_DRAGON:          sQuest = "jDragon"; break;
        case QUEST_OUKPRIS:         sQuest = "jOukrataPris"; break;
        case QUEST_ISLEOFICE:       sQuest = "jIsleofIce"; break;
        case QUEST_TWINS:           sQuest = "jTwins"; break;
        case QUEST_UNCLE_SID:       sQuest = "jUncleSid"; break;
        case QUEST_BALANCE:         UpdateSigsJournal(oPC, iSetting-1); break;
        case QUEST_DENGAR:          sQuest = "jDengar"; break;
        case QUEST_RECIPE:          sQuest = "jKaranga"; break;
        case QUEST_VARUL_EAR:       sQuest = "jMistlord"; break;
        case QUEST_FIGHTPIT:        sQuest = "jFightpit"; break;
        case QUEST_ARTIFACT:        sQuest = "jArtifacts"; break;
        case QUEST_FARMER:          sQuest = "jFarmer"; break;
        case QUEST_SACRIFICE:       sQuest = "jSacrifice"; break;
        case QUEST_COMBINATION:     sQuest = "jCombination"; break;
        case QUEST_STALKER:         sQuest = "jStalker"; break;
        case QUEST_SURVIVAL:        sQuest = "jSurvival"; break;
        case QUEST_GRINDEL:         sQuest = "jGrindel"; break;
        case QUEST_FINAL_ELIJAH:    sQuest = "jFElijah"; break;
        case QUEST_FINAL_BALANCE:   sQuest = "jFBalance"; break;
        case QUEST_FINAL_EXILE:     sQuest = "jFExile" ; break;
        case QUEST_FINAL_DROW:      sQuest = "jFDrow"; break;
        case QUEST_DEEPWALKER:      sQuest = "jDeepwalker"; break;
        case QUEST_DISEASE:         sQuest = "jDisease"; break;
        case QUEST_MIRRORS:         sQuest = "jMirrors"; break;
        case QUEST_PALE_SOUL:       sQuest = "jPaleSoul"; break;
        case QUEST_BOOKS:           sQuest = "jBooks"; break;
        case  QUEST_PTL_ELVES:      sQuest = "jprtelves"; break;
        case  QUEST_PTL_UD:         sQuest = "jprtud"; break;
        case  QUEST_PTL_CAEN:       sQuest = "jprtcaen"; break;
        case  QUEST_PTL_ICIES:      sQuest = "jprticies"; break;
        case  QUEST_PTL_VARUL:      sQuest = "jprtvarul"; break;
        case QUEST_NCCULT :         sQuest = "jNewCaen" ; break;
        case QUEST_WINDRACER :      sQuest = "jPirates"; break;
        case QUEST_SALIOS :         sQuest = "jSalios"; break;
        case QUEST_SEND_QUEEN :     sQuest = "jSendauntra1"; break;
        case QUEST_SEND_CLARESSA :  sQuest = "jSendauntra2"; break;
        case QUEST_SEND_ITEM1 :     sQuest = "jSendauntra3"; break;
        case QUEST_SEND_ITEM2 :     sQuest = "jSendauntra4"; break;

        default:
        // Nothing to do
        break;
    }
    if (iSetting == 0) {
        RemoveJournalQuestEntry(sQuest, oPC, FALSE);
    }
    else if (sQuest != "")
        AddJournalQuestEntry(sQuest, iSetting, oPC, FALSE, FALSE, TRUE);


    // Tell the player they got an update
    if (iAlert){
        FloatingTextStringOnCreature("**Your Journal has been updated**", oPC, FALSE);
        SetPanelButtonFlash(oPC, PANEL_BUTTON_JOURNAL, TRUE);
    }
}
// The full function used to update every quest retroactively
void UpdateAllJournalRetroactive(object oPC){
    object oPC = OBJECT_SELF;
    int iQuest = 0;

    while (iQuest <= MAX_QUESTS) {
        iQuest++;
        UpdateJournalRetroactive(oPC, iQuest, FALSE);
    }
    FloatingTextStringOnCreature("** Your Journal has been updated **", oPC);
    SetPanelButtonFlash(oPC, PANEL_BUTTON_JOURNAL, TRUE);
}

// Updates the Journal for the Kill Quest
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
void UpdateJournalKillQuest(object oPC) {
    int iKQStatus = GetLocalInt(oPC, QUEST_KILLQUEST);
    if (iKQStatus > 0) {
        switch (iKQStatus) {
        case 100000: AddJournalQuestEntry("jKillQuest", 1, oPC, FALSE, FALSE, FALSE); break;
        case 110000: AddJournalQuestEntry("jKillQuest", 2, oPC, FALSE, FALSE, FALSE); break;
        case 101000: AddJournalQuestEntry("jKillQuest", 3, oPC, FALSE, FALSE, FALSE); break;
        case 100100: AddJournalQuestEntry("jKillQuest", 4, oPC, FALSE, FALSE, FALSE); break;
        case 111000: AddJournalQuestEntry("jKillQuest", 5, oPC, FALSE, FALSE, FALSE); break;
        case 110100: AddJournalQuestEntry("jKillQuest", 6, oPC, FALSE, FALSE, FALSE); break;
        case 101100: AddJournalQuestEntry("jKillQuest", 7, oPC, FALSE, FALSE, FALSE); break;
        case 111100: AddJournalQuestEntry("jKillQuest", 8, oPC, FALSE, FALSE, FALSE); break;
        case 211100: AddJournalQuestEntry("jKillQuest", 9, oPC, FALSE, FALSE, FALSE); break;
        case 211110: AddJournalQuestEntry("jKillQuest", 10, oPC, FALSE, FALSE, FALSE); break;
        case 211101: AddJournalQuestEntry("jKillQuest", 11, oPC, FALSE, FALSE, FALSE); break;
        case 311111: AddJournalQuestEntry("jKillQuest", 12, oPC, FALSE, FALSE, FALSE); break;
        }
    }
    int iExtendStatus = (GetLocalInt(oPC, QUEST_EXTENDQUEST));
    if (iExtendStatus > 0) {
        switch (iExtendStatus) {
        case 1000: AddJournalQuestEntry("jExtendQuest", 1, oPC, FALSE, FALSE, FALSE); break;
        case 1100: AddJournalQuestEntry("jExtendQuest", 2, oPC, FALSE, FALSE, FALSE); break;
        case 1010: AddJournalQuestEntry("jExtendQuest", 3, oPC, FALSE, FALSE, FALSE); break;
        case 1001: AddJournalQuestEntry("jExtendQuest", 4, oPC, FALSE, FALSE, FALSE); break;
        case 1110: AddJournalQuestEntry("jExtendQuest", 5, oPC, FALSE, FALSE, FALSE); break;
        case 1101: AddJournalQuestEntry("jExtendQuest", 6, oPC, FALSE, FALSE, FALSE); break;
        case 1011: AddJournalQuestEntry("jExtendQuest", 7, oPC, FALSE, FALSE, FALSE); break;
        case 1111: AddJournalQuestEntry("jExtendQuest", 8, oPC, FALSE, FALSE, FALSE); break;
        }
    }
}

string GenerateRewardItem(object oPC, int iList =0){
    return "sResRef";
}

void UpdateSigsJournal(object oPC, int iNumSigs) {

    // string sSigs = GetDBString(oPC, QUEST_SIGS);
    // if("" == sSigs){
    //     sSigs = "000000"; //Init the signatures
    //     SaveDBString(oPC, QUEST_SIGS, sSigs);
    //     SetLocalString(oPC, QUEST_SIGS, sSigs);
    // }
    // //try just reading dbase directly, dirion
    // //sSigs = GetLocalString(oPC, QUEST_SIGS);
    // //if (sSigs == "") {
    //     //sSigs = GetDBString(oPC, QUEST_SIGS);
    //    // SetLocalString(oPC, QUEST_SIGS, QUEST_SIGS;
    // //}
    // //SendMessageToAllDMs("Sigs = " + sSigs);
    // int nCount = 1;
    // int nSigs = 1;
    // string sCount = GetSubString(sSigs, nCount-1, 1);
    // while ((nCount <= 6) && (nSigs <= iNumSigs)) {
    //     if (sCount == "1") {
    //         switch (nCount) {
    //             case 1: SetCustomToken(500 + nSigs, "Sojan Hawkfeather"); break;
    //             case 2: SetCustomToken(500 + nSigs, "Kasil Maile"); break;
    //             case 3: SetCustomToken(500 + nSigs, "Brother Kalerac"); break;
    //             case 4: SetCustomToken(500 + nSigs, "Dr. Veit"); break;
    //             case 5: SetCustomToken(500 + nSigs, "Chiana Delen"); break;
    //             case 6: SetCustomToken(500 + nSigs, "Dram"); break;
    //         }
    //         nSigs++;
    //     }
    //     nCount++;
    //     sCount = GetSubString(sSigs, nCount-1, 1);
    // }
    // AddJournalQuestEntry("jBalance", iNumSigs+1, oPC, FALSE, FALSE, TRUE);
}
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
// QUEST REWARDS
// Orion3T
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

// Gives a full quest reward of XP, Gold and an item. For use on full completion of quest.
// Reward is based on the player level and quest difficulty
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
void RewardPlayerFinal(object oPC, int iQuest, int iGiveXP=TRUE, int iGiveGold=TRUE, int iGiveRep=FALSE, int iGiveItem=FALSE) {
    int iReward;
    int iDifficulty;
    int iLevel = GetHitDice(oPC);
    //SendMessageToAllDMs("Quest #" + IntToString(iQuest));
    // Set the difficulty for the quest - set to the recommended level for completion
    // Set the rewards (XP, Gold, Rep, Item)
    switch (iQuest) {
        case QUEST_WHEATON_MILL     : iDifficulty = 4; break;
        case QUEST_TINNELY          : iDifficulty = 10; iGiveGold = FALSE; break;
        case QUEST_FRIAMMIRRI       : iDifficulty = 8; iGiveGold = FALSE; iGiveItem = TRUE; break;
        case QUEST_DISAPPEARANCES   : iDifficulty = 13; iGiveItem = TRUE; break;
        case QUEST_DELORFIN         : iDifficulty = 12; iGiveGold = FALSE; iGiveItem = TRUE; break;
        case QUEST_ORDEAL           : iDifficulty = 15; break;
        case QUEST_SPYQUEST         : iDifficulty = 13; iGiveGold = FALSE; break;
        case QUEST_DUERGAR          : iDifficulty = 15; break;
        case QUEST_DROWQUEST        : iDifficulty = 16; break;
        case QUEST_DROWHEAD         : iDifficulty = 20; break;
        case QUEST_MOUNTAIN_DWARF   : iDifficulty = 14; break;
        case QUEST_PIXIE            : iDifficulty = 5; break;
        case QUEST_SEFTEW           : iDifficulty = 27; break;
        case QUEST_NAZHUN           : iDifficulty = 22; break;
        case QUEST_GUARDIANS        : iDifficulty = 18; iGiveRep = TRUE; break;
        case QUEST_WOODELVES        : iDifficulty = 23; break;
        case QUEST_WARRIOR_KING     : iDifficulty = 37; iGiveGold = FALSE; iGiveRep = TRUE; break;
        case QUEST_LONELY           : iDifficulty = 12; break;
        case QUEST_STORMS           : iDifficulty = 27; break;
        case QUEST_ORKS             : iDifficulty = 15;  break;
        case QUEST_DELIVERY         : iDifficulty = 7; break;
        case QUEST_BACKDOOR         : iDifficulty = 10; iGiveRep = TRUE; break;
        case QUEST_SCROLLS          : iDifficulty = 26; iGiveItem = TRUE; break;
        case QUEST_MINERS           : iDifficulty = 15; break;
        case QUEST_EXPLORE          : iDifficulty = 33; iGiveGold = FALSE; break;
        case QUEST_METTLE           : iDifficulty = 16; iGiveRep = TRUE; break;
        case QUEST_FURNACE          : iDifficulty = 16; iGiveRep = TRUE; break;
        // case QUEST_DREAMS :
        case QUEST_ISLEOFICE        : iDifficulty = 37; iGiveItem = TRUE; break;
        case QUEST_HARATA_MANONERA  : iDifficulty = 28; iGiveGold = FALSE; break;
        case QUEST_DRAGON           : iDifficulty = 20; break;
        case QUEST_OUKPRIS          : iDifficulty = 28; iGiveGold = FALSE; break;
        case QUEST_ASABIATS         : iDifficulty = 24; break;
        case QUEST_DRACOLICH        : iDifficulty = 24; iGiveGold = FALSE; break;
        case QUEST_TWINS            : iDifficulty = 9; break;
        case QUEST_BALANCE          : iDifficulty = 22; break;
        case QUEST_RECIPE           : iDifficulty = 30; break;//final reward is for the extension in the open desert.(dirion sept 07)
        case QUEST_VARUL_EAR        : iDifficulty = 23; break;
        case QUEST_ARTIFACT         : iDifficulty = 30; iGiveGold = FALSE; break;
        case QUEST_FARMER           : iDifficulty = 6; iGiveGold = FALSE; break;
        case QUEST_SACRIFICE        : iDifficulty = 22; iGiveGold = FALSE; break;
        case QUEST_COMBINATION      : iDifficulty = 32; iGiveGold = FALSE; break;
        case QUEST_STALKER          : iDifficulty = 13; iGiveGold = FALSE; iGiveItem = TRUE; break;
        case QUEST_SURVIVAL         : iDifficulty = 31; break;
        case QUEST_GRINDEL          : iDifficulty = 22; break;
        case QUEST_FINAL_ELIJAH     : iDifficulty = 40; iGiveGold = FALSE;break;
        case QUEST_FINAL_BALANCE    : iDifficulty = 40; iGiveGold = FALSE;break;
        case QUEST_FINAL_EXILE      : iDifficulty = 40; iGiveGold = FALSE;break;
        case QUEST_FINAL_DROW       : iDifficulty = 40; iGiveGold = FALSE;break;
        case QUEST_DEEPWALKER       : iDifficulty = 34;break;
        case QUEST_BOOKS            : iDifficulty = 11; iGiveGold = FALSE;break;

        case QUEST_DISEASE          : iDifficulty = 1;iGiveGold = FALSE; iGiveXP = FALSE; break;
        case QUEST_MIRRORS          : iDifficulty = 32;iGiveGold = FALSE;GiveGoldToCreature(oPC, 25000);break;
        case QUEST_PALE_SOUL        : iDifficulty = 26; break;
        case QUEST_NCCULT           : iDifficulty = 35; break;
        case QUEST_WINDRACER        : iDifficulty = 34;iGiveGold = FALSE; break;
        case 97                     : iDifficulty = 14; break;  //special setting for head quest first head
        case 98                     : iDifficulty = 16; break;  //special setting for head quest second head
        case 99                     : iDifficulty = 17; break;  //special setting for head quest final head
        default                     : iDifficulty = 10;
        case QUEST_SEND_QUEEN       : iDifficulty = 38; break;
        case QUEST_SEND_CLARESSA    : iDifficulty = 35; break;
        case QUEST_SEND_ITEM1       : iDifficulty = 36; break;
        case QUEST_SEND_ITEM2       : iDifficulty = 37; break;
                                        SendMessageToAllDMs("Invalid quest reward: Quest#" + IntToString(iQuest));
                                        break;
    }
    //SendMessageToAllDMs("Difficulty = " + IntToString(iDifficulty));
    // Give Gold - standard 200 gold per level of difficulty
    if (iGiveGold == TRUE) {
        int iGoldAmount = iDifficulty * 200;
        GiveGoldToCreature(oPC, iGoldAmount);
    }

    if (iGiveXP == TRUE) {
        iReward = CalcXPReward(iDifficulty, iLevel);
        //SendMessageToAllDMs("XP Awarded:" + GetName(oPC) + IntToString(iReward));
        GiveXPToCreature(oPC, iReward);
    }
    // Guild Rep reward
    // Only NPCs will give Rep. If its completed via trigger etc then no rep can be awarded.
    if (GetObjectType(OBJECT_SELF) != OBJECT_TYPE_CREATURE)
        iGiveRep = FALSE;
    // Guild rep - check the NPC has a guild.
    int iNPCGuild = GetLocalInt(OBJECT_SELF, "guild_id");
    if ((iGiveRep == TRUE) && (iNPCGuild > 0)) {
        // Only reward if the PC is actually in the right guild
        int iPlayerGuild = GetLocalInt(oPC, "guild_id");
        if (iPlayerGuild == iNPCGuild) {
            // IncreaseGuildRep(oPC, OBJECT_SELF, iReward);
            SendMessageToPC(oPC, "You have received " + IntToString(iReward) + " reputation with your guild");
        }
    }
    // Item reward (set string "reward_item" on NPC)
    if (iGiveItem == TRUE)
        RewardPlayerItem(oPC);
    // Save the character
    // Save3TCharacter(oPC);
}
// Calculate xp reward based on difficulty and level
int CalcXPReward (int iDifficulty , int iLevel){
    int iReward;
    float fBaseValue = IntToFloat(iDifficulty * 200);
    int iDiff = iDifficulty - iLevel;
    float fReward;
    if(iDiff < -6) iDiff = -7; // ensures a minimum xp reward

    switch (iDiff) {
        case -7:  fReward = fBaseValue / 10.0; break;
        case -6:  fReward = fBaseValue / 5.0; break;
        case -5:  fReward = fBaseValue / 3.0; break;
        case -4:  fReward = fBaseValue / 2.0; break;
        case -3:  fReward = fBaseValue / 1.4; break;
        case -2:  fReward = fBaseValue / 1.2; break;
        case -1:  fReward = fBaseValue / 1.1; break;
        case  0:  fReward = fBaseValue; break;
        case  1:  fReward = fBaseValue / 0.9; break;
        case  2:  fReward = fBaseValue / 0.8; break;
        case  3:  fReward = fBaseValue / 0.75; break;
        case  4:  fReward = fBaseValue / 0.71; break;
        case  5:  fReward = fBaseValue / 0.67; break;
        default:  fReward = fBaseValue / 0.65; break;
    }

    iReward = FloatToInt(fReward);
    return iReward;
}

int CountArtifacts(object oPC) {
    int nCount = 0;
    string sResRef;

    if (GetItemPossessedBy(oPC, "it_artifact_1") != OBJECT_INVALID)
        nCount++;
    if (GetItemPossessedBy(oPC, "it_artifact_2") != OBJECT_INVALID)
        nCount++;
    if (GetItemPossessedBy(oPC, "it_artifact_3") != OBJECT_INVALID)
        nCount++;
    if (GetItemPossessedBy(oPC, "it_artifact_4") != OBJECT_INVALID)
        nCount++;
    if (GetItemPossessedBy(oPC, "it_artifact_5") != OBJECT_INVALID)
        nCount++;
    if (GetItemPossessedBy(oPC, "it_artifact_6") != OBJECT_INVALID)
        nCount++;

    return nCount;
}

object FindDuplicateArtifact(object oPC) {
    int nCount = 0;
    string sResRef;
    object oCurr = GetFirstItemInInventory(oPC);
    object oItem1;
    object oItem2;
    object oItem3;
    object oItem4;
    object oItem5;
    object oItem6;
    while (oCurr !=OBJECT_INVALID){
        if ( GetTag(oCurr) =="it_artifact_1"){
            if (oItem1 != OBJECT_INVALID){
                //found duplicate
                SetCustomToken(850,GetName(oCurr));
                return oCurr;
            }else {
                oItem1 = oCurr;
            }
        }
        if ( GetTag(oCurr) =="it_artifact_2"){
            if (oItem2 != OBJECT_INVALID){
                //found duplicate
                SetCustomToken(850,GetName(oCurr));
                return oCurr;
            }else {
                oItem2 = oCurr;
            }
        }
        if ( GetTag(oCurr) =="it_artifact_3"){
            if (oItem3 != OBJECT_INVALID){
                //found duplicate
                SetCustomToken(850,GetName(oCurr));
                return oCurr;
            }else {
                oItem3 = oCurr;
            }
        }
        if ( GetTag(oCurr) =="it_artifact_4"){
            if (oItem4 != OBJECT_INVALID){
                //found duplicate
                SetCustomToken(850,GetName(oCurr));
                return oCurr;
            }else {
                oItem4 = oCurr;
            }
        }
        if ( GetTag(oCurr) =="it_artifact_5"){
            if (oItem5 != OBJECT_INVALID){
                //found duplicate
                SetCustomToken(850,GetName(oCurr));
                return oCurr;
            }else {
                oItem5 = oCurr;
            }
        }
        if ( GetTag(oCurr) =="it_artifact_6"){
            if (oItem6 != OBJECT_INVALID){
                //found duplicate
                SetCustomToken(850,GetName(oCurr));
                return oCurr;
            }else {
                oItem6 = oCurr;
            }
        }
        oCurr= GetNextItemInInventory(oPC);
    }
    return oCurr;
}

void ChkPortalQuest(object oPC,int iQuestSetting){

int iSet = iQuestSetting;
 // update from strange figure
    if(iSet == 1 && GetQuestInt(oPC, 61)==2)
        {
             SetQuestInt (oPC, 17, 3);
             UpdateJournal(oPC, QUEST_WOODELVES);
             SetQuestInt(oPC, 61,3);
             UpdateJournal(oPC, 61);
        }
       if(iSet == 1 && GetQuestInt(oPC, 61)==1)
        {
             SetQuestInt (oPC, 17, 2);
             UpdateJournal(oPC, QUEST_WOODELVES);
             SetQuestInt(oPC, 61,3);
             UpdateJournal(oPC, 61);
        }
    // update from shapechanger
        if(iSet == 3 && GetQuestInt( oPC, QUEST_PTL_UD)==1){
             SetQuestInt(oPC, QUEST_WOODELVES, 4);
             UpdateJournal(oPC, QUEST_WOODELVES);
             SetQuestInt(oPC, QUEST_PTL_UD,2);
             UpdateJournal(oPC, QUEST_PTL_UD);

        }
    // update from Hounaste
        if(iSet == 4 && GetQuestInt( oPC, QUEST_PTL_CAEN)==2){
             SetQuestInt(oPC, QUEST_WOODELVES, 6);
             UpdateJournal(oPC, QUEST_WOODELVES);
             SetQuestInt(oPC, QUEST_PTL_CAEN,3);
             UpdateJournal(oPC, QUEST_PTL_CAEN);
        }
    // update from Caen or talk to ledric
        if((iSet == 6 || iSet == 7) && GetQuestInt( oPC, QUEST_PTL_ICIES)==1){
             SetQuestInt(oPC, QUEST_WOODELVES, 8);
             UpdateJournal(oPC, QUEST_WOODELVES);
             DestroyObject(GetItemPossessedBy(oPC, "it_magicalshard1"));
             DestroyObject(GetItemPossessedBy(oPC, "it_magicalshard2"));
             DestroyObject(GetItemPossessedBy(oPC, "it_magicalshard3"));
             CreateItemOnObject("it_magicalorb", oPC, 1);
             SetQuestInt(oPC, QUEST_PTL_ICIES,2);
             UpdateJournal(oPC, QUEST_PTL_ICIES);
        }
    // update from Icies
        if(iSet == 8 && GetQuestInt( oPC, QUEST_PTL_VARUL)==1){
             SetQuestInt(oPC, QUEST_WOODELVES, 9);
             UpdateJournal(oPC, QUEST_WOODELVES);
             SetQuestInt(oPC, QUEST_PTL_VARUL,2);
             UpdateJournal(oPC, QUEST_PTL_VARUL);
        }
}

/*
int KillQuest used to track status of the "kill the local villains" quests -
    ABCDEF where 0 = section not given or unkilled, 1 = given or rewarded
        A = track overall quest status (0 = no quest, 1 = quest active,
            2 = second part of quest active, 3 = finished)
        B = track bandit boss status
        C = track ssuluthass status
        D = track blackwood goblin chief status
        E = track orc captain status
        F = track iron brotherhood captain status
    Quest runs from 000000 to 311111 (all steps complete, rewards given)
int FriamMirri used to track status of the "Friam and Mirri" quest -
    0 = no quest, 1 = received quest from Mirri, 2 = received quest from Friam,
    3 = received from Mirri and met Friam, 4 = quest completed
int Tinnely used to track status of the "Tinnely is Missing" quest -
    0 = no quest, 1 = received quest from Jack Conroy, 2 = received quest from Friam,
    3 = received from Jack and met Friam, 4 = quest completed
int Disappearances used to track the Uhlek kidnap quest -
    0 = no quest, 1 = received quest from Sojan, 2 = talked to Thelonious but did not
    get more data, 3 = got full data from Thelonious, 4 = got full data and talked to
    a monk, 5 = got full data and talked to mage, 6 = got full data and talked to a monk
    and a mage, 7 = got information from the Uhlek prisoners, 8 = completed quest
int SpyQuest used to determing the Spy in the Eye quest -
    0 = no quest, 1 = talked to Richal in Fer, 2 = talked to the mole, 3 = quest completed
    but no reward, 4 = rewarded, 5 = rewarded and chose merchant discounts
int Ordeal used to track the Ten Dragons ordeal, 0 = no quest, 1 = knows about quest,
    2 = completed
*/
