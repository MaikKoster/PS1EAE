function Get-AEDevice {
    <#
        .SYNOPSIS
        Returns ActiveEfficiency Devices.

        .DESCRIPTION
        The Get-AEDevice Cmdlet returns  ActiveEfficiency Devices.

        .EXAMPLE
        PS C:\>$Url = (Get-AELocalDeviceInfo).PlatformUrl
        PS C:\>$Devices = Get-AEDevice -AEServer $Url

    #>
    [CmdLetBinding(DefaultParameterSetName="SingleDevice")]
    param(
        # Specified the URI of the 1E ActiveEfficiency server
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$AEServer,

        # Specifies the AE DeviceID
        [Parameter(ParameterSetName="SingleDevice")]
        [string]$DeviceID,

        # Specifies the subnet for all neigboring devices to return
        [Parameter(ParameterSetName="NeighboringDevices")]
        [ValidateNotNullOrEmpty()]
        [ValidateScript({$_ -match "^([0-9]{1,3}\.){3}[0-9]{1,3}(\/([0-9]|[1-2][0-9]|3[0-2]))?$"})]
        [Alias("ipV4Subnet")]
        [string]$Subnet,

        # Specifies if only the Devide Ids should be returned
        # Doesn't apply if DeviceID is supplied
        [Parameter(ParameterSetName="AllDeviceIDs")]
        [switch]$IDOnly,

        # Specifies how many entries should be returned in one batch
        # Default is 100. Set to 0 to return all entries
        # Doesn't apply if DeviceID is supplied
        [int]$Top = 100,

        # Specifies how many batches should be skipped
        # Doesn't apply if DeviceID is supplied
        [int]$Skip = 0
    )

    process{
        if (-Not([string]::IsNullOrWhiteSpace($DeviceID))) {
            $Path = "Devices/$DeviceID"
        } else {
            if ($Top -gt 0 ) {
                $Body = @{
                    '$Top' = $Top
                    '$Skip' = $Skip
                }
            }

            if (-Not([string]::IsNullOrWhiteSpace($Subnet))) {
                $Path = "Subnets/$($Subnet -replace "/", "!FS")/NeighboringDevices"
            } else {
                if ($IDOnly.IsPresent) {
                    $Path = "AllDeviceIds"
                } else {
                    $Path = "Devices"
                }
            }
        }

        Invoke-AERequest -Method Get -AEServer $AEServer -ResourcePath $Path -Body $Body
    }
}