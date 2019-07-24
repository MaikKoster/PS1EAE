---
external help file: PS1EAE-help.xml
Module Name: PS1EAE
online version:
schema: 2.0.0
---

# Get-AEDeviceTag

## SYNOPSIS
Returns ActiveEfficiency Device tags.

## SYNTAX

```
Get-AEDeviceTag [-AEServer] <String> [-DeviceID] <String> [[-Category] <String>] [[-Name] <String>]
 [[-Index] <Int32>] [<CommonParameters>]
```

## DESCRIPTION
The Get-AEDevice Cmdlet returns ActiveEfficiency Device tags.

## EXAMPLES

### EXAMPLE 1
```
$AEInfo = Get-AELocalDeviceInfo
```

PS C:\\\>$Tags = Get-AEDeviceTag -AEServer $AEInfo.PlatformUrl -DeviceID $AEInfo.DeviceId

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
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Category
Specifies the Tag Category

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
Specifies the Tag name

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Index
Specifies the Tag Index

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
