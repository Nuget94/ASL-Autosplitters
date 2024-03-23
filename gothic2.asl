//////////////////////////////////////////////////////////////
/*              Autosplitter for Gothic 2  v.7              */
//////////////////////////////////////////////////////////////
/*                                                          */
/*Based on the Autosplitter by thekovic                     */
/*Improved by Jaffras for Notr Any%                         */
/*Improved by Nuget94 for Classic                           */
/*                                                          */
/*Provides for all Game Version a simple InGameTimer        */
/*Provides splitting for Night of the Raven                 */
/*To enable Notr splitting enable notrAnyPercent setting    */
/*Provides splitting for G2 Classic                         */
/*To enable Classic splitting enable ClassicSplits setting  */
//////////////////////////////////////////////////////////////


state("GothicMod", "v1.30") 
{
	long inGameTime:	"ZSPEEDRUNTIMER.DLL", 0x1A048;
}
state("Gothic", "v1.12") 
{
	long inGameTime:	"ZSPEEDRUNTIMER.DLL", 0x19F08;
}
state("GothicMod", "v1.12") 
{
	long inGameTime:	"ZSPEEDRUNTIMER.DLL", 0x19F08;
}
state("Gothic2", "v2.6") 
{

	long inGameTime:	"ZSPEEDRUNTIMER.DLL", 0x19FE0;
	int fireDragon:	    "Gothic2.exe",        0x006B40D8, 0x9128, 0xE64;
	int rockDragon:	    "Gothic2.exe",        0x006B40D8, 0x9128, 0xEA0;
	int swampDragon:    "Gothic2.exe",        0x006B40D8, 0x9128, 0xEDC;
	int iceDragon:	    "Gothic2.exe",        0x006B40D8, 0x9128, 0xE28;
	int world:		    "Gothic2.exe",        0x004CECC0, 0x920;
	int dialogue:	    "Gothic2.exe",        0x004D11B0;
	int bed:		    "Gothic2.exe",        0x006AC498;
}
state("Gothic2", "v1.30") 
{
	long inGameTime:	    "ZSPEEDRUNTIMER.DLL", 0x19F70;
	int chapter: 		    "Gothic2.exe",        0x00584C20,   0x2700, 0x9B4;
    int guild:              "Gothic2.exe",        0x004C0664,   0x21C;
    int world:              "Gothic2.exe",        0x004C0664,   0xB8,   0x91C;
    int zurisHealth:        "Gothic2.exe",        0x004C6334,   0xDBC,  0x8,    0x1A4;
    byte undeadDragonDied:  "Gothic2.exe",        0x0057D830;
    int gold:	            "Gothic2.exe",        0x004C0664,   0x68C,  0x8,    0x4,    0x318;
}
state("Gothic2Classic") 
{
	long inGameTime:	"ZSPEEDRUNTIMER.DLL", 0x19F70;
}


init
{
	if (modules.First().ModuleMemorySize == 7675904)
    {
		version = "v2.6";
    }
	else if (modules.First().ModuleMemorySize == 7061504)
    {
		version = "v1.12";
    }
	else
    {
		version = "v1.30";
    }
}

isLoading { return true; }

gameTime { return TimeSpan.FromMilliseconds(current.inGameTime / 1000); }

