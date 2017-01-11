param($installPath, $toolsPath, $package, $project)

. .\WebRequestLib.ps1

#region Basic function
trap 
{
	Write-host "Error Category $($_.CategoryInfo.Category), Error Type $($_.Exception.GetType().FullName), ID: $($_.FullyQualifiedErrorID), Message: $($_.Exception.Message)"
}


function get-cataloginfourlbyversion{
    param(
        $catalogtemplateurl,
		$serviceversion
    )
    try{
        $result=(send-getrequest $catalogtemplateurl |ConvertFrom-Json|Select-Object -ExpandProperty versionLinks|Select-Object -ExpandProperty $serviceversion -ErrorAction Continue)
        return $result
    }
    catch{
        write-host $error[0]
        return $null
    }
}

#endregion Basic function


function excute-servicedeployment{
	param(
	$servicename,
	$catalogId,
	$serviceversion
	)
	$allowedretry=20
	$retrycount=0
	
	$body='{"type":"environment","name":"","startOnCreate":true,"environment":{},"dockerCompose":"","rancherCompose":"","externalId":""}'
	
	#$catalogtemplateurl="http://"+$RancherServer+":8080/v1-catalog/templates/"+$Catalogname+":"+$servicename+"?minimumRancherVersion_lte=v1.1.4" 
	#----minimumRancherVersion_lte can be get from v1/setting,but not necessary. 
	
	$catalogtemplateurl="http://"+$RancherServer+":8080/v1-catalog/templates/"+$catalogId+":"+$servicename
	
	
	$environmenturl = "http://"+$RancherServer+":8080/v1/projects/1a5/environment"


	$cataloginfo
	
	do{
		if ($retrycount){
			sleep 60
			Write-Host "Trying to get catalog infomation from $RancherServer....retry count $retrycount "
		}
		else{
			Write-Host "Trying to get catalog infomation from $RancherServer...."
		}
		$catalogteurl = get-cataloginfourlbyversion $catalogtemplateurl $serviceversion
		$environments=New-Object PSObject
		$cataloginfo = send-getrequest $catalogteurl
		
		$retrycount+=1
	}
	while ($retrycount -le $allowedretry -xor $cataloginfo -ne $null)
	
	if ($cataloginfo -eq $null){
		throw "Can not get catalog infomation...please check the server and retry"
	}
	
	$cataloginfo=$cataloginfo|ConvertFrom-Json
	
	$cataloginfo.questions|ForEach-Object{
		$environments|Add-Member -Type NoteProperty -Name $_.variable -Value $(Get-Variable $_.variable -ValueOnly)
	}
	
	$body=$body|ConvertFrom-Json
	$body.name=$servicename
	$body.environment=$environments
	$body.dockerCompose=$cataloginfo.files.'docker-compose.yml'
	$body.rancherCompose=$cataloginfo.files.'rancher-compose.yml'
	$body.externalId= "catalog://"+$cataloginfo.id
	$body=$body|ConvertTo-Json
	send-postrequest $environmenturl $body
}