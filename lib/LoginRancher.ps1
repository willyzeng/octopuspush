param($installPath, $toolsPath, $package, $project)
. .\Sessionbuilder.ps1
. .\WebRequestLib.ps1
#$global:RancherServer="rancherdemo.chinaeast.cloudapp.chinacloudapi.cn"

function excute-rancherlogin{
	param(
		$username,
		$password,
		$authProvider="localauthconfig"
	)

	$body = '{"code":"","authProvider":""}'
	$body=$body|ConvertFrom-Json
	$body.code = $username+':'+$password
	$body.authProvider = $authProvider
	$body=$body|ConvertTo-Json
	$loginURL="http://"+$RancherServer+":8080/v1/token"
	$token=send-postrequest $loginURL $body|Select-Object -ExpandProperty jwt
	if($token){
		$cookie = New-Object System.Net.Cookie("token",$token,"/")
		set-websessioncookie $loginURL $cookie
		$csrf = get-websessioncookiecsrf $loginURL
		set-websessionheadercsrf $csrf
		return $token
	}
	else{
		return 0
	}
}