startup 
{
    // Notr Any% Split Settings	
    //			Settings Name						BoolValue	Description									ParentFlag/Setting
    settings.Add("notrAnyPercent"					, false	, "NotR Any% Splits (Experimental)"			    					);
    settings.Add("splitZuris"						, true	, "Split on talking to Zuris"				    , "notrAnyPercent"	);
    settings.Add("splitEnterValley"					, true	, "Split on entering Valley of Mines"		    , "notrAnyPercent"	);
    settings.Add("splitFireDragon"					, true	, "Split on killing Fire Dragon"			    , "notrAnyPercent"	);
    settings.Add("splitRockDragon"					, true	, "Split on killing Rock Dragon"			    , "notrAnyPercent"	);
    settings.Add("splitSwampDragon"					, true	, "Split on killing Swamp Dragon"			    , "notrAnyPercent"	);
    settings.Add("splitIceDragon"					, false	, "Split on killing Ice Dragon"				    , "notrAnyPercent"	);
    settings.Add("splitLeaveValley"					, true	, "Split on leaving Valley of Mines"		    , "notrAnyPercent"	);
    settings.Add("splitIrdorath"					, true	, "Split on entering Irdorath"				    , "notrAnyPercent"	);
    settings.Add("splitUndeadDragon"				, false	, "Split on killing Undead Dragon"			    , "notrAnyPercent"	);

    // Classic Split Settings   
    //			Settings Name						BoolValue	Description								    	ParentFlag/Setting
    settings.Add("classicSplits"					, false	, "G2 Classic v1.30 Splits"					            			);
    settings.Add("splitOnChapter2"					, false	, "Start Chapter 2 at Lord Hagen"			    , "classicSplits"	);
    settings.Add("splitOnEnterMineValley"			, true	, "Enter MineValley"						    , "classicSplits"	);
    settings.Add("splitOnChapter3"					, true	, "Start Chapter 3"							    , "classicSplits"	);
    settings.Add("splitOnZurisIsDead"				, false	, "(Experimental!) Zuris is dead"			    , "classicSplits"	);
    settings.Add("splitOnBecomeMiliz"				, true	, "Enter the cityguard as guild"			    , "classicSplits"	);
    settings.Add("splitOnBecomePaladin"				, true	, "Enter the Paladin Order as guild"		    , "classicSplits"	);
    settings.Add("splitOnChapter4"					, true	, "Start chapter 4"							    , "classicSplits"	);
    settings.Add("splitOnChapter5"					, true	, "Start chapter 5"							    , "classicSplits"	);
    settings.Add("splitOnChapter6"					, true	, "Start chapter 6"							    , "classicSplits"	);
    settings.Add("splitOnUndeadDragonDies"			, false	, "The undead dragon is dead"	                , "classicSplits"	);
    settings.Add("splitOnGameOver"					, true	, "Talk to the captain"			                , "classicSplits"	);

    vars.DebugMethods = false;
    vars.DebugInfos = false;

    Func<bool> ResetVars = () =>
    {
        if(vars.DebugMethods) print("\n    -- ResetVars --");
        vars.currentWorld = 0;
        vars.oldWorld = 0;
        vars.fireDragonDead = 0;
        vars.rockDragonDead = 0;
        vars.swampDragonDead = 0;
        vars.iceDragonDead = 0;
        vars.reachedValley = 0;
        vars.leftValley = 0;
        vars.reachedIrdorath = 0;
        vars.hasTalked = 0;

        vars.currentSplit = "splitOnChapter2";
        vars.chapter = 0;
        vars.gameOver = false;
        vars.frameCounterInGameTimeUnchanged = 0;
        vars.undeadDragonKilledAt = 0;
        return true;
    };
    vars.ResetVars = ResetVars;
    
    // General Settings
	settings.Add("resetNewGame"						, true	, "Reset and start timer on New Game"							);

    Func<bool> NextSplit = () =>
    {
        if(vars.DebugMethods) print("\n    -- NextSplit --");
        if      (vars.currentSplit == "splitOnChapter2"				        )   vars.currentSplit = "splitOnEnterMineValley" ;
        else if (vars.currentSplit == "splitOnEnterMineValley"		        )   vars.currentSplit = "splitOnChapter3" ;
        else if (vars.currentSplit == "splitOnChapter3"				        )   vars.currentSplit = "splitOnZurisIsDead" ;
        else if (vars.currentSplit == "splitOnZurisIsDead"			        )   vars.currentSplit = "splitOnBecomeMiliz" ;
        else if (vars.currentSplit == "splitOnBecomeMiliz"			        )   vars.currentSplit = "splitOnBecomePaladin" ;
        else if (vars.currentSplit == "splitOnBecomePaladin"			    )   vars.currentSplit = "splitOnChapter4" ;
        else if (vars.currentSplit == "splitOnChapter4"				        )   vars.currentSplit = "splitOnChapter5" ;
        else if (vars.currentSplit == "splitOnChapter5"				        )   vars.currentSplit = "splitOnChapter6" ;
        else if (vars.currentSplit == "splitOnChapter6"				        )   vars.currentSplit = "splitOnUndeadDragonDies" ;
        else if (vars.currentSplit == "splitOnUndeadDragonDies"		        )   vars.currentSplit = "splitOnGameOver" ;
        else if (vars.currentSplit == "splitOnGameOver"				        )   {vars.gameOver = true; return false;}
        if(vars.DebugMethods) print("Next Split " + vars.currentSplit);
        return true;
    };
    vars.NextSplit = NextSplit;

    vars.timerModel = new TimerModel { CurrentState = timer }; // e.g. in startup

    ResetVars();
}

