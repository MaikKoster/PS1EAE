$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$root = $here -replace "\\public|\\private|\\tests", ""
$ModuleName = 'PS1EAE'

# Import our module to use InModuleScope
if (-Not(Get-Module -Name "$ModuleName")) {
    Import-Module (Resolve-Path "$root\$ModuleName\$ModuleName.psd1") -Force
}

InModuleScope "$ModuleName" {
    Describe 'Get-AEDevice' {
        $AEInfo = Get-AELocalDeviceInfo

        if ($null -ne $AEInfo) {
            It 'Return Device entry' {
                $Device = Get-AEDevice -DeviceID $AEInfo.DeviceID -AEServer $AEInfo.PlatformUrl

                $Device | Should Not Be $null
            }

            It 'Return multiple Device entries' {
                $Devices = Get-AEDevice -AEServer $AEInfo.PlatformUrl

                $Devices.Count | Should BeGreaterThan 1

                if ($Devices.Count -gt 10) {
                    $Devices = Get-AEDevice -AEServer $AEInfo.PlatformUrl -Top 5

                    $Devices.Count | Should Be 5
                }
            }

        }

        It 'Throw if AE Server not supplied' {
            {Get-AEDevice -AEServer $null -DeviceID $null} | Should Throw
            {Get-AEDevice -AEServer $null} | Should Throw
        }
    }
}