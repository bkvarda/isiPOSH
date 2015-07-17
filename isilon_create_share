# Accept input parameters
Param([String]$isilonip,[String]$username,[String]$password,[String]$sharename,[String]$sharepath)

#if the correct parameters were not passed we exit after a message
if (!($sharename -and $sharepath )) {
   write "failed to specify parameters";
   write "Example: .\isilon_create_shares_auth.ps1 -isilonip xxx.xxx.xxx.xxx -username root -password a -sharename data -sharepath /ifs/data" ;
   exit
}

$baseurl = "https://" + $isilonip + ":8080"

#create Jason Object to auth
$jobj = convertto-json (New-Object PSObject -Property @{username= $username;password = $password; services = ("platform","namespace")})
$resourceurl = "/session/1/session"
$uri = $baseurl + $resourceurl

#create session and save cookie in variable $session
$ISIObject = Invoke-RestMethod -Uri  $uri -Body $jobj -ContentType "application/json; charset=utf-8" -Method POST -SessionVariable session
  
# Create share object
$obj = [pscustomobject]@{}
Add-Member -InputObject $obj -type NoteProperty -name name -Value $sharename
Add-Member -InputObject $obj -type NoteProperty -name path -Value $sharepath
$jobj = ConvertTo-Json $obj


# Send call to create share              
$resourceurl = "/platform/1/protocols/smb/shares"
$uri = $baseurl + $resourceurl
$ISIObject = Invoke-RestMethod -Uri $uri -WebSession $session -Method Post -Body $jobj -ContentType "application/json; charset=utf-8"
