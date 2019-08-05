$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$root = $here -replace "\\public|\\private|\\tests", ""
$ModuleName = 'PS1EAE'

# Import our module to use InModuleScope
if (-Not(Get-Module -Name "$ModuleName")) {
    Import-Module (Resolve-Path "$root\$ModuleName\$ModuleName.psd1") -Force
}

InModuleScope "$ModuleName" {
    Describe 'Get-AELocalDeviceInfo' {
        It 'Get Active Efficiency info from registry' {
            Mock Test-Path {$true}

            Mock Get-ItemProperty { [PSCustomObject]@{
                DeviceID = '4709f8a4-e36b-4cc3-81bd-0e8bc76d9c84'
                DeviceType = 2
                AdapterConfigurationId = '4709f8a4-e36b-4cc3-81bd-0e8bc76d9c85'
                ipv4 = '1.2.3.4'
                ipv4Subnet = '1.2.3.0/24'
                PlatformUrl = 'http://AE.mydomain.com/ActiveEfficiency'
                ContentProvider = 1
                ContentRegistration = 1
            }} -ParameterFilter {$Path -eq "HKLM:\\SOFTWARE\1E\NomadBranch\ActiveEfficiency"}

            Mock Get-ItemProperty { [PSCustomObject]@{
                HardwareId = '4709f8a4-e36b-4cc3-81bd-0e8bc76d9c86'
                UniqueIdentifier = '4709f8a4-e36b-4cc3-81bd-0e8bc76d9c87'
            }} -ParameterFilter {$Path -eq "HKLM:\\SOFTWARE\1E\Common"}

            $AEInfo = Get-AELocalDeviceInfo

            $AEInfo.DeviceID | Should Be '4709f8a4-e36b-4cc3-81bd-0e8bc76d9c84'
            $AEInfo.HardwareId | Should Be '4709f8a4-e36b-4cc3-81bd-0e8bc76d9c86'
        }

        It 'Return $null if ActiveEfficiency is not installed' {
            Mock Test-Path {$false}
            $AEInfo = Get-AELocalDeviceInfo
            $AEInfo | Should Be $null
        }
    }
}