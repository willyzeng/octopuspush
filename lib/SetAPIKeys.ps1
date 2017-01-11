param($installPath, $toolsPath, $package, $project)

. .\WebRequestLib.ps1
. .\GetRancherIDs.ps1
#$global:projectName="default"
#$global:RancherServer="rancherdemo.chinaeast.cloudapp.chinacloudapi.cn"
function set-EnvironmentAPIKeys{
	param(
	$environmentAPIKeyName,
	$token,
	$setOctopusVariable=$false
	)
	
	$body = '{"type":"apikey","accountId":"","name":"","description":null,"created":null,"kind":null,"removed":null,"uuid":null}'
	$projectId=get-projectIdbyName $projectName
	$body=$body|ConvertFrom-Json
	$body.accountId = $projectId
	$body.name = $environmentAPIKeyName
	$body=$body|ConvertTo-Json
	$environmentAPIUrl="http://"+$RancherServer+":8080/v1/projects/"+$projectId+"/apikey"
	$value=send-postrequest $environmentAPIUrl $body|Select-Object -ExpandProperty secretValue
	if($setOctopusVariable){
		Set-OctopusVariable -name "environmentAPIKeyValue" -value $value
	}
}

function set-AccountAPIKeys{
	param(
	$accountAPIKeyName,
	$setOctopusVariable=$false
	)

	$body='{"type":"apikey","accountId":"","name":"","description":null,"created":null,"kind":null,"removeTime":null,"removed":null,"uuid":null}'
	$projectId=get-projectIdbyName $projectName
	$body=$body|ConvertFrom-Json
	$body.accountId = $projectId
	$body.name = $accountAPIKeyName
	$accountAPIUrl="http://"+$RancherServer+":8080/v1/apikey"
	$value=send-postrequest $accountAPIUrl $body|Select-Object -ExpandProperty secretValue
	if($setOctopusVariable){
	Set-OctopusVariable -name "accountAPIKeyValue" -value $value
	}
}