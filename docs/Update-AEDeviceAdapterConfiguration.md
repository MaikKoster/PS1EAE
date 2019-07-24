---
external help file: PS1EAE-help.xml
Module Name: PS1EAE
online version:
schema: 2.0.0
---

# Update-AEDeviceAdapterConfiguration

## SYNOPSIS
Updates an existing Active Efficiency Device adapter configuration.

## SYNTAX

```
Update-AEDeviceAdapterConfiguration [-AEServer] <String> [-DeviceID] <String>
 [-AdapterConfigurationID] <String> [-IP] <String> [-Subnet] <String> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The Update-AEDeviceAdapterConfiguration Cmdlet updates an existing ActiveEfficiency Device adapter configuration.

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
Accept pipeline input: False
Accept wildcard characters: False
```

### -AdapterConfigurationID
Specifies the AE DeviceID

```yaml
Type: String
Parameter Sets: (All)
Aliases: Id

Required: True
Position: 3
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -IP
Specifies the IPv4 address of the adapter

```yaml
Type: String
Parameter Sets: (All)
Aliases: IPv4

Required: True
Position: 4
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Subnet
Specifies the IPv4 subnet for the adapter
Need to be supplied in CIDR format

```yaml
Type: String
Parameter Sets: (All)
Aliases: ipV4Subnet

Required: True
Position: 5
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
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
