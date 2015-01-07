--[[
##############################################################################
_____/\\\\\\\\\\\____/\\\________/\\\__/\\\________/\\\__/\\\\\\\\\\\_       #
 ___/\\\/////////\\\_\/\\\_______\/\\\_\/\\\_______\/\\\_\/////\\\///__      #
  __\//\\\______\///__\//\\\______/\\\__\/\\\_______\/\\\_____\/\\\_____     #
   ___\////\\\__________\//\\\____/\\\___\/\\\_______\/\\\_____\/\\\_____    #
    ______\////\\\________\//\\\__/\\\____\/\\\_______\/\\\_____\/\\\_____   #
     _________\////\\\______\//\\\/\\\_____\/\\\_______\/\\\_____\/\\\_____  #
      __/\\\______\//\\\______\//\\\\\______\//\\\______/\\\______\/\\\_____ #
       _\///\\\\\\\\\\\/________\//\\\________\///\\\\\\\\\/____/\\\\\\\\\\\_#
        ___\///////////___________\///___________\/////////_____\///////////_#
##############################################################################
S U P E R - V I L L A I N - U I   By: Munglunch                              #
##############################################################################

CONCEPT AND SOME CODE COURTESY OF:
##############################################################################
_____/\\\\\\\\\________/\\\\\\\\\\\\__/\\\\\\\\\\\\\\\_        
 ___/\\\\\\\\\\\\\____/\\\//////////__\///////\\\/////__       
  __/\\\/////////\\\__/\\\___________________\/\\\_______      
   _\/\\\_______\/\\\_\/\\\____/\\\\\\\_______\/\\\_______     
    _\/\\\\\\\\\\\\\\\_\/\\\___\/////\\\_______\/\\\_______    
     _\/\\\/////////\\\_\/\\\_______\/\\\_______\/\\\_______   
      _\/\\\_______\/\\\_\/\\\_______\/\\\_______\/\\\_______  
       _\/\\\_______\/\\\_\//\\\\\\\\\\\\/________\/\\\_______ 
        _\///________\///___\////////////__________\///________
##############################################################################
AUTOMATIC GOBLIN THERAPIST   By: Duugu                                       #
##############################################################################
]]--

--[[ GLOBALS ]]--
local _G = _G;
local unpack    = _G.unpack;
local select    = _G.select;
local pairs     = _G.pairs;
local ipairs    = _G.ipairs;
local type      = _G.type;
local error     = _G.error;
local pcall     = _G.pcall;
local assert    = _G.assert;
local print    	= _G.print;
local tostring  = _G.tostring;
local tonumber  = _G.tonumber;
local tinsert   = _G.tinsert;
local string    = _G.string;
local math      = _G.math;
local table     = _G.table;
--[[ STRING METHODS ]]--
local lower, upper = string.lower, string.upper;
local find, format, len, split = string.find, string.format, string.len, string.split;
local match, sub, join = string.match, string.sub, string.join;
local gmatch, gsub = string.gmatch, string.gsub;
--[[ MATH METHODS ]]--
local abs, ceil, floor, round = math.abs, math.ceil, math.floor, math.round;  -- Basic
local random = math.random;  -- Uncommon
--[[ TABLE METHODS ]]--
local tremove, tcopy, twipe = table.remove, table.copy, table.wipe;
--[[ 
########################################################## 
GET ADDON DATA
##########################################################
]]--
local PLUGIN = select(2, ...)

local Schema = PLUGIN.Schema;
local PlayersName = UnitName("player")

local SV = _G["SVUI"]
local L = SV.L
--[[ 
########################################################## 
LOCAL VARS
##########################################################
]]--
local playerName = UnitName("player");
local playerRealm = GetRealmName();

local ConjugationKeys = {[1]={[1]="are",[2]="am",[3]="were",[4]="was",[5]="I",[6]="me",[7]="you",[8]="my",[9]="your",[10]="mine",[11]="your's",[12]="I'm",[13]="you're",[14]="I've",[15]="you've",[16]="I'll",[17]="you'll",[18]="myself",[19]="yourself"},[2]={[1]="am",[2]="are",[3]="was",[4]="were",[5]="you",[6]="you",[7]="me",[8]="your",[9]="my",[10]="your's",[11]="mine",[12]="you're",[13]="I'm",[14]="you've",[15]="I've",[16]="you'll",[17]="I'll",[18]="yourself",[19]="myself"},[3]={[1]="me am",[2]="am me",[3]="mecan",[4]="can me",[5]="me have",[6]="me will",[7]="will me"},[4]={[1]="I am",[2]="am I",[3]="I can",[4]="can I",[5]="I have",[6]="I will",[7]="will I"}};
local punctuations = {[1]={pattern="%.",value="."},[2]={pattern=",",value=","},[3]={pattern="!",value="!"},[4]={pattern="%?",value="?"},[5]={pattern=":",value=":"},[6]={pattern=";",value=";"},[7]={pattern="&",value="&"},[8]={pattern="\"",value="\""},[9]={pattern="@",value="@"},[10]={pattern="#",value="#"},[11]={pattern="%(",value="("},[12]={pattern="%)",value=")"}};

local PhoneLines = {};
local ResponseQueue = {};

