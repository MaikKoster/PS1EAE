---
external help file: PS1EAE-help.xml
Module Name: PS1EAE
online version:
schema: 2.0.0
---

# Get-AEAllDeviceIDs

## SYNOPSIS
Returns all Active Efficiency Device IDs.

## SYNTAX

```
Get-AEAllDeviceIDs [-AEServer] <String> [<CommonParameters>]
```

## DESCRIPTION
The Get-AEAllDeviceIDs Cmdlet returns all Active Efficiency Device IDs.

## EXAMPLES

### EXAMPLE 1
```
$Url = (Get-AELocalDeviceInfo).PlatformUrl
```

PS C:\\\>$DeviceIDs = Get-AEAllDeviceIDs -AEServer $Url

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
