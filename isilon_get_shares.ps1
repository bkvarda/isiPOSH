#If you want to enter parameters:
Param([String]$isilonip,[String]$username,[String]$password)

#If you want to encode user/pass entered:
$EncodedAuthorization = [System.Text.Encoding]::UTF8.GetBytes($username + ':' + $password)
$EncodedPassword = [System.Convert]::ToBase64String($EncodedAuthorization)

#if you want to check parameters passed:
#if the correct parameters were not passed we exit after a message
if (!($isilonip -and $username -and $password )) {
   write "failed to specify parameters";
   write "Example: .\isilon_get_shares.ps1 -isilonip xxx.xxx.xxx.xxx -username root -password a" ;
   exit
}

$baseurl = "https://" + $isilonip + ":8080"

#To disable the certificate validation for the current POSH session
[System.Net.ServicePointManager]::ServerCertificateValidationCallback = {$true}

#create Jason Object to auth
$jobj = convertto-json (New-Object PSObject -Property @{username= $username;password = $password; services = ("platform","namespace")})
$resourceurl = "/session/1/session"
$uri = $baseurl + $resourceurl

#create session and save cookie in variable $session
$ISIObject = Invoke-RestMethod -Uri  $uri -Body $jobj -ContentType "application/json; charset=utf-8" -Method POST -SessionVariable session 

# Get all defined shares              
$resourceurl = "/platform/1/protocols/smb/shares"
$uri = $baseurl + $resourceurl
$ISIObject = Invoke-RestMethod -Uri $uri -WebSession $session -Method Get -ContentType "application/json; charset=utf-8"
$ISIObject.shares
