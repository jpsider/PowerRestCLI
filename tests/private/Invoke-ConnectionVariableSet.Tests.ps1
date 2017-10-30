$script:ModuleName = 'PowerRestCLI'

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