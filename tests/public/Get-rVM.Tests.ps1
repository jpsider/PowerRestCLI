$script:ModuleName = 'PowerRestCLI'

$here = (Split-Path -Parent $MyInvocation.MyCommand.Path) -replace 'tests', "$script:ModuleName"
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "Get-rVM function for $moduleName" -Tags Build {
    $script:vCenter = "fakevCenter"
    $script:session = @{'vmware-api-session-id' = 'FakeToken'}
    It "Should Return false if no data was returned." {
        Mock -CommandName 'Invoke-RestMethod' -MockWith {
            return $null
        }
        {Get-rVM} | Should Throw
        Assert-MockCalled -CommandName 'Invoke-RestMethod' -Times 1 -Exactly
    }
    It "Should Return the VM objects." {
        Mock -CommandName 'Invoke-RestMethod' -MockWith {
            $RawReturn = @{
                value = @{
                    name            = 'testvm'
                    Power_State     = 'POWERED_ON'
                    cpu_count       = '2'
                    memory_size_MiB = '10240'
                }               
            }
            $ReturnJson = $RawReturn | ConvertTo-Json
            $ReturnData = $ReturnJson | convertfrom-json
            return $ReturnData
        }
        Mock -CommandName 'Format-Table' -MockWith {
            return '@{memory_size_MiB=10240; cpu_count=2; name=testvm; Power_State=POWERED_ON}'
        }        
        Get-rVM | Should be '@{memory_size_MiB=10240; cpu_count=2; name=testvm; Power_State=POWERED_ON}'
        Assert-MockCalled -CommandName 'Invoke-RestMethod' -Times 2 -Exactly
    }
    It "Should Return false if no data was returned." {
        Mock -CommandName 'Invoke-RestMethod' -MockWith {
            $CrapData = "hodgepodge"
            return $CrapData
        }
        {Get-rVM} | Should Throw
        Assert-MockCalled -CommandName 'Invoke-RestMethod' -Times 3 -Exactly        
    }
    It "Should Return the VM objects. (Not Throw)" {
        Mock -CommandName 'Invoke-RestMethod' -MockWith {
            $RawReturn = @{
                value = @{
                    name            = 'testvm'
                    Power_State     = 'POWERED_ON'
                    cpu_count       = '2'
                    memory_size_MiB = '10240'
                }               
            }
            $ReturnJson = $RawReturn | ConvertTo-Json
            $ReturnData = $ReturnJson | convertfrom-json
            return $ReturnData
        }
        Mock -CommandName 'Format-Table' -MockWith {
            return '@{memory_size_MiB=10240; cpu_count=2; name=testvm; Power_State=POWERED_ON}'
        }        
        {Get-rVM} | Should not Throw
        Assert-MockCalled -CommandName 'Invoke-RestMethod' -Times 4 -Exactly
    }
}