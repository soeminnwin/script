Start-Transcript -Path $(Join-Path $env:temp "DriveMapping.log")

$driveMappingConfig=@()

######################################################################
#                section script configuration                        #
######################################################################

<#
   Add your internal Active Directory Domain name and custom network drives below
#>

$dnsDomainName= "pacificlight.local"

$driveMappingConfig+=  [PSCUSTOMOBJECT]@{
    DriveLetter = "R"
    UNCPath= "\\SNG-FS-01\PacificLight Singapore"
    Description="PacificLight Singapore"
}

$driveMappingConfig+=  [PSCUSTOMOBJECT]@{
    DriveLetter = "S"
    UNCPath= "\\SNG-FS-01\PacificLight Power (City)"
    Description="PacificLight Power (City)"
}

$driveMappingConfig+=  [PSCUSTOMOBJECT]@{
    DriveLetter = "T"
    UNCPath= "\\SNG-FS-01\Historic Files from IG"
    Description="Historic Files from IG"
}

$driveMappingConfig+= [PSCUSTOMOBJECT]@{
    DriveLetter = "I"
    UNCPath= "\\doclight.pacificlight.local\IT\IT Library"
    Description="IT Library"
}

$driveMappingConfig+= [PSCUSTOMOBJECT]@{
    DriveLetter = "J"
    UNCPath= "\\doclight.pacificlight.local\IT\IT%20Library"
    Description="IT Library 2"
}

$driveMappingConfig+= [PSCUSTOMOBJECT]@{
    DriveLetter = "K"
    UNCPath= "\\172.108.40.42\IT\IT%20Library"
    Description="IT Library 3"
}

$driveMappingConfig+= [PSCUSTOMOBJECT]@{
    DriveLetter = "L"
    UNCPath= "\\172.108.40.42\IT\IT Library"
    Description="IT Library 4"
}

$driveMappingConfig+= [PSCUSTOMOBJECT]@{
    DriveLetter = "M"
    UNCPath= "http://doclight/IT/IT Library"
    Description="IT Library 5"
}

$driveMappingConfig+= [PSCUSTOMOBJECT]@{
    DriveLetter = "N"
    UNCPath= "http://doclight/IT/IT%20Library"
    Description="IT Library 6"
}

$driveMappingConfig+= [PSCUSTOMOBJECT]@{
    DriveLetter = "O"
    UNCPath= "\\doclight\IT\IT Library"
    Description="IT Library 7"
}

$driveMappingConfig+= [PSCUSTOMOBJECT]@{
    DriveLetter = "P"
    UNCPath= "\\doclight\IT\IT%20Library"
    Description="IT Library 8"
}

$driveMappingConfig+= [PSCUSTOMOBJECT]@{
    DriveLetter = "R"
    UNCPath= "\\doclight\DavWWWRoot\IT"
    Description="IT Library 9"
}

$driveMappingConfig+= [PSCUSTOMOBJECT]@{
    DriveLetter = "S"
    UNCPath= "\\doclight\DavWWWRoot\IT\IT%20Library"
    Description="IT Library 10"
}

######################################################################
#               end section script configuration                     #
######################################################################

$connected=$false
$retries=0
$maxRetries=3

$Cred = Get-Credential

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

        New-PSDrive -PSProvider FileSystem -Name $PSItem.DriveLetter -Root $PSItem.UNCPath -Description $PSItem.Description -Credential $Cred -Persist -Scope global

        (New-Object -ComObject Shell.Application).NameSpace("$($PSItem.DriveLetter):").Self.Name=$PSItem.Description
}

Stop-Transcript
