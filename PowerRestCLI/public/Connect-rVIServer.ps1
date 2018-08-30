function Connect-rVIServer
{
    <#
	.DESCRIPTION
		Retrieve a Session token from vSphere API server.
    .PARAMETER vCenter
        A valid vCenter IP/Name is required as a variable called $vCenter
    .PARAMETER User
        A valid vCenter User is required
    .PARAMETER Password
        A valid vCenter Password is required
    .PARAMETER Credential
        A valid Credential set is required
	.EXAMPLE
        Connect-rVIServer -vCenter $vCenter -Credential $Credentials
	.EXAMPLE
        Connect-rVIServer -vCenter $vCenter -user "administrator@corp.local" -password (ConvertTo-SecureString "VMware1!" -AsPlainText -force)
	.EXAMPLE
        Connect-rVIServer -vCenter $vCenter -user "administrator@corp.local" -password (read-host -AsSecureString)
    .EXAMPLE
        Connect-rVIServer -vCenter $vCenter
	.NOTES
        Returns a Session to the powershell console, If the variable is global it does not need
        to be catpured in a variable.
    #>
    [CmdletBinding()]
    [OutputType([boolean])]
    param(
        [Parameter(Mandatory = $true, ParameterSetName = 'Credential')]
        [Parameter(Mandatory = $true, ParameterSetName = 'PlainText')]
        [Parameter(Mandatory = $true, ParameterSetName = 'NoCreds')]
        [string]$vCenter,
        [Parameter(Mandatory = $true,
            ParameterSetName = 'Credential')]
        [System.Management.Automation.PSCredential]$Credential,
        [Parameter(Mandatory = $true,
            ParameterSetName = 'PlainText')]
        [string]$User,
        [Parameter(Mandatory = $true,
            ParameterSetName = 'PlainText')]
        [System.Security.SecureString]$Password
    )
    try
    {
        # Ensure the PowerShell environment is set up to ignore self signed certs.
        if (Disable-SSLValidation)
        {
            # SSL Validation was Disabled
        }
        else
        {
            Throw "Connect-rVIServer: Unable to Disable SSL Validation."
        }
        # Determine the credential type to create appropriate header.
        if ($PSCmdlet.ParameterSetName -eq 'NoCreds')
        {
            # No Credential information was presented. Prompt user for credentials.
            $Credential = Get-Credential
        }
        elseif ($PSCmdlet.ParameterSetName -eq 'PlainText')
        {
            # User passed in Username/Password combo.
            $Credential = New-Object System.Management.Automation.PSCredential -ArgumentList ($User, $Password)
        }
        else
        {
            # User provided Credential Variable, No action needed.
        }
        # Insert the Credentials into the Header
        $script:headers = New-rVIHeader -Credential $Credential

        # Perform a Rest call and retrieve a token.
        $script:session = New-rVisession -headers $script:headers -vCenter $vCenter
        $User = $Credential.UserName
        $vCenterReturn = New-Object -TypeName PSObject
        $vCenterReturn | Add-Member -MemberType NoteProperty -Name Name -Value $vCenter
        $vCenterReturn | Add-Member -MemberType NoteProperty -Name Port -Value "443"
        $vCenterReturn | Add-Member -MemberType NoteProperty -Name User -Value $User
        # Return vCenter connection information.
        $script:vCenter = $vCenter
        $vCenterReturn
    }
    Catch
    {
        $ErrorMessage = $_.Exception.Message
        $FailedItem = $_.Exception.ItemName
        Throw "Connect-rVIServer: $ErrorMessage $FailedItem"
    }
}