param($installPath, $toolsPath, $package, $project)

. .\WebRequestLib.ps1
. .\GetRancherIDs.ps1
#$global:RancherServer="rancherdemo.chinaeast.cloudapp.chinacloudapi.cn"
function create-convoystorage{
	param(
	$storageName,
	$storageService="convoy-nfs",
	$projectName= "default"
	)
	$body = '{"type":"volume","driver":"","name":"","driverOpts":{},"accessMode":null,"created":null,"description":null,"externalId":null,"kind":null,"removed":null,"uri":null,"uuid":null}'
	$projectId=get-projectIdbyName $projectName
	$body=$body|ConvertFrom-Json
	$body.name = $storageName
	$body.driver = $storageService
	$body=$body|ConvertTo-Json
	$body.gettype()
	$storageAPIUrl="http://"+$RancherServer+":8080/v1/projects/"+$projectId+"/volume"
	$value=send-postrequest $storageAPIUrl $body
	
}

function set-convoystorage{
	param(
	$storageName,
	$storageService="convoy-nfs",
	$projectName= "default",
	$action="remove"
	)

	$storageUrl = get-convoystorageurl -storageName $storageName
	$actionUrl= $storageUrl+"/?action="+$action
	$returnvalue = send-postrequest $actionUrl $header
	$returnvalue
}

function get-convoystorageurl{
	param(
	$storageName,
	$projectName= "default"
	)

	$projectId = get-projectIdbyName $projectName
	$storageAPIUrl = "http://"+$RancherServer+":8080/v1/projects/"+$projectId+"/volume"
	$storageUrl = send-getrequest $storageAPIUrl|ConvertFrom-Json|Select-Object -ExpandProperty data|Where-Object name -eq test|Select-Object -ExpandProperty links|Select-Object -ExpandProperty self
	if ($storageUrl ){
		return $storageUrl
	}
	else{
		return 0
	}
		

}

function get-convoystoragestates{
	param(
	$storageName,
	$storageService="convoy-nfs",
	$projectName= "default",
	$propertyFilter
	)
	$storageUrl = get-convoystorageurl -storageName $storageName
	$state = send-getrequest $storageUrl |ConvertFrom-Json|Select-Object -ExpandProperty $propertyFilter
	if ($state ){
		return $state
	}
	else{
		return 0
	}
}