local ICON_FILE = [[Interface\AddOns\SVUI_ChatOMatic\artwork\DOCK-CALL]]
local DEFAULT_GRADIENT = {"VERTICAL", 0.08, 0.08, 0.08, 0.22, 0.22, 0.22}
local GREEN_GRADIENT = {"VERTICAL", 0.08, 0.5, 0, 0.25, 0.9, 0.08}
local YELLOW_GRADIENT = {"VERTICAL", 1, 0.3, 0, 1, 1, 0}
--[[ 
########################################################## 
DIALOG TABLES
##########################################################
]]--
local OneLiners = {
	[1] = "I've got to sit down and work out where I stand.",
	[2] = "If I save time, when do I get it back?",
	[3] = "I am not prejudice. I hate everyone equally.",
	[4] = "Take my advice, I don't use it anyway.",
	[5] = "The statement below is true. The statement above is false.",
	[6] = "As I said before, I never repeat myself.",
	[7] = "If at first you don't succeed, avoid skydiving.",
	[8] = "War doesn't determine who's right. War determines who's left.",
	[9] = "Best way to prevent a hangover is to stay drunk.",
	[10] = "Doesn't expecting the unexpected make the unexpected become the expected?",
	[11] = "I was born intelligent... education ruined me.",
	[12] = "A bus station is where a bus stops. A train station is where a train stops. On my desk, I have a work station... What more can I say?",
	[13] = "If it's true that we are here to help others, then, what exactly are the others here for?",
	[14] = "Since light travels faster than sound, people appear bright Until you hear them speak.",
	[15] = "How come \"abbreviated\" is such a long word?",
	[16] = "Living on Earth may be expensive... but it includes an annual free trip around the Sun.",
	[17] = "Your future depends on your dreams So go to sleep!",
	[18] = "A good discussion is like a miniskirt, short enough to hold interest and long enough to cover the subject.",
	[19] = "A good time to keep your mouth shut is when you are in deep water.",
	[20] = "How come we choose from just two people for President and 50 for Miss America?",
	[21] = "No one ever says \"it's just a game\" when they are winning.",
	[22] = "Suicidal twin kills sister by mistake!",
	[23] = "He who laughs last thinks slowest!",
	[24] = "Always remember you're unique, just like everyone else.",
	[25] = "Hard work has a future payoff. Laziness pays off now.",
	[26] = "Don't take life too seriously, you won't get out alive.",
	[27] = "I don't suffer from insanity. I enjoy every minute of it.",
	[28] = "I'm as confused as a baby in a topless bar.",
	[29] = "90% of all statistics are made up.",
	[30] = "If you can't convince them, confuse them.",
	[31] = "If at first you don't succeed, destroy all evidence that you tried"
}

local Excuse = {
	-- OPENERS
	[1] = "I'd love to, but ",
	[2] = "I'm being told that ",
	[3] = "The voices say that ",
	[4] = "Hang on a sec ",
	[5] = "You should know that ",
	[6] = "I just found out that ",
	[7] = "I would but ",
	[8] = "Umm... ",
	[9] = "I don't know about you but ",
	[10] = "Can't talk right now, ",
	-- PUNCHLINES
	[11] = "I have to floss my cat",
	[12] = "I've dedicated my life to linguini",
	[13] = "I want to spend more time with my blender",
	[14] = "the President said he might drop in",
	[15] = "the man on television told me to say tuned",
	[16] = "I've been scheduled for a karma transplant",
	[17] = "I'm staying home to work on my cottage cheese sculpture",
	[18] = "it's my parakeet's bowling night",
	[19] = "it wouldn't be fair to the other Beautiful People",
	[20] = "I'm building a pig from a kit",
	[21] = "I did my own thing and now I've got to undo it",
	[22] = "I'm enrolled in aerobic scream therapy",
	[23] = "there's a disturbance in the Force",
	[24] = "I'm doing door-to-door collecting for static cling",
	[25] = "I have to go to the post office to see if I'm still wanted",
	[26] = "I'm teaching my ferret to yodel",
	[27] = "I have to check the freshness dates on my dairy products",
	[28] = "I'm going through cherry cheesecake withdrawl",
	[29] = "I'm planning to go downtown to try on gloves",
	[30] = "my crayons all melted together",
	[31] = "I'm trying to see how long I can go without saying yes",
	[32] = "I'm in training to be a household pest",
	[33] = "I'm getting my overalls overhauled",
	[34] = "my patent is pending",
	[35] = "I'm attending the opening of my garage door",
	[36] = "I'm sandblasting my oven",
	[37] = "I'm worried about my vertical hold",
	[38] = "I'm going down to the bakery to watch the buns rise",
	[39] = "I'm being deported",
	[40] = "the grunion are running",
	[41] = "I'll be looking for a parking space",
	[42] = "my Millard Filmore Fan Club meets then",
	[43] = "the monsters haven't turned blue yet, and I have to eat more dots",
	[44] = "I'm taking punk totem pole carving",
	[45] = "I have to fluff my shower cap",
	[46] = "I'm converting my calendar watch from Julian to Gregorian",
	[47] = "I've come down with a really horrible case of something or other",
	[48] = "I made an appointment with a cuticle specialist",
	[49] = "my plot to take over the world is thickening",
	[50] = "I have to fulfill my potential",
	[51] = "I don't want to leave my comfort zone",
	[52] = "it's too close to the turn of the century",
	[53] = "I have some real hard words to look up in the dictionary",
	[54] = "my subconscious says no",
	[55] = "I'm giving nuisance lessons at a convenience store",
	[56] = "I left my body in my other clothes",
	[57] = "the last time I went, I never came back",
	[58] = "I've got a Friends of Rutabaga meeting",
	[59] = "I have to answer all of my 'occupant' letters",
	[60] = "none of my socks match",
	[61] = "I have to be on the next train to Bermuda",
	[62] = "I'm having all my plants neutered",
	[63] = "people are blaming me for the Spanish-American War",
	[64] = "I changed the lock on my door and now I can't get out",
	[65] = "I'm making a home movie called 'The Thing That Grew in My Refrigerator'",
	[66] = "I'm attending a perfume convention as guest sniffer",
	[67] = "my yucca plant is feeling yucky",
	[68] = "I'm touring China with a wok band",
	[69] = "my chocolate-appreciation class meets that night",
	[70] = "I never go out on days that end in 'Y'",
	[71] = "my mother would never let me hear the end of it",
	[72] = "I'm running off to Yugoslavia with a foreign-exchange student named Basil Metabolism",
	[73] = "I just picked up a book called 'Glue in Many Lands' and I can't put it down",
	[74] = "I'm too evil for that stuff",
	[75] = "I have to torment my hair",
	[76] = "I have too much guilt",
	[77] = "there are important world issues that need worrying about",
	[78] = "I have to draw 'Cubby' for an art scholarship",
	[79] = "I'm uncomfortable when I'm alone or with others",
	[80] = "I promised to help a friend fold road maps",
	[81] = "I feel a song coming on",
	[82] = "I'm trying to be less popular",
	[83] = "my bathroom tiles need grouting",
	[84] = "I have to bleach my hare",
	[85] = "I'm waiting to see if I'm already a winner",
	[86] = "I'm writing a love letter to Richard Simmons",
	[87] = "you know how we psychos are",
	[88] = "my favorite commercial is on TV",
	[89] = "I have to study for a blood test",
	[90] = "I'm going to be old someday",
	[91] = "I've been traded to Cincinnati",
	[92] = "I'm observing National Apathy Week",
	[93] = "I have to rotate my crops",
	[94] = "my uncle escaped again",
	[95] = "I'm up to my elbows in waxy buildup",
	[96] = "I have to knit some dust bunnies for a charity bazaar",
	[97] = "I'm having my baby shoes bronzed",
	[98] = "I have to go to court for kitty littering",
	[99] = "I'm going to count the bristles in my toothbrush",
	[100] = "I have to thaw some karate chops for dinner",
	[101] = "having fun gives me prickly heat",
	[102] = "I'm going to the Missing Persons Bureau to see if anyone is looking for me",
	[103] = "I have to jog my memory",
	[104] = "my palm reader advised against it",
	[105] = "my Dress For Obscurity class meets then",
	[106] = "I have to stay home and see if I snore",
	[107] = "I prefer to remain an enigma",
	[108] = "I think you want the OTHER " .. playerName,
	[109] = "I have to sit up with a sick ant",
	[110] = "I'm trying to cut down",
	[111] = ".. well, maybe",
};

