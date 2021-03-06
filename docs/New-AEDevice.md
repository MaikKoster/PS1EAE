---
external help file: PS1EAE-help.xml
Module Name: PS1EAE
online version:
schema: 2.0.0
---

# New-AEDevice

## SYNOPSIS
Creates a new ActiveEfficiency Device

## SYNTAX

### ByUUID (Default)
```
New-AEDevice -AEServer <String> -HostName <String> -DomainName <String> [-Fqdn <String>] -SMBiosGuid <String>
 [-NomadUUID <String>] [-Type <String>] [-TypeID <Int32>] [-CreatedBy <String>] [<CommonParameters>]
```

### ByIdentities
```
New-AEDevice -AEServer <String> -HostName <String> -DomainName <String> [-Fqdn <String>]
 -Identities <PSObject[]> [-Type <String>] [-TypeID <Int32>] [-CreatedBy <String>] [<CommonParameters>]
```

## DESCRIPTION
The New-AEDevice Cmdlet creates a new ActiveEfficiency Device.
If a device with the same Identifiers exists already, the entry will be updated.
If multiple devices with the same Identifier exist, it will fail.

## EXAMPLES

### EXAMPLE 1
```

```

## PARAMETERS

### -AEServer
Specified the URI of the 1E ActiveEfficiency server

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -HostName
{{ Fill HostName Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DomainName
{{ Fill DomainName Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Fqdn
Specifies the Fqdn of the machine.
If not specified, it will be created based on Hostname and Domain name

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Identities
Specifies a list of Identities.
At least one must be defined
Each Identity should contain
- Source (eg "SMBIOS", or "FQDN")
- Identity (eg "AEC72B25-6D7E-11E1-8967-452301000030", or "MyMachine.Domain.com")
- CreatedBy

```yaml
Type: PSObject[]
Parameter Sets: ByIdentities
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SMBiosGuid
Specifies the SMBIOS GUID

```yaml
Type: String
Parameter Sets: ByUUID
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NomadUUID
Specifies the Nomad UniqueIdentifier
Typically stored in HKLM:\SOFTWARE\1E\Common

```yaml
Type: String
Parameter Sets: ByUUID
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Type
Specifies the Device Type

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Unknown
Accept pipeline input: False
Accept wildcard characters: False
```

### -TypeID
Specifies the Device Type ID
Can be specified if the underlying value is known
Takes precedence over "Type" if specified

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: -1
Accept pipeline input: False
Accept wildcard characters: False
```

### -CreatedBy
Specifies the Creator of the entry

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 1E Nomad
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
