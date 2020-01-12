GLOBAL_VAR_INIT(nasheed_playing, FALSE)
GLOBAL_VAR_INIT(remote_control, TRUE)

GLOBAL_VAR_INIT(internal_tick_usage, 0.2 * world.tick_lag) //This var is updated every tick by a DLL if present, used to reduce lag 
