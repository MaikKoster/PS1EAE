---
external help file: PS1EAE-help.xml
Module Name: PS1EAE
online version:
schema: 2.0.0
---

# Get-AELocation

## SYNOPSIS
Returns ActiveEfficiency Locations.

## SYNTAX

```
Get-AELocation [-AEServer] <String> [[-LocationID] <String>] [[-Top] <Int32>] [[-Skip] <Int32>]
 [<CommonParameters>]
```

## DESCRIPTION
The Get-AELocations Cmdlet returns ActiveEfficiency Locations.

## EXAMPLES

### EXAMPLE 1
```
$AEInfo = Get-AELocalDeviceInfo
```

PS C:\\\>$Locations = Get-AELocation -AEServer $AEInfo.PlatformUrl

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

### -LocationID
Specifies the AE LocationID

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Top
Specifies how many entries should be returned in one batch
Default is 100.
Set to 0 to return all entries
Doesn't apply if LocationID is supplied

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: 100
Accept pipeline input: False
Accept wildcard characters: False
```

### -Skip
Specifies how many batches should be skipped
Doesn't apply if LocationID is supplied

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
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
