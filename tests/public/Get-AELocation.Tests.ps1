$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$root = $here -replace "\\public|\\private|\\tests", ""
$ModuleName = 'PS1EAE'

# Import our module to use InModuleScope
#if (-Not(Get-Module -Name "$ModuleName")) {
    Import-Module (Resolve-Path "$root\$ModuleName\$ModuleName.psd1") -Force
#}

InModuleScope "$ModuleName" {
    Describe 'Get-AELocation' {

        $AEInfo = Get-AELocalDeviceInfo

        if ($null -ne $AEInfo) {
            It "Return a list of all locations" {
                $Locations = Get-AELocation -AEServer $AEInfo.PlatformUrl

                $Locations | Should not be $null
                $Locations.Count | Should BeGreaterThan 1

                if ($Locations.Count -gt 10) {
                    $Locations = Get-AELocation -AEServer $AEInfo.PlatformUrl -Top 5

                    $Locations.Count | Should Be 5
                }
            }

            It 'Return Location entry' {
                $Locations = Get-AELocation -AEServer $AEInfo.PlatformUrl -Top 1 -Skip 1

                if ($null -ne $Locations) {
                    $Location = Get-AELocation -LocationID ($Locations[0].Id) -AEServer $AEInfo.PlatformUrl
                    $Location | Should Not Be $null

                    $Location.Id | Should Be ($Locations[0].Id)
                }
            }

        }

        It 'Throw if AE Server not supplied' {
            {Get-AELocation -AEServer $null -LocationID $null} | Should Throw
            {Get-AELocation -AEServer $null } | Should Throw
        }
    }
}