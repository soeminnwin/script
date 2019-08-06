Start-Transcript -Path $(Join-Path $env:temp "DriveMapping.log")

$driveMappingConfig=@()

######################################################################
#                section script configuration                        #
######################################################################

<#
   Add your internal Active Directory Domain name and custom network drives below
#>

$dnsDomainName= "pacificlight.local"

$driveMappingConfig+= [PSCUSTOMOBJECT]@{
    DriveLetter = "I"
    UNCPath= "\\doclight\DavWWWRoot\IT"
    Description="IT Library 9"
}

$driveMappingConfig+= [PSCUSTOMOBJECT]@{
    DriveLetter = "Q"
    UNCPath= "\\doclight\IT\IT%20Library"
    Description="IT Library 10"
}

######################################################################
#               end section script configuration                     #
######################################################################

$connected=$false
$retries=0
$maxRetries=3

Write-Output "Starting script..."
do {
    
    if (Resolve-DnsName $dnsDomainName -ErrorAction SilentlyContinue){
    
        $connected=$true

    } else{
 
        $retries++
        
        Write-Warning "Cannot resolve: $dnsDomainName, assuming no connection to fileserver"
 
        Start-Sleep -Seconds 3
 
        if ($retries -eq $maxRetries){
            
            Throw "Exceeded maximum numbers of retries ($maxRetries) to resolve dns name ($dnsDomainName)"
        }
    }
 
}while( -not ($Connected))

#Map drives
    $driveMappingConfig.GetEnumerator() | ForEach-Object {

        Write-Output "Mapping network drive $($PSItem.UNCPath)"

        New-PSDrive -PSProvider FileSystem -Name $PSItem.DriveLetter -Root $PSItem.UNCPath -Description $PSItem.Description

        (New-Object -ComObject Shell.Application).NameSpace("$($PSItem.DriveLetter):").Self.Name=$PSItem.Description
}

Stop-Transcript
