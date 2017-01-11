param($installPath, $toolsPath, $package, $project)

. .\WebRequestLib.ps1
#$global:RancherServer="rancherdemo.chinaeast.cloudapp.chinacloudapi.cn"
function get-projectIdbyName{
	param(
	$projectName
	)
	
	$projectURL="http://"+$RancherServer+":8080/v1/projects/"
	$projectID=send-getrequest $projectURL |ConvertFrom-Json|Select-Object -ExpandProperty data|Where-Object name -eq $projectName|Select-Object -ExpandProperty id
	if($projectID){
		return $projectID
	}
	else{
		return 0
	}
}

function get-accountIdbyName{
	param(
	$accountName
	)
	
	$accountURL="http://"+$RancherServer+":8080/v1/accounts/"
	$accountID=send-getrequest $accountURL|ConvertFrom-Json|Select-Object -ExpandProperty data|Where-Object name -eq $accountName|Select-Object -ExpandProperty id
	if($accountID){
		return $accountID
	}
	else{
		return 0
	}
}