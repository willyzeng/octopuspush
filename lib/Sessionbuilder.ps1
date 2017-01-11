$global:session = New-Object Microsoft.PowerShell.Commands.WebRequestSession

function set-websessioncookie{
	param(
		$url,
		$cookie
	)
	$session.Cookies.Add($url,$cookie)
	
}

function initial-websessionheader{

	$session.Headers.Add("Content-Type","application/json")
	$session.Headers.Add("x-api-no-challenge","true")
	$session.Headers.Add("X-Requested-With","XMLHttpRequest")
	$session.Headers.Add("Accept-Encoding","gzip, deflate, sdch")
	$session.Headers.Add("Accept-Language","en-US,en;q=0.8")
	$session.Headers.Add("Accept","application/json")
	$session.Headers.Add("x-api-csrf","24DF63DB98741169E761E0665C595F35")
	$session.Headers.Add("Cache-Control","no-cache")
}

function set-websessionheadercsrf{
	param(
		$csrf
	)

	$session.Headers.'x-api-csrf'=$csrf

}

function get-websessioncookiecsrf{
	param(
		$url
	)

	$csrf=$session.Cookies.GetCookies($url)|Where-Object -Property Name -eq "CSRF"|Select-Object -ExpandProperty Value
	return $csrf

}

initial-websessionheader

$session