---
external help file: PS1EAE-help.xml
Module Name: PS1EAE
online version:
schema: 2.0.0
---

# Update-AEDeviceTag

## SYNOPSIS
Updates a single device tag

## SYNTAX

```
Update-AEDeviceTag [-AEServer] <String> [-DeviceID] <String> [-Category] <String> [-Name] <String>
 [-Index] <Int32> [[-Value] <String>] [[-CreatedBy] <String>] [<CommonParameters>]
```

## DESCRIPTION
The Update-AEDeviceTag Cmdlet updates a single device tag.
Device tags are identified by category, name and index.
They do not have an explicit
id.

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
Aliases: Id

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Category
Specifies the category (namespace) for the tag.
The category and name uniquely identify the resource.
Category is mandatory.
It must not be null, empty or only whitespace.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Name
Specifies the tag name.
Name is mandatory.
It must not be null, empty or only whitespace.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 4
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Index
Specifies the tag index.
Will be 0 on default.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: True
Position: 5
Default value: 0
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Value
Specifies the actual value of the tag.
TODO: Implement handling of different types

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -CreatedBy
Specifies the name of the client creating the tag entry.
Currently not mandatory.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: 1E Nomad
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
