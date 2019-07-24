$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$root = $here -replace "\\public|\\private|\\tests", ""
$ModuleName = 'PS1EAE'

# Import our module to use InModuleScope
if (-Not(Get-Module -Name "$ModuleName")) {
    Import-Module (Resolve-Path "$root\$ModuleName\$ModuleName.psd1") -Force
}

InModuleScope "$ModuleName" {
    Describe 'Get-AEDeviceContent' {
        $AEInfo = Get-AELocalDeviceInfo

        if ($null -ne $AEInfo) {
            It 'Return Device entry' {
                $DeviceContent = Get-AEDeviceContent -DeviceID $AEInfo.DeviceId -AEServer $AEInfo.PlatformUrl

                $DeviceContent | Should Not Be $null
                $DeviceContent.Count | Should BeGreaterThan 1
            }
        }

        It 'Throw if AE Server not supplied' {
            {Get-AEDevice -AEServer $null -DeviceID $null} | Should Throw
        }
    }
}