reset 
{
    if(vars.DebugMethods) print("\n    -- reset --");
	// if automatic reset is wanted and ingame Time is 0
    if(vars.DebugInfos) print("\n    Current. InGameTime: " + current.inGameTime);
    return settings["resetNewGame"] && (current.inGameTime == 0);
}

onReset
{
    if(vars.DebugMethods) print("\n    -- onReset --");
    vars.ResetVars();
    while (!settings[vars.currentSplit])
    {
        if(!vars.NextSplit()) break;
    }
}

update 
{
    if(vars.DebugMethods) print("\n    -- update --");
    if (settings["notrAnyPercent"])
    {
        if (current.world != 0) 
        {	
            vars.currentWorld = current.world;
        }
        if (old.world != 0) 
        {
            vars.oldWorld = old.world;
        }
    }
    else if (settings["classicSplits"])
    {
        //During loading save states the chapter gets set to 0
        if(!vars.gameOver && current.chapter != 0)
        {
            vars.chapter = current.chapter;
            if(old.inGameTime == current.inGameTime)
            {
                vars.frameCounterInGameTimeUnchanged++;
            }
            else
            {
                vars.frameCounterInGameTimeUnchanged = 0;
            }

            if(current.chapter == 6 && current.world == 3 && current.undeadDragonDied == 1 && vars.undeadDragonKilledAt == 0) 
            {
                vars.undeadDragonKilledAt = current.inGameTime;
            }
        }
    }
}

start 
{
    if(vars.DebugMethods) print("\n    -- start --");
	if (settings["resetNewGame"]) 
    {
		return (old.inGameTime == 0 && current.inGameTime != 0);
	}
    return false;
}

onStart
{
    if(vars.DebugMethods) print("\n    -- onStart --");
    if(settings["classicSplits"])
    {
        while (!vars.gameOver && !settings[vars.currentSplit])
        {
            if(!vars.NextSplit()) break;
        }
    }
}

