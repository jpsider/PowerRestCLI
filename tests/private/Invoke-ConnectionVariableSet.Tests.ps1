$script:ModuleName = 'PowerRestCLI'

$here = (Split-Path -Parent $MyInvocation.MyCommand.Path) -replace 'tests', "$script:ModuleName"
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "Connection Variable function for $moduleName" -Tags Build {
    It "Should Return true." {
        Invoke-ConnectionVariableSet | Should be $true
    }
    It "Should Return true, If the headers are empty." {
        Invoke-ConnectionVariableSet 
        $script:headers | Should BeNullOrEmpty
    }
    It "Should Return true, if the session is empty." {
        Invoke-ConnectionVariableSet 
        $script:session | Should BeNullOrEmpty
    }
    It "Should Return true, if vCenter is not empty." {
        Invoke-ConnectionVariableSet 
        $script:vCenter | Should Not BeNullOrEmpty
    }
}