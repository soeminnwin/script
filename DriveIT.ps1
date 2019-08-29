Start-Transcript -Path $(Join-Path $env:temp "DriveMapping.log")

        NET USE I: "\\doclight\DavWWWRoot\sites\IT\IT%20Library" /Persistent:YES
        NET USE S: "\\lcshare2010\DavWWWRoot\sites\alfaconnections\technical" /Persistent:YES

Stop-Transcript
