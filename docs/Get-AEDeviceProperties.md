---
external help file: PS1EAE-help.xml
Module Name: PS1EAE
online version:
schema: 2.0.0
---

# Get-AEDeviceProperties

## SYNOPSIS
Returns ActiveEfficiency Device properties.

## SYNTAX

```
Get-AEDeviceProperties [-AEServer] <String> [-DeviceID] <String> [<CommonParameters>]
```

## DESCRIPTION
The Get-AEDevice Cmdlet returns ActiveEfficiency Devices properties.

## EXAMPLES

### EXAMPLE 1
```
$AEInfo = Get-AELocalDeviceInfo
```

PS C:\\\>$SysProps = Get-AEDeviceProperties -AEServer $AEInfo.PlatformUrl -DeviceID $AEInfo.DeviceId

## PARAMETERS

### -AEServer
Specified the URI of the 1E ActiveEfficiency server

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DeviceID
Specifies the AE DeviceID

```yaml
Type: String
Parameter Sets: (All)
Aliases: Id

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