split 
{
    if(vars.DebugMethods) print("\n    -- split --");
	if(settings["notrAnyPercent"])
	{
		// Split when entering Valley of Mines
		if (settings["splitEnterValley"] && vars.oldWorld == 1 && vars.currentWorld == 2 && vars.reachedValley == 0) 
		{
			vars.reachedValley = 1;
			return true;
		}

		// Split when leaving Valley of Mines
		if (settings["splitLeaveValley"] && vars.oldWorld == 2 && vars.currentWorld == 1 && vars.leftValley == 0) 
		{
			vars.leftValley = 1;
			return true;
		}

		// Split when going from Khorinis to Irdorath
		if (settings["splitIrdorath"] && vars.oldWorld == 1 && vars.currentWorld == 3 && vars.reachedIrdorath == 0) 
		{
			vars.reachedIrdorath = 1;
			return true;
		}

		// Dragon Killsw
		if (settings["splitFireDragon"] && old.fireDragon == 0 && current.fireDragon == 1 && vars.fireDragonDead == 0) 
		{
			vars.fireDragonDead = 1;
			return true;
		}

		if (settings["splitRockDragon"] && old.rockDragon == 0 && current.rockDragon == 1 && vars.rockDragonDead == 0) 
		{
			vars.rockDragonDead = 1;
			return true;
		}

		if (settings["splitSwampDragon"] && old.swampDragon == 0 && current.swampDragon == 1 && vars.swampDragonDead == 0) 
		{
			vars.swampDragonDead = 1;
			return true;
		}

		if (settings["splitIceDragon"] && old.iceDragon == 0 && current.iceDragon == 1 && vars.iceDragonDead == 0) 
		{
			vars.iceDragonDead = 1;
			return true;
		}

		// Talking to Zuris
		if (settings["splitZuris"] && current.dialogue == 1 && current.inGameTime > 20000000 && vars.hasTalked == 0) 
		{
			vars.hasTalked = 1;
			return true;
		}
	}
	
    if(!vars.gameOver && settings["classicSplits"])
	{
        if(vars.DebugInfos) 
        {
            print(
                "\n   Split:                " + vars.currentSplit +
                "\n   Chapter:              " + current.chapter +
                "\n   World:                " + current.world +
                "\n   Game Over?:           " + vars.gameOver +
                "\n   old = current Time?:  " + (old.inGameTime == current.inGameTime) +
                "\n   DragonDeadAt:         " + (vars.undeadDragonKilledAt) +
                "\n   current Time?:        " + (current.inGameTime) +
                "\n   Same Frame Count:     " + (vars.frameCounterInGameTimeUnchanged) + "\n");
        }
        if (vars.currentSplit == "splitOnChapter2")                     return vars.chapter == 2;
        if (vars.currentSplit == "splitOnEnterMineValley")              return current.world == 2;
        if (vars.currentSplit == "splitOnChapter3")                     return vars.chapter == 3;
        if (vars.currentSplit == "splitOnZurisIsDead")                  return current.chapter == 3 && current.world == 1 && current.zurisHealth <= 0;
        if (vars.currentSplit == "splitOnBecomeMiliz")                  return current.guild == 2;
        if (vars.currentSplit == "splitOnBecomePaladin")                return current.guild == 5;
        if (vars.currentSplit == "splitOnChapter4")                     return vars.chapter == 4;
        if (vars.currentSplit == "splitOnChapter5")                     return vars.chapter == 5;
        if (vars.currentSplit == "splitOnChapter6")                     return vars.chapter == 6;
        if (vars.currentSplit == "splitOnUndeadDragonDies")             return vars.undeadDragonKilledAt != 0;
        if (vars.currentSplit == "splitOnGameOver")                     return current.chapter == 6 && current.world == 3 && !vars.gameOver && vars.frameCounterInGameTimeUnchanged >= 10 && current.undeadDragonDied == 0 && current.inGameTime > (vars.undeadDragonKilledAt + 1000000);
	}

    if(vars.gameOver & settings["classicSplits"])
    {
        if (vars.currentSplit == "splitOnGameOver")                     
        if (old.inGameTime < current.inGameTime && settings["splitOnGameOver"])
        {
            vars.timerModel.UndoSplit();
            vars.gameOver = false;
        }
    }	
}  

onSplit
{
    if(vars.DebugMethods) print("\n    -- onSplit --");
    if(!vars.gameOver && settings["classicSplits"])
	{
        bool firstRun = true;
        while (!vars.gameOver && (firstRun || !settings[vars.currentSplit]))
        {
            firstRun = false;
            if(!vars.NextSplit()) break;
        }
        return true;
	}	
}