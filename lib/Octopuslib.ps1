

$global:apikey="API-Y9O3Q66GNYEND8LJDPWOEPLSWR4"
$octopusaddress="octdemo.chinaeast.cloudapp.chinacloudapi.cn"
$octopusport="8088"
$global:octopusurl="http://"+$octopusaddress+":"+$octopusport
$octopuslinks=""
$global:apikeyappend="?apiKey="+$global:apikey
$global:session = New-Object Microsoft.PowerShell.Commands.WebRequestSession

function initial-websessionheader{

	$session.Headers.Add("Content-Type","application/json")
	$session.Headers.Add("Accept-Encoding","gzip, deflate, sdch")
	$session.Headers.Add("Accept-Language","en-US,en;q=0.8")
	$session.Headers.Add("Accept","application/json")
	$session.Headers.Add("X-HTTP-Method-Override","PUT")
}

. .\WebRequestLib.ps1



#Usage: get "links" property of library variable, fileter by $libraryname
function get-octopuslibraryvariableslinks{
    param(

        $libraryname
    )

    $variableapi=$octopusurl+"/api/libraryvariablesets"+$apikeyappend
    if($libraryname){
        send-getrequest $variableapi|ConvertFrom-Json|Select-Object -ExpandProperty Items|Where-Object name -EQ $libraryname
        }
    else{
        send-getrequest $variableapi|ConvertFrom-Json|Select-Object -ExpandProperty Items
    }
}


#get api appendix for variables of selected library
function get-octopuslibraryvariablesurl{
    param(

        $libraryname
    )

    $api= get-octopuslibraryvariableslinks $libraryname|Select-Object -ExpandProperty Links|Select-Object -ExpandProperty Variables
    return $api
}


#get variables info and save as a JSON object
function get-octopuslibraryvariables{
    param(

        $libraryname
    )
    #get-octopuslibraryvariablesurl $libraryname
    $libraryapi=$octopusurl+(get-octopuslibraryvariablesurl $libraryname)+$apikeyappend
    send-getrequest $libraryapi|ConvertFrom-Json
}



#invoke get-octopuslibraryvariables method and replace a variable value
function replace-octopusvariable{
    param(
        $libraryname,
        $variablename,
        $replacevalue
    )
    $variableset=get-octopuslibraryvariables $libraryname
    $rec=$variableset.variables|Where-Object Name -eq $variablename
    $rec.Value=$replacevalue
    $variableset
}


#replace-octopusvariable $libraryname serviceversion_rabbitmq "v1.0.0-rc3">log.txt


#commit the new variable change
function update-octopusvariable{
    param(
        $libraryname,
        $variablename,
        $replacevalue
    )
    $libraryapi=$octopusurl+$(get-octopuslibraryvariablesurl $libraryname)+$apikeyappend
    $updatevalue = replace-octopusvariable $libraryname $variablename $replacevalue
    $updatevalue=$updatevalue|ConvertTo-Json -Depth 999
    send-putrequest $libraryapi $updatevalue 
}


#replace-octopusvariable $libraryname serviceversion_rabbitmq "v1.0.0-rc5"|ConvertTo-Json -Depth 999 > log.txt