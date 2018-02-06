<<<<<<< HEAD
#define TOOL_NONE 0
#define TOOL_CROWBAR 1
#define TOOL_MULTITOOL 2
#define TOOL_SCREWDRIVER 3
#define TOOL_WIRECUTTER 4
#define TOOL_WRENCH 5
=======
// Tool types
#define TOOL_CROWBAR 		"crowbar"
#define TOOL_MULTITOOL 		"multitool"
#define TOOL_SCREWDRIVER 	"screwdriver"
#define TOOL_WIRECUTTER 	"wirecutter"
#define TOOL_WRENCH 		"wrench"
#define TOOL_WELDER 		"welder"


// If delay between the start and the end of tool operation is less than MIN_TOOL_SOUND_DELAY,
// tool sound is only played when op is started. If not, it's played twice.
#define MIN_TOOL_SOUND_DELAY 20
>>>>>>> 100c4b6114... Adds new helper: use_tool, shakes things up in tool code (#35095)
