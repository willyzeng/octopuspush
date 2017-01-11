param($installPath, $toolsPath, $package, $project)


#region Basic function
function send-getrequest{
    param(
        $url,
		$token
         )
    $header=@{"Accept"="application/json"}
	 
	if($token){
		$tokenstr="PL=rancher; token="+$token+"; CSRF=3463F7FB1D7E8AA2A6F8B217882B6E04"
		$header.add("Cookie",$tokenstr)
	}
    try{
        $result=(Invoke-WebRequest $url -WebSession $session -UseBasicParsing) 
        $json=$result.content
        return $json
    }
    catch{
	    write-host $error[0]
        return $null
    }
}

function send-postrequest{
    param(
        $url,
        $body
        )

    Invoke-RestMethod $url -Method Post -WebSession $session -Body $body  -UseBasicParsing

}

function send-putrequest{
    param(
        $url,
        $body
        )

    Invoke-RestMethod $url -Method Put -WebSession $session -Body $body  -UseBasicParsing

}
#endregion Basic function