# Accept input parameters
Param([String]$isilonip,[String]$username,[String]$password,[String]$sharename)

#if the correct parameters were not passed we exit after a message
if (!($isilonip -and $username -and $password -and $sharename)) {
   write "failed to specify parameters";
   write "Example: .\isilon_delete_shares_auth.ps1 -isilonip xxx.xxx.xxx.xxx -username root -password a -sharename data" ;
   exit
}


$baseurl = "https://" + $isilonip + ":8080"

#create Jason Object to auth
$jobj = convertto-json (New-Object PSObject -Property @{username= $username;password = $password; services = ("platform","namespace")})
$resourceurl = "/session/1/session"
$uri = $baseurl + $resourceurl

#create session and save cookie in variable $session
$ISIObject = Invoke-RestMethod -Uri  $uri -Body $jobj -ContentType "application/json; charset=utf-8" -Method POST -SessionVariable session
  

# Send call to Delete share              
$resourceurl = "/platform/1/protocols/smb/shares/"
$uri = $baseurl + $resourceurl + $sharename
$uri
$ISIObject = Invoke-RestMethod -Uri $uri -WebSession $session -Method Delete -ContentType "application/json; charset=utf-8"
