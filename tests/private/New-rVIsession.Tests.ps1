$script:ModuleName = 'PowerRestCLI'

Describe "New-rVIsession function for $moduleName"  {
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
        New-rVIsession -headers $script:headers -vCenter $script:vCenter | Should be $false
        Assert-MockCalled -CommandName 'Invoke-RestMethod' -Times 2 -Exactly
        Assert-MockCalled -CommandName 'Write-Error' -Times 1 -Exactly
    }    
    It "Should Return false if -whatif is used." {
        New-rVIsession -headers $script:headers -vCenter $script:vCenter -whatif| Should be $false
    }
}