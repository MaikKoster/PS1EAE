---
external help file: PS1EAE-help.xml
Module Name: PS1EAE
online version:
schema: 2.0.0
---

# Get-AELocalDeviceInfo

## SYNOPSIS
Returns AE related information about the local Device

## SYNTAX

```
Get-AELocalDeviceInfo [<CommonParameters>]
```

## DESCRIPTION
The Get-AELocalDeviceInfo Cmdlet returns the ActiveEfficiency related information of the local computer.

## EXAMPLES

### EXAMPLE 1
```
$AEInfo = Get-AELocalDeviceInfo
```

## PARAMETERS

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Reads AE related information from the local registry.
If ActiveEfficieny isn't configured, $null will be returned.

## RELATED LINKS
