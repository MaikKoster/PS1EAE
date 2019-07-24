$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$root = $here -replace "\\public|\\private|\\tests", ""
$ModuleName = 'PS1EAE'

# Import our module to use InModuleScope
#if (-Not(Get-Module -Name "$ModuleName")) {
    Import-Module (Resolve-Path "$root\$ModuleName\$ModuleName.psd1") -Force
#}

InModuleScope "$ModuleName" {
    Describe 'New-AEDevice' {

        $AEInfo = Get-AELocalDeviceInfo

        # As there is no option to remove devices, please be restrictive when testing
        # if ($null -ne $AEInfo) {
        #     It 'Return Device entry' {
        #         $Identities = @(@{Source="SMBIOS";Identity="$([guid]::NewGuid())"},@{Source="FQDN";Identity="AETestEntry.TEST.com"})
        #         $NewDevice = New-AEDevice -AEServer $AEInfo.PlatformUrl -HostName "AETestEntry" -DomainName "TEST.com" -Identities $Identities -Type Desktop -CreatedBy "PS1EAE"

        #         $NewDevice
        #         $NewDevice | Should Not Be $null
        #     }
        # }

        It 'Throw if AE Server not supplied' {
            {New-AEDevice -AEServer $null -DeviceID $null} | Should Throw
            {New-AEDevice -AEServer $null} | Should Throw
        }
    }
}