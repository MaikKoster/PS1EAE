function Get-AELocalDeviceInfo {
    <#
        .SYNOPSIS
        Returns AE related information about the local Device

        .DESCRIPTION
        The Get-AELocalDeviceInfo Cmdlet returns the ActiveEfficiency related information of the local computer.

        .NOTES
        Reads AE related information from the local registry. If ActiveEfficieny isn't configured, $null will be returned.

        .EXAMPLE
        PS C:\>$AEInfo = Get-AELocalDeviceInfo
    #>
    [CmdLetBinding()]
    param()

    process{
        if (Test-Path -Path "HKLM:\\SOFTWARE\1E\NomadBranch\ActiveEfficiency") {
            $AE = Get-ItemProperty -Path "HKLM:\\SOFTWARE\1E\NomadBranch\ActiveEfficiency" -ErrorAction SilentlyContinue

            if ($null -ne $AE) {
                $AEInfo = [PSCustomObject]@{
                    DeviceID = $AE.DeviceID
                    DeviceType = $AE.NomadDeviceType
                    AdapterConfigurationId = $AE.AdapterConfigurationId
                    ipv4 = $AE.ipv4
                    ipv4Subnet = $AE.ipv4Subnet
                    PlatformUrl = $AE.PlatformUrl
                    ContentProvider = ($AE.ContentProvider -eq 1)
                    ContentRegistration = ($AE.ContentRegistraiton -eq 1)
                }
            }
        }

        if (($null -ne $AEInfo) -and  (Test-Path -Path "HKLM:\\SOFTWARE\1E\Common")) {
            $1E = Get-ItemProperty -Path "HKLM:\\SOFTWARE\1E\Common" -ErrorAction SilentlyContinue

            if ($null -ne $1E) {
                $AEInfo | Add-Member -MemberType NoteProperty -Name "HardwareId" -Value ($1E.HardwareId)
                $AEInfo | Add-Member -MemberType NoteProperty -Name "UniqueIdentifier" -Value ($1E.UniqueIdentifier)
            }
        }

        Write-Output $AEInfo
    }
}