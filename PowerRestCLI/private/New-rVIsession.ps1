function New-rVIsession
{
    <#
	.DESCRIPTION
        Perform Rest API call to retrieve new Session token.
    .PARAMETER vCenter
        A valid vCenter IP/Name is required
    .PARAMETER Headers
        Valid Headers need to passed in.
    .EXAMPLE
        $script:session = New-rVisession -headers $headers -vCenter $vCenter
	.NOTES
		No Notes.
    #>
    [CmdletBinding(
        SupportsShouldProcess = $true,
        ConfirmImpact = "Low"
    )]
    [OutputType([Hashtable])]
    [OutputType([boolean])]
    param(
        [Parameter(Mandatory = $false)]
        [system.object]$headers,
        [Parameter(Mandatory = $true)]
        [string]$vCenter
    )    
    begin 
    {
        # No Pre-Task.
    }
    process
    {
        if ($pscmdlet.ShouldProcess("Creating Session."))
        { 
            # Perform Rest call to create session.
            $ReturnData = Invoke-RestMethod -Uri https://$vCenter/rest/com/vmware/cis/session -Method Post -Headers $headers -UseBasicParsing
            $token = ($ReturnData).value
            if ($null -ne $token)
            {
                $script:session = @{'vmware-api-session-id' = $token}
                return $script:session
            }
            else
            {
                # No token returned.
                Write-Error "No token returned."
                return $false
            }
        }
        else
        {
            # -WhatIf was used.
            return $false
        }
    }   
}