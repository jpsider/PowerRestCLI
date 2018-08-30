function Get-rVM
{
    <#
	.SYNOPSIS
		Perform Rest API call to retrieve VM information from vCenter.
	.DESCRIPTION
        Perform Rest API call to retrieve VM information from vCenter.
    .EXAMPLE
        $vms = Get-rVM
	.NOTES
		No notes.
    #>
    begin
    {
        # Perform RestAPI call to vCenter to retrieve VM data.
        $ReturnData = Invoke-RestMethod -Uri https://$script:vCenter/rest/vcenter/vm -Method Get -Headers $script:session -UseBasicParsing
    }
    Process
    {
        # Validate there was information Returned.
        if ($null -ne $ReturnData.value)
        {
            # Grab the data, and Format it in a table.
            $vms = ($ReturnData).value
            $mydata = $vms | Format-Table name, Power_State, cpu_count, memory_size_MiB -AutoSize
            return $mydata
        }
        else
        {
            # Return an error if no data was returned from REST.
            Throw "Get-rVM: Did not recieve a valid response."
        }
    }
}