---
external help file: PS1EAE-help.xml
Module Name: PS1EAE
online version:
schema: 2.0.0
---

# Find-AEContent

## SYNOPSIS
Returns ActiveEfficiency Devices.

## SYNTAX

```
Find-AEContent [-AEServer] <String> [-Name] <String> [-Subnet] <String> [-Version] <String>
 [[-Extent] <String>] [[-Percent] <Int32>] [-AllSubnets] [-ExcludeDeviceTags] [-RandomizeResult]
 [[-Top] <Int32>] [[-Skip] <Int32>] [<CommonParameters>]
```

## DESCRIPTION
The Find-AEContent Cmdlet searches for Devices with the specified content.

## EXAMPLES

### EXAMPLE 1
```
PS C:\>$Url = (Get-AELocalDeviceInfo).PlatformUrl
```

PS C:\\\>$Sources = Find-AEContent -AEServer $Url -Name 'TST012345' -Version 1 -Subnet '10.10.10.0/24' -Extend Subnet

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

### -Name
Specifies the Content Name to find

```yaml
Type: String
Parameter Sets: (All)
Aliases: ContentName

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Subnet
Specifies the subnet for the content to find
Need to be supplied in CIDR format

```yaml
Type: String
Parameter Sets: (All)
Aliases: ipV4Subnet

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Version
Specifies the version of the content to find

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Extent
Specifies the extent of the search
Can be 'SiteOnly' or 'Subnet'.
Default is SiteOnly

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: SiteOnly
Accept pipeline input: False
Accept wildcard characters: False
```

### -Percent
Specifies the required percentage.
Defaults to 100%.
Is there a legit reason to look for anything below 100%?

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: 100
Accept pipeline input: False
Accept wildcard characters: False
```

### -AllSubnets
Specifies if all subnets of the site should be included in the search

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -ExcludeDeviceTags
Specifies if Device Tag should be excluded from the result

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -RandomizeResult
Specifies if the result should be randomized

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Top
Specifies how many entries should be returned in one batch

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

### -Skip
Specifies how many batches should be skipped

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
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
