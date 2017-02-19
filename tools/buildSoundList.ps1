$oggFiles = Get-ChildItem -Recurse -Filter "*.ogg" -Name
$oggVariables = $oggFiles | %{$_ -replace "\\", "/"} | %{$_ -replace "'", "\'"} | %{$_ -replace "((?:[a-zA-Z0-9_/\\'-]|\s)*.ogg)`$", '	"$1" = ''$1'''}
$oggVariables = $oggVariables | %{$_ + ",\
"}
$output = "var/global/list/soundCache = list(
$oggVariables
`"NONE`" = null)"
$output | Out-File -encoding ascii code\modules\hippie\robustsound\cache.dm