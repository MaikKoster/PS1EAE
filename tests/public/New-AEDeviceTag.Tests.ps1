$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$root = $here -replace "\\public|\\private|\\tests", ""
$ModuleName = 'PS1EAE'

# Import our module to use InModuleScope
#if (-Not(Get-Module -Name "$ModuleName")) {
    Import-Module (Resolve-Path "$root\$ModuleName\$ModuleName.psd1") -Force
#}

InModuleScope "$ModuleName" {
    Describe 'New-AEDeviceTag' {

        $AEInfo = Get-AELocalDeviceInfo

        # Beware, Tags can only be created but not deleted.
        if ($null -ne $AEInfo) {
            It 'Create new tag' {
                $NewTag = New-AEDeviceTag -DeviceID $AEInfo.DeviceID -AEServer $AEInfo.PlatformUrl -Category 'Test' -Name 'TestName' -Value 'TestValue' -CreatedBy 'PS1EAE'

                $NewTag | Should Not Be $null
                $NewTag.Category | Should Be 'Test'
                $NewTag.Name | Should Be 'TestName'
                $NewTag.StringValue | Should Be 'TestValue'
                $NewTag.Index | Should Be 0
                $NewTag.CreatedBy | Should Be 'PS1EAE'
            }
        }

        It 'Throw if AE Server not supplied' {
            {New-AEDeviceTag -AEServer $null -DeviceID $null} | Should Throw
            {New-AEDeviceTag -AEServer $null} | Should Throw
        }
    }
}