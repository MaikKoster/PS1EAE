---
external help file: PS1EAE-help.xml
Module Name: PS1EAE
online version:
schema: 2.0.0
---

# New-AEDeviceContent

## SYNOPSIS
Creates new ActiveEfficiency Device content.

## SYNTAX

```
New-AEDeviceContent [-AEServer] <String> [-DeviceID] <String> [-Name] <String> [-Version] <Int32>
 [[-Size] <Int32>] [[-NumberOfFiles] <Int32>] [[-Percent] <Int32>] [[-StartTime] <DateTime>]
 [[-EndTime] <DateTime>] [<CommonParameters>]
```

## DESCRIPTION
The New-AEDeviceContent Cmdlet creates new ActiveEfficiency Devices content.

## EXAMPLES

### EXAMPLE 1
```

```

## PARAMETERS

### -AEServer
Specified the URL of the 1E ActiveEfficiency server

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

### -Name
Specifies the content name
Typically the SCCM PackageID or Content ID of the application or update

```yaml
Type: String
Parameter Sets: (All)
Aliases: ContentName

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Version
Specifies the content version

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: True
Position: 4
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Size
Specifies the size of the content in Bytes

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

### -NumberOfFiles
Specifies the number of files of the content.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: 1
Accept pipeline input: False
Accept wildcard characters: False
```

### -Percent
Specifies the current percentage of the downloaded content
Will be 100% on default.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: 100
Accept pipeline input: False
Accept wildcard characters: False
```

### -StartTime
Specifies the starttime of the download

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: (Get-Date)
Accept pipeline input: False
Accept wildcard characters: False
```

### -EndTime
Specifies the endtime of the download

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: 9
Default value: (Get-Date)
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
CreatedBy is not supported by the api call.

## RELATED LINKS
