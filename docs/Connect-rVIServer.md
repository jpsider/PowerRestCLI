---
external help file: PowerRestCLI-help.xml
Module Name: powerrestcli
online version:
schema: 2.0.0
---

# Connect-rVIServer

## SYNOPSIS

## SYNTAX

### NoCreds
```
Connect-rVIServer -vCenter <String> [<CommonParameters>]
```

### PlainText
```
Connect-rVIServer -vCenter <String> -User <String> -Password <SecureString> [<CommonParameters>]
```

### Credential
```
Connect-rVIServer -vCenter <String> -Credential <PSCredential> [<CommonParameters>]
```

## DESCRIPTION
Retrieve a Session token from vSphere API server.

## EXAMPLES

### EXAMPLE 1
```
Connect-rVIServer -vCenter $vCenter -Credential $Credentials
```

### EXAMPLE 2
```
Connect-rVIServer -vCenter $vCenter -user "administrator@corp.local" -password (ConvertTo-SecureString "VMware1!" -AsPlainText -force)
```

### EXAMPLE 3
```
Connect-rVIServer -vCenter $vCenter -user "administrator@corp.local" -password (read-host -AsSecureString)
```

### EXAMPLE 4
```
Connect-rVIServer -vCenter $vCenter
```

## PARAMETERS

### -vCenter
A valid vCenter IP/Name is required as a variable called $vCenter

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

### -Credential
A valid Credential set is required

```yaml
Type: PSCredential
Parameter Sets: Credential
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -User
A valid vCenter User is required

```yaml
Type: String
Parameter Sets: PlainText
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Password
A valid vCenter Password is required

```yaml
Type: SecureString
Parameter Sets: PlainText
Aliases:

Required: True
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

### System.Boolean

## NOTES
Returns a Session to the powershell console, If the variable is global it does not need
to be catpured in a variable.

## RELATED LINKS
