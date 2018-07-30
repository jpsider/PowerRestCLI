$script:ModuleName = 'PowerRestCLI'

$here = (Split-Path -Parent $MyInvocation.MyCommand.Path) -replace 'tests', "$script:ModuleName"
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

$script:ModuleName = 'PowerRestCLI'

function Disable-SSLValidation {}
function Write-Error {}
function Get-Credential {}
function New-rViHeader {}
function New-rVisession {}

Describe "Connect-rVIServer function for $moduleName" -Tags Build {
    $script:headers = @{
        'Authorization' = "Basic Auth"
    }
    $secpasswd = ConvertTo-SecureString "PlainTextPassword" -AsPlainText -Force
    $fakeCreds = New-Object System.Management.Automation.PSCredential ("FakeUser", $secpasswd)    
    It "Should Return false, if Disable-SSLValidation fails." {
        Mock -CommandName 'Disable-SSLValidation' -MockWith {
            return $false
        }
        Mock -CommandName 'Write-Error' -MockWith {}
        Connect-rVIServer -vCenter "FakevCenter" | Should be $false
        Assert-MockCalled -CommandName 'Disable-SSLValidation' -Times 1 -Exactly
        Assert-MockCalled -CommandName 'Write-Error' -Times 1 -Exactly
    }
    It "Should Return false, if New-rVIheader fails." {
        Mock -CommandName 'Disable-SSLValidation' -MockWith {
            return $true
        }
        Mock -CommandName 'New-rViHeader' -MockWith {
            return $false
        }
        Mock -CommandName 'Write-Error' -MockWith {}
        Connect-rVIServer -vCenter "FakevCenter" -Credential $fakeCreds | Should be $false
        Assert-MockCalled -CommandName 'Disable-SSLValidation' -Times 2 -Exactly
        Assert-MockCalled -CommandName 'New-rViHeader' -Times 1 -Exactly        
        Assert-MockCalled -CommandName 'Write-Error' -Times 2 -Exactly
    }
    It "Should Return false, if New-rVIsession fails." {
        Mock -CommandName 'Disable-SSLValidation' -MockWith {
            return $true
        }
        Mock -CommandName 'New-rVIHeader' -MockWith {
            return $true
        }
        Mock -CommandName 'New-rVIsession' -MockWith {
            return $false
        }
        Connect-rVIServer -vCenter "FakevCenter" -Credential $fakeCreds | Should be $false
        Assert-MockCalled -CommandName 'Disable-SSLValidation' -Times 3 -Exactly
        Assert-MockCalled -CommandName 'New-rViHeader' -Times 2 -Exactly        
        Assert-MockCalled -CommandName 'New-rVIsession' -Times 1 -Exactly
        Assert-MockCalled -CommandName 'Write-Error' -Times 3 -Exactly      
    }
    It "Should Return vCenter Object." {
        Mock -CommandName 'Disable-SSLValidation' -MockWith {
            return $true
        }
        Mock -CommandName 'New-rVIHeader' -MockWith {
            return $true
        }
        Mock -CommandName 'New-rVIsession' -MockWith {
            return $true
        }
        Connect-rVIServer -vCenter "FakevCenter" -Credential $fakeCreds | Should be '@{Name=FakevCenter; Port=443; User=FakeUser}'
        Assert-MockCalled -CommandName 'Disable-SSLValidation' -Times 4 -Exactly
        Assert-MockCalled -CommandName 'New-rViHeader' -Times 3 -Exactly        
        Assert-MockCalled -CommandName 'New-rVIsession' -Times 2 -Exactly    
    }    
    It "Should Return vCenter Object." {
        Mock -CommandName 'Disable-SSLValidation' -MockWith {
            return $true
        }
        Mock -CommandName 'New-rVIHeader' -MockWith {
            return $true
        }
        Mock -CommandName 'New-rVIsession' -MockWith {
            return $true
        }
        Connect-rVIServer -vCenter "FakevCenter" -User "FakeUSer" -Password $secpasswd | Should be '@{Name=FakevCenter; Port=443; User=FakeUser}'
        Assert-MockCalled -CommandName 'Disable-SSLValidation' -Times 5 -Exactly
        Assert-MockCalled -CommandName 'New-rViHeader' -Times 4 -Exactly        
        Assert-MockCalled -CommandName 'New-rVIsession' -Times 3 -Exactly    
    }
    It "Should Return vCenter Object." {
        Mock -CommandName 'Disable-SSLValidation' -MockWith {
            return $true
        }
        function Get-Credential
        { 
            return @{UserName = 'FakeUser'}
        }       
        Mock -CommandName 'New-rVIHeader' -MockWith {
            return $true
        }
        Mock -CommandName 'New-rVIsession' -MockWith {
            return $true
        }
        Connect-rVIServer -vCenter "FakevCenter" | Should be '@{Name=FakevCenter; Port=443; User=FakeUser}'
        Assert-MockCalled -CommandName 'Disable-SSLValidation' -Times 6 -Exactly
        Assert-MockCalled -CommandName 'New-rViHeader' -Times 5 -Exactly        
        Assert-MockCalled -CommandName 'New-rVIsession' -Times 4 -Exactly    
    }    
}