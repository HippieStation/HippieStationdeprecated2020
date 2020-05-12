#define GLOBAL_PROC	"some_magic_bullshit"

#define CALLBACK new /datum/callback
#define INVOKE_ASYNC world.ImmediateInvokeAsync
#define CALLBACK_NEW(typepath, args) CALLBACK(GLOBAL_PROC, /proc/___callbacknew, typepath, args)