local Phrases = {
	[1] = "I don't really want to<*",
	[2] = "Are you going to<*",
	[3] = "I don't know, should I<*",
	[4] = "So you are not going to<*",
	[5] = "Why don't you<*",
	[6] = "So you think I'm<*",
	[7] = "What's it to you if I'm<*",
	[8] = "Did you wanna<*",
	[9] = "Do you wanna<*",
	[10] = "Don't you really<*",
	[11] = "Why don't you<*",
	[12] = "I bet you can't<*",
	[13] = "UMADBRO?",
	[14] = "I'm marginally listening.",
	[15] = "Let me get this straight, you feel<*",
	[16] = "Stop feeling<*",
	[17] = "Why would I<*",
	[18] = "If your lucky I just might<@",
	[19] = "So, your really asking me to<*",
	[20] = "Is there a reason why YOU don't<*",
	[21] = "Why can't you<*",
	[22] = "Why are you interested in whether or not I am<*",
	[23] = "Would you prefer if I were not<*",
	[24] = "Perhaps in your fantasies I am<*",
	[25] = "How do you know you can't<*",
	[26] = "Have you tried?",
	[27] = "Perhaps you can now<*",
	[28] = "Did you come to me because you are<*",
	[29] = "How long have you been<*",
	[30] = "Do you believe it is normal to be<*",
	[31] = "Do you enjoy being<*",
	[32] = "We were discussing you, not me.",
	[33] = "Oh... <*",
	[34] = "Doesn't sound like me though, does it?",
	[35] = "How awesome would it be if you got<*",
	[36] = "Why do you want<*",
	[37] = "Suppose you got<*",
	[38] = "What if you never got<*",
	[39] = "I sometimes also want<@",
	[40] = "Whay are you asking me?",
	[41] = "Does it really matter?",
	[42] = "Is there a right answer?",
	[43] = "What do you think?",
	[44] = "You are asking the wrong questions, wanna try again?",
	[45] = "What is it that you really want to know?",
	[46] = "Who else have you asked?",
	[47] = "Am I the first person you have asked this?",
	[48] = "Don't you already know the aswer to that?",
	[49] = "The names aren't important.",
	[50] = "I won't remember any names, do continue.",
	[51] = "Is that the real reason?",
	[52] = "Don't any other reasons come to mind?",
	[53] = "Does that reason explain anything else?",
	[54] = "What other reasons might there be?",
	[55] = "Please don't apologise!",
	[56] = "Apologies are not necessary.",
	[57] = "What feelings do you have when you apologise?",
	[58] = "Don't be so defensive!",
	[59] = "What does that dream suggest to you?",
	[60] = "Do you dream often?",
	[61] = "What persons appear in your dreams?",
	[62] = "Are you disturbed by your dreams?",
	[63] = "What?",
	[64] = "You don't seem quite certain.",
	[65] = "Why the uncertain tone?",
	[66] = "Can't you be more positive?",
	[67] = "You aren't sure?",
	[68] = "Don't you know?",
	[69] = "Are you saying no just to be negative?",
	[70] = "You are being a bit negative.",
	[71] = "Why not?",
	[72] = "Are you sure?",
	[73] = "Why no?",
	[74] = "Why are you concerned about my<*",
	[75] = "What about your own<*",
	[76] = "Can you think of a specific example?",
	[77] = "When?",
	[78] = "What are you thinking of?",
	[79] = "Really, always?",
	[80] = "Think so?",
	[81] = "You thought<*",
	[82] = "You really think<*",
	[83] = "In what way?",
	[84] = "What resemblence do you see?",
	[85] = "What does the similarity suggest to you?",
	[86] = "What other connections do you see?",
	[87] = "Could there really be some connection?",
	[88] = "How?",
	[89] = "You seem quite positive.",
	[90] = "ORLY?",
	[91] = "OIC.",
	[92] = "Word.",
	[93] = "You dont have any friends.",
	[94] = "Why would I care about your friends?",
	[95] = "Are you sure you know what 'friend' means?",
	[96] = "Are you sure you have any friends?",
	[97] = "Do your friends usually get really quiet when you are around?",
	[98] = "I'm willing to bet your friends hate you.",
	[99] = "Who still uses the word noob?",
	[100] = "Are you talking about me specifically?",
	[101] = "I dunno. What are YOU doing?",
	[102] = "Would't you like to know?",
	[103] = "What do you think?",
	[104] = "I'm guessing you want something from me?",
	[105] = "I'm playing World of Warcraft... you seriously didn't know that?",
	[106] = "No kidding? Fo' realz? That's dope fresh son!",
	[107] = "And what did you learn?",
	[108] = "Gotcha.",
	[109] = "MmmmHmmm",
	[110] = "I don't follow...",
	[111] = "I'm gonna need a bit more context. Do you know what context means?",
	[112] = "Wow... just ...wow.",
	[113] = "Same question huh?",
	[114] = "Deja Vu!",
	[115] = "Yeah, lets try this again shall we?",
	[116] = "Have you recently suffered a head injury?",
	[117] = "Im hearing an echo I think....",
	[118] = "Cant all classes heal themselves now?",
	[119] = "Bandages FTW!",
	[120] = "Why are you asking me?",
	[121] = "Thats adorable how excited you are about it!",
	[122] = "What do you think?",
	[123] = "What is it that you really want to know?",
	[124] = "What is your level?",
	[125] = "Is this your first character?",
	[126] = "Most guilds are just full of high school kids with nothing better to do.",
	[127] = "What is a guild?",
	[128] = "What is the name?",
	[129] = "Oh really?",
	[130] = "Great story.",
	[131] = "Meh.",
	[132] = "No clue."
};

