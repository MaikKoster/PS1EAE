---
external help file: PS1EAE-help.xml
Module Name: PS1EAE
online version:
schema: 2.0.0
---

# Get-AEDevice

## SYNOPSIS
Returns ActiveEfficiency Devices.

## SYNTAX

### SingleDevice (Default)
```
Get-AEDevice -AEServer <String> [-DeviceID <String>] [-Top <Int32>] [-Skip <Int32>] [<CommonParameters>]
```

### NeighboringDevices
```
Get-AEDevice -AEServer <String> [-Subnet <String>] [-Top <Int32>] [-Skip <Int32>] [<CommonParameters>]
```

### AllDeviceIDs
```
Get-AEDevice -AEServer <String> [-IDOnly] [-Top <Int32>] [-Skip <Int32>] [<CommonParameters>]
```

## DESCRIPTION
The Get-AEDevice Cmdlet returns  ActiveEfficiency Devices.

## EXAMPLES

### EXAMPLE 1
```
$Url = (Get-AELocalDeviceInfo).PlatformUrl
```

PS C:\\\>$Devices = Get-AEDevice -AEServer $Url

## PARAMETERS

### -AEServer
Specified the URI of the 1E ActiveEfficiency server

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DeviceID
Specifies the AE DeviceID

```yaml
Type: String
Parameter Sets: SingleDevice
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Subnet
Specifies the subnet for all neigboring devices to return

```yaml
Type: String
Parameter Sets: NeighboringDevices
Aliases: ipV4Subnet

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -IDOnly
Specifies if only the Devide Ids should be returned
Doesn't apply if DeviceID is supplied

```yaml
Type: SwitchParameter
Parameter Sets: AllDeviceIDs
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Top
Specifies how many entries should be returned in one batch
Default is 100.
Set to 0 to return all entries
Doesn't apply if DeviceID is supplied

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 100
Accept pipeline input: False
Accept wildcard characters: False
```

### -Skip
Specifies how many batches should be skipped
Doesn't apply if DeviceID is supplied

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
