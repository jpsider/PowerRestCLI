$script:ModuleName = 'PowerRestCLI'

$here = (Split-Path -Parent $MyInvocation.MyCommand.Path) -replace 'tests', "$script:ModuleName"
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "New-rVIheader function for $moduleName" {
    $secpasswd = ConvertTo-SecureString "PlainTextPassword" -AsPlainText -Force
    $fakeCreds = New-Object System.Management.Automation.PSCredential ("FakeUser", $secpasswd) 
    It "Should Return true." {
        New-rVIheader -Credential $fakeCreds | Should be $true
    }
    It "Should Return false if -whatif is used." {
        New-rVIheader -Credential $fakeCreds -whatif| Should be $false
    }
}