local Responses = {
	[1] =  {Key = "**NO KEY**",	   Question = false, Dialog = {106,107,108,109,110,111,112,129,130,131,132}},
	[2] =  {Key = "**REPEAT**",	   Question = false, Dialog = {113,114,115,116,117}},                                                        
	[3] =  {Key = "YOU'RE", 	   Question = false, Dialog = {6,7,8,9}},                                                                                
	[4] =  {Key = "I DON'T", 	   Question = false, Dialog = {10,11,12,13}},                                                                        
	[5] =  {Key = "I FEEL", 	   Question = false, Dialog = {14,15,16 }},                                                                            
	[6] =  {Key = "WHY DON'T YOU", Question = false, Dialog = {17,18,19}},                                                                              
	[7] =  {Key = "WHY CAN'T I",   Question = false, Dialog = {20,21 }},                                                                                  
	[8] =  {Key = "ARE YOU", 	   Question = false, Dialog = {22,23,24}},                                                                              
	[9] =  {Key = "I CAN'T", 	   Question = false, Dialog = {25,26,27}},                                                                              
	[10] = {Key = "I AM", 		   Question = false, Dialog = {28,29,30,31}},                                                                        
	[11] = {Key = "I'M", 		   Question = false, Dialog = {28,29,30,31}},                                                                        
	[12] = {Key = "YOU", 		   Question = false, Dialog = {32,33,34}},                                                                              
	[13] = {Key = "I WANT", 	   Question = false, Dialog = {35,36,37,38,39 }},                                                                
	[14] = {Key = "WHAT", 		   Question = true,  Dialog = {40,41,42,43,44,45,46,47,48}},
	[15] = {Key = "HOW", 		   Question = true,  Dialog = {40,41,42,43,44,45,46,47,48}},
	[16] = {Key = "WHO", 		   Question = true,  Dialog = {40,41,42,43,44,45,46,47,48}},
	[17] = {Key = "WHERE", 		   Question = true,  Dialog = {40,41,42,43,44,45,46,47,48}},
	[18] = {Key = "WHEN", 		   Question = true,  Dialog = {40,41,42,43,44,45,46,47,48}},
	[19] = {Key = "WHY",  		   Question = true,  Dialog = {40,41,42,43,44,45,46,47,48}},
	[20] = {Key = "NAME", 		   Question = false, Dialog = {49,50}},                                                                                    
	[21] = {Key = "CAUSE", 		   Question = false, Dialog = {51,52,53,54}},                                                                        
	[22] = {Key = "SORRY", 		   Question = false, Dialog = {55,56,57,58}},                                                                        
	[23] = {Key = "DREAM",  	   Question = false, Dialog = {59,60,61,62}},                                                                        
	[24] = {Key = "HELLO",  	   Question = false, Dialog = {63}},                                                                                          
	[25] = {Key = "HI",  		   Question = false, Dialog = {63}},                                                                                          
	[26] = {Key = "MAYBE",  	   Question = false, Dialog = {64,65,66,67,68}},                                                                  
	[27] = {Key = "NO",   		   Question = false, Dialog = {69,70,71,72,73}},                                                                  
	[28] = {Key = "YOUR",   	   Question = false, Dialog = {74,75}},                                                                                    
	[29] = {Key = "ALWAYS", 	   Question = false, Dialog = {76,77,78,79}},                                                                        
	[30] = {Key = "THINK",  	   Question = false, Dialog = {80,81,82}},                                                                              
	[31] = {Key = "ALIKE",  	   Question = false, Dialog = {83,84,85,86,87,88,89}},                                                      
	[32] = {Key = "YES",   		   Question = false, Dialog = {90,91,92}},                                                                              
	[33] = {Key = "FRIEND", 	   Question = false, Dialog = {93,94,95,96,97,98}},                                                            
	[34] = {Key = "NOOB",   	   Question = false, Dialog = {99}},                                                                                          
	[35] = {Key = "CAN I", 		   Question = false, Dialog = {4,5}},                                                                                        
	[36] = {Key = "CAN YOU",  	   Question = false, Dialog = {1,2,3}},                                                                                    
	[37] = {Key = "WILL YOU",  	   Question = false, Dialog = {1,2,3}},                                                                                    
	[38] = {Key = "WOULD YOU",     Question = false, Dialog = {1,2,3}},                                                                                    
	[39] = {Key = "COULD YOU",     Question = false, Dialog = {1,2,3}},                                                                                    
	[40] = {Key = "YOU ARE", 	   Question = false, Dialog = {6,7,8,9 }},                                                                              
	[41] = {Key = "HEALER",  	   Question = false, Dialog = {118,119}},                                                                                
	[42] = {Key = "HOLY", 		   Question = false, Dialog = {118,119}},                                                                                
	[43] = {Key = "RESTORATION",   Question = false, Dialog = {118,119}},                                                                                
	[44] = {Key = "HEAL",  		   Question = false, Dialog = {118,119}},                                                                                
	[45] = {Key = "PORT", 		   Question = false, Dialog = {40,41,42,43,44,45,46,47,48}},                                          
	[46] = {Key = "PORTAL",  	   Question = false, Dialog = {40,41,42,43,44,45,46,47,48}},                                          
	[47] = {Key = "WATER", 		   Question = false, Dialog = {40,41,42,43,44,45,46,47,48}},                                          
	[48] = {Key = "FOOD",  		   Question = false, Dialog = {40,41,42,43,44,45,46,47,48}},                                          
	[49] = {Key = "MONEY",  	   Question = false, Dialog = {40,41,42,43,44,45,46,47,48}},                                          
	[50] = {Key = "GOLD", 		   Question = false, Dialog = {40,41,42,43,44,45,46,47,48}},                                          
	[51] = {Key = "PVP",  		   Question = false, Dialog = {120,121,122,123,124,125}},                                                
	[52] = {Key = "RAID",  		   Question = false, Dialog = {120,121,122,123,124,125}},                                                
	[53] = {Key = "KNOW",  		   Question = false, Dialog = {64,65,66,67,68}},                                                                  
	[54] = {Key = "POSSIBLE",  	   Question = false, Dialog = {64,65,66,67,68}},                                                                  
	[55] = {Key = "WTF",  		   Question = false, Dialog = {64,65,66,67,68}},                                                                  
	[56] = {Key = "LOL",  		   Question = false, Dialog = {64,65,66,67,68}},                                                                  
	[57] = {Key = "GUILD", 		   Question = false, Dialog = {126,127,128}},                                                                        
	[58] = {Key = "TOON", 		   Question = false, Dialog = {49,50}},                                                                                    
	[59] = {Key = "CHARACTER", 	   Question = false, Dialog = {49,50}},                                                                                    
	[60] = {Key = "PLAYER", 	   Question = false, Dialog = {49,50}},                                                                                    
	[61] = {Key = "DOING", 		   Question = false, Dialog = {100,101,102,103,104,105}},                                                
	[62] = {Key = "UP TO", 		   Question = false, Dialog = {100,101,102,103,104,105}},                                                
};
--[[ 
########################################################## 
LOCAL FUNCTIONS
##########################################################
]]--
local function ServiceMessage(msg) 
    local msgFrom = PLUGIN.db.general.prefix == true and "Minion Answering Service" or "";
    print("|cffffcc1a" .. msgFrom .. ":|r", msg) 
