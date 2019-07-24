---
external help file: PS1EAE-help.xml
Module Name: PS1EAE
online version:
schema: 2.0.0
---

# Get-AEDeviceContentDownloadNotification

## SYNOPSIS
Returns ActiveEfficiency Device content download notifications.

## SYNTAX

```
Get-AEDeviceContentDownloadNotification [-AEServer] <String> [-DeviceID] <String> [[-Top] <Int32>]
 [[-Skip] <Int32>] [<CommonParameters>]
```

## DESCRIPTION
The Get-AEDeviceContentDownloadNotification Cmdlet returns ActiveEfficiency Device content download notifications.

## EXAMPLES

### EXAMPLE 1
```
$AEInfo = Get-AELocalDeviceInfo
```

PS C:\\\>$Notifications = Get-AEDeviceContentDownloadNotifications -AEServer $AEInfo.PlatformUrl -DeviceID $AEInfo.DeviceId

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
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Top
Specifies how many entries should be returned in one batch

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
