function Invoke-ConnectionVariableSet
{
    <#
	.DESCRIPTION
		Simple function to store variables..
	.EXAMPLE
		Invoke-ConnectionVariables
	.NOTES
		No notes.
    #>
    # Edit the vCenter IP to your server's IP or DNS name.
    [string]$script:vCenter = "192.168.2.220"
    [object]$script:headers = @()
    [object]$script:session = @()
    return $true

}