end

local function ClearResponses(caller)
	for x = 1, #ResponseQueue, 1 do
		if ResponseQueue[x] then
			if ResponseQueue[x].CID == caller then
				tremove(ResponseQueue, x)
			end
		end
	end
end

local function RemoveCaller(caller)
	ClearResponses(caller)
		
	if PhoneLines[caller] then
		local data = PhoneLines[caller]
		local btn = _G["HenchmenPhoneLine"..data.Line];
		btn.Text:SetText("Empty Phone Line");
		btn:SetPanelColor("default");
		PhoneLines[caller] = nil
		ServiceMessage("Caller ("..caller..") was disconnected.");
	end
end
--[[ 
########################################################## 
MESSAGE PROCESSING
##########################################################
]]--
do
	local function Conjugate(parse)
		for i,cj in pairs(ConjugationKeys[1]) do
			parse = gsub(parse, cj, "#@&"..i)
		end
		for i,cj in pairs(ConjugationKeys[2]) do
			parse = gsub(parse, "#@&"..i, cj)
		end
		for i,cj in pairs(ConjugationKeys[3]) do
			parse = gsub(parse, cj, "#@&"..i)
		end
		for i,cj in pairs(ConjugationKeys[4]) do
			parse = gsub(parse, "#@&"..i, cj)
		end
		return parse
	end

	local function PadString(strng)
		local aString = " "..strng.." "
		for i = 1, 12, 1 do
			aString = gsub(aString, punctuations[i].pattern, " "..punctuations[i].value.." ")
		end
		return " "..aString.." "
	end

	local function UnPadString(strng)
		local aString = strng
		aString = gsub(aString, "  ", " ") 		
		if sub(aString, 1, 1) == " " then
			aString = sub(aString, 2)
		end
		if sub(aString, -1, -1) == " " then
			aString = sub(aString, 1, len(aString)-1) 
		end
		for i = 1, 12, 1 do
			aString = gsub(aString, " "..punctuations[i].pattern, punctuations[i].value)
		end
		return aString
	end

	local function TrimString(orgString, unpad)
		local tmpChars = ".,!?:;&\"@#()^$+-%= "
		local x = 1
		local found = true

		if(unpad) then
			orgString = UnPadString(orgString)
		end

		while found == true do 
			local tchar = sub(orgString, -(x), -(x))
			if tchar == "(" or tchar == ")" or tchar == "." or tchar == "%" or tchar == "+" or tchar == "-" or tchar == "*" or tchar == "?" or tchar == "[" or tchar == "]" or tchar == "^" or tchar == "$" then
				tchar = "%"..tchar
			end
			found = find(tchar,tmpChars) and (len(orgString) - x) > 0
			x = x + 1
		end
		x = x - 1
		if (len(orgString) - x) > 0 then
			orgString = sub(orgString, 1, len(orgString) - x + 1)
		end
		x = 1
		while find(sub(orgString, x, x),tmpChars) and (len(orgString) - x) > 0 do
			x = x + 1
		end
		if (len(orgString) - x) > 0 then
			orgString = sub(orgString, x)
		end
		return orgString
	end

	local function PhraseSearch(sString, keyid, data)
		local thisstr = "";
		local phrase;
		local wordkey = Responses[keyid].Key;
		local links = Responses[keyid].Dialog;
		local idrange = #links
		if idrange > 1 then
			while(not phrase) do
				local mod = floor(random(1, idrange))
				if links[mod] ~= data.LastKey then
					phrase = Phrases[links[mod]]
					data.LastKey = links[mod]
				end
			end
		else
			data.LastKey = 1
		end
		local tempt = phrase and sub(phrase, -1, -1) or ''	
		local sTemp = ""
		if tempt == "*" or tempt == "@" then
			sTemp = PadString(sString)
			local wTemp = upper(sTemp)
			local strpstr = find(wTemp, " "..wordkey.." ")
			if not strpstr then
				strpstr = find(wTemp, " "..wordkey)
			end
			if not strpstr then
				strpstr = find(wTemp, wordkey.." ")
			end
			strpstr = strpstr + len(wordkey) + 1
			thisstr = Conjugate(sub(sTemp, strpstr))
			thisstr = TrimString(thisstr, true)
			if tempt == "*" then
				sTemp = gsub(phrase, "<%*", " "..thisstr.."?")
			else
				sTemp = gsub(phrase, "<@", " "..thisstr..".")
			end
		else 
			sTemp = phrase
		end
		return sTemp
	end

	local function KeywordSearch(wString)
		for k, v in gmatch(wString, "([%w']+ [%w']+ [%w']+ [%w']+ [%w']+)") do
			for x = 1, 62, 1 do
				if Responses[x].Key == k then
					return x
				end
			end
		end
		for k, v in gmatch(wString, "([%w']+ [%w']+ [%w']+ [%w']+)") do
			for x = 1, 62, 1 do
				if Responses[x].Key == k then
					return x
				end
			end
		end
		for k, v in gmatch(wString, "([%w']+ [%w']+ [%w']+)") do
			for x = 1, 62, 1 do
				if Responses[x].Key == k then
					return x
				end
			end
		end
		for k, v in gmatch(wString, "([%w']+ [%w']+)") do
			for x = 1, 62, 1 do
				if Responses[x].Key == k then
					return x
				end
			end
		end
		for k, v in gmatch(wString, "([%w]-) ") do
			for x = 1, 62, 1 do
				if Responses[x].Key == k then
					return x
				end
			end
		end
		return 1 		
	end

	local function MakeExcuse(sInput)
		local joke = random(100)
		if(joke <= 31) then
			return OneLiners[joke];
		end
		local word_list = {}
		for k, v in gmatch(sInput, "([%w']+)") do
			tinsert(word_list, k)
		end
		local tBestQuotes = {}
		local mxWords = 0
		for x = 11, 101, 1 do
			local count = 0
			for y = 1, #word_list, 1 do
				if find(Excuse[x], word_list[y]) then
					count = count + 1
				end
			end
			if count > mxWords then
				tBestQuotes = {}
				mxWords = count
				tinsert(tBestQuotes, x)
			elseif count == mxWords then
				tinsert(tBestQuotes, x)
			end
		end

		local response = Excuse[random(1,10)]
		local mod = random(11,101)
		if #tBestQuotes > 0 then
			mod = tBestQuotes[random(#tBestQuotes)]
		end
		response = response .. Excuse[mod]
		return response;
	end

	local function MessageBuilder(data, inbound)
		local sInput = TrimString(inbound);
		local outbound;
		local mapkey = 1;
		if sInput ~= "" and sInput ~= " " and sInput ~= "  " and sInput ~= "." and sInput ~= "," then
			local wInput = PadString(upper(sInput));
			mapkey = KeywordSearch(wInput);
			if Responses[mapkey].Question == true then
				if sub(inbound, -1, -1) ~= "?" then
					mapkey = 1
				end
			end
			if(inbound == data.InBound or inbound == data.OutBound) then					
				mapkey = 2		  			
			elseif mapkey == 1 then
				if data.FirstResponse == true then
					outbound = ":)";
				else
					if(20 >= random(100)) then
						outbound = MakeExcuse(sInput)
					end
				end
			end
			data.FirstResponse = false
		end
		if(not outbound) then
			outbound = PhraseSearch(sInput, mapkey, data)
		end
		if(PLUGIN.db.general.prefix == true) then 
			return ("%s's Answering Service: %s"):format(PlayersName, outbound) 
		else
			return outbound
		end
	end

	function PLUGIN:TakeAMessage(caller, inbound)
		ClearResponses(caller)
		local data = PhoneLines[caller];
		if(data) then
			if(data.InUse) then
				local data = PhoneLines[caller];
				local outbound = MessageBuilder(data, inbound)
				data.OutBound = outbound
				local tm = (floor(GetTime()) + ((len(outbound)/400) * 60));
				tinsert(ResponseQueue, {["ETA"] = tm, ["MSG"] = outbound, ["CID"] = caller})
			end
			data.InBound = inbound
			data.TimeStamp = GetTime()
		end
	end
end

function PLUGIN:AddCaller(caller)
	local state_text = "now on hold.";
	local call_answered = false
	PhoneLines[caller] = {
		Line = 1,
		InUse = false,
		FirstResponse = true,
		Caller = caller,
		InBound = "",
		OutBound = "",
		LastKey = 1,
		TimeStamp = 0
	};
	for x = 1, 5, 1 do
		local btn = _G["HenchmenPhoneLine"..x];
		if(btn.Text:GetText() ~= caller) then
			btn.Text:SetText(caller);
			PhoneLines[caller].Line = x
			call_answered = true
			if self.db.general.autoAnswer == true then
				PhoneLines[caller].InUse = true;
				btn:SetPanelColor("green");
				self.Docklet.DockButton:SetPanelColor("green");
				self.Docklet.DockButton.stateColor = GREEN_GRADIENT
				state_text = "on the line.";
				PlaySoundFile("Sound\\interface\\iQuestUpdate.wav")
			end
			break;
		end
	end
	if(not call_answered) then
		ServiceMessage("All lines are busy. New caller ("..caller..") was disconnected.")
	else
		ServiceMessage("New caller ("..caller..") is "..state_text)
	end
end

function PLUGIN:GetServiceState()
	local inUse = false
	local onHold = false
	for x = 1, 5, 1 do
		local btn = _G["HenchmenPhoneLine"..x];
		local caller = btn.Text:GetText()
		if(PhoneLines[caller]) then
			inUse = true
			if(not PhoneLines[caller].InUse) then
				onHold = true
			end
		end
	end

	if inUse then
		if onHold then
			self.Docklet.DockButton:SetPanelColor("yellow")
			self.Docklet.DockButton.Icon:SetGradient(unpack(YELLOW_GRADIENT))
			self.Docklet.DockButton.stateColor = YELLOW_GRADIENT
		else
			self.Docklet.DockButton:SetPanelColor("green")
			self.Docklet.DockButton.Icon:SetGradient(unpack(GREEN_GRADIENT))
			self.Docklet.DockButton.stateColor = GREEN_GRADIENT
		end
	else
		self.Docklet.DockButton:SetPanelColor("default")
		self.Docklet.DockButton.stateColor = DEFAULT_GRADIENT
	end
	return inUse,onHold
end

function PLUGIN:HangUp(caller,ignored)
	RemoveCaller(caller)
	local inUse,onHold = self:GetServiceState()

	if inUse == false then
		self.Docklet:Hide()
	elseif onHold == true then
		self.Docklet:Show()
	else
		self.Docklet:Show()
	end

	if(ignored) then
		ServiceMessage(caller.." is now ignoring you! MwaaHaHa!")
		PlaySoundFile("Sound\\interface\\RaidWarning.wav")
	end
end
--[[ 
########################################################## 
EVENTS
##########################################################
]]--
function PLUGIN:PhoneTimeUpdate()
	local timer = 300;
	local ttime = GetTime()
	if #ResponseQueue > 0 then
		for x = 1, #ResponseQueue, 1 do
			if ResponseQueue[x] then
				if ResponseQueue[x].ETA < ttime then
					SendChatMessage(ResponseQueue[x].MSG, "WHISPER", nil, ResponseQueue[x].CID)
					tremove(ResponseQueue, x)
				end
			end
		end
	end
	if ttime > timer then
		for x = 1, 5, 1 do
			local btn = _G["HenchmenPhoneLine"..x];
			local caller = btn.Text:GetText()
			if(PhoneLines[caller]) then
				if PhoneLines[caller].TimeStamp < (ttime - timer) then
					self:HangUp(caller)
				end
			end
		end
	end
end

function PLUGIN:CHAT_MSG_IGNORED(event, inbound_message, caller, ...)
	if(PhoneLines[caller] and PhoneLines[caller].InUse) then
		self:HangUp(caller,true)
	end
end

function PLUGIN:AUTO_MSG_WHISPER(event, inbound_message, caller)
	if not UnitIsAFK("player") and not UnitIsDND("player") then
		if (not PhoneLines[caller]) then
			self:AddCaller(caller)
		end
		self:TakeAMessage(caller, inbound_message)
	end
end

function PLUGIN:AUTO_MSG_BN_WHISPER(event, inbound_message, sender, _, _, _, _, _, _, _, _, _, _, presenceID)
	if(not presenceID) then return end
	if not UnitIsAFK("player") and not UnitIsDND("player") then
		local _, bnToon = BNGetToonInfo(presenceID);
		local realToon = select(5, BNGetFriendInfoByID(presenceID))
		local caller = realToon or bnToon or sender;
		if (not PhoneLines[caller]) then
			self:AddCaller(caller)
		end
		self:TakeAMessage(caller, inbound_message)
	end
end
--[[ 
########################################################## 
OTHER HANDLERS
##########################################################
]]--
local AnsweringOnClick = function()
	if(PLUGIN.Docklet:IsShown()) then
		PLUGIN.Docklet.DockButton:Deactivate()
	else
		PLUGIN.Docklet.DockButton:Activate()
	end
end

local PhoneLineClick = function(self, button)
	local caller = self.Text:GetText()
	if((caller == "Empty Phone Line") or not PhoneLines[caller]) then return; end
	if button == "LeftButton" then
		if(not PhoneLines[caller].InUse) then
			self:SetPanelColor("green");
			PhoneLines[caller].InUse = true
			ServiceMessage("Let the torment of "..caller.." begin!")
			PLUGIN:TakeAMessage(caller, PhoneLines[caller].InBound) 
		else
			self:SetPanelColor("yellow");
			PhoneLines[caller].InUse = false
			ServiceMessage(caller.." is now on hold")
		end
	elseif button == "RightButton" then
		PLUGIN:HangUp(caller)	
	end
	PLUGIN:GetServiceState()
end
--[[ 
########################################################## 
LOAD AND CONSTRUCT
##########################################################
]]--
function PLUGIN:EnableAnsweringService()
	self:RegisterEvent("CHAT_MSG_IGNORED")
	self:RegisterUpdate("PhoneTimeUpdate", 4)

	self.Docklet = SV.Dock:NewDocklet("BottomLeft", "SVUI_ChatOMaticDock", "Answering Service", ICON_FILE, AnsweringOnClick)
	self.Docklet:SetFrameStrata("HIGH")
	self.Docklet:SetStylePanel("Default")

	local title = self.Docklet:CreateFontString("HenchmenOperatorText") 
	title:SetPoint("TOPLEFT", self.Docklet, "TOPLEFT", 0, -2)
	title:SetPoint("TOPRIGHT", self.Docklet, "TOPRIGHT", 0, -2)  
	title:SetHeight(50) 
	title:SetFontObject(GameFontNormal)
	title:SetTextColor(0.5, 0.5, 1, 1)
	title:SetJustifyH("CENTER")
	title:SetJustifyV("TOP")
	title:SetText("Henchman Answering Service")

	for x = 1, 5 do
		local phLn = CreateFrame("Button", "HenchmenPhoneLine"..x, self.Docklet)
		phLn:SetPoint("TOPLEFT", self.Docklet, "TOPLEFT", 8, ((-20) - (x * 25)))
		phLn:SetPoint("TOPRIGHT", self.Docklet, "TOPRIGHT", -8, ((-20) - (x * 25))) 
		phLn:SetHeight(20) 
		phLn:RegisterForClicks("AnyUp")
		phLn:SetScript("OnClick", PhoneLineClick)
		phLn:SetStylePanel("Fixed", "Button")
		phLn.Text = phLn:CreateFontString() 
		phLn.Text:SetPoint("TOPLEFT", phLn, "TOPLEFT", 0, 0)
		phLn.Text:SetPoint("TOPRIGHT", phLn, "TOPRIGHT", 0, 0)   
		phLn.Text:SetHeight(20) 
		phLn.Text:SetFontObject(GameFontNormalSmall)
		phLn.Text:SetTextColor(1, 1, 1, 1)
		phLn.Text:SetJustifyH("CENTER")
		phLn.Text:SetJustifyV("MIDDLE")
		phLn.Text:SetText("Empty Phone Line")
	end
	
	--self.Docklet:Hide()

	local strMsg
	if self.db.general.autoAnswer == true then
		strMsg = "The Henchmen Operators Are Screening Your Calls.."
	else
		strMsg = "The Henchmen Operators Are Standing By.."
	end
	SV:AddonMessage(strMsg)
	self.ServiceEnabled = true
end

function PLUGIN:DisableAnsweringService()
	self:UnregisterEvent("CHAT_MSG_IGNORED")
	self:UnregisterUpdate("PhoneTimeUpdate")
end