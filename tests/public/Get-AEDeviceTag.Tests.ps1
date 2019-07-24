$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$root = $here -replace "\\public|\\private|\\tests", ""
$ModuleName = 'PS1EAE'

# Import our module to use InModuleScope
if (-Not(Get-Module -Name "$ModuleName")) {
    Import-Module (Resolve-Path "$root\$ModuleName\$ModuleName.psd1") -Force
}

InModuleScope "$ModuleName" {
    Describe 'Get-AEDeviceTag' {

        $AEInfo = Get-AELocalDeviceInfo

        if ($null -ne $AEInfo) {
            It 'Return all device tags' {
                $Tags = Get-AEDeviceTag -DeviceID $AEInfo.DeviceID -AEServer $AEInfo.PlatformUrl

                $Tags | Should Not Be $null
                $Tags.Count | Should BeGreaterThan 1
            }

            It 'Return device tags by category' {
                $Tags = Get-AEDeviceTag -DeviceID $AEInfo.DeviceID -AEServer $AEInfo.PlatformUrl -Category 'Nomad'

                $Tags | Should Not Be $null
                $Tags.Count | Should BeGreaterThan 1

                $Tags = Get-AEDeviceTag -DeviceID $AEInfo.DeviceID -AEServer $AEInfo.PlatformUrl -Category 'Empty'

                $Tags | Should  Be $null
            }
        }

        It 'Throw if AE Server not supplied' {
            {Get-AEDevice -AEServer $null -DeviceID $null} | Should Throw
        }
    }
}