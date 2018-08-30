$script:ModuleName = 'PowerRestCLI'

$here = (Split-Path -Parent $MyInvocation.MyCommand.Path) -replace 'tests', "$script:ModuleName"
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "New-rVIsession function for $moduleName" -Tags Build {
    $script:vCenter = "fakevCenter"
    $script:headers = @{
        'Authorization' = "Basic $auth"
    }
    It "Should Return true." {
        Mock -CommandName 'Invoke-RestMethod' -MockWith {
            $RestReturn = @{
                value = 'FakeToken'
            }
            return $RestReturn
        }
        New-rVIsession -headers $script:headers -vCenter $script:vCenter | Should be $true
        Assert-MockCalled -CommandName 'Invoke-RestMethod' -Times 1 -Exactly
    }
    It "Should Return true." {
        Mock -CommandName 'Invoke-RestMethod' -MockWith {
            return $null
        }
        Mock -CommandName 'Write-Error' -MockWith {}
        {New-rVIsession -headers $script:headers -vCenter $script:vCenter} | Should Throw
        Assert-MockCalled -CommandName 'Invoke-RestMethod' -Times 2 -Exactly
    }    
    It "Should Return false if -whatif is used." {
        New-rVIsession -headers $script:headers -vCenter $script:vCenter -whatif| Should be $false
    }
}