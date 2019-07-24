$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$root = $here -replace "\\public|\\private|\\tests", ""
$ModuleName = 'PS1EAE'

# Import our module to use InModuleScope
#if (-Not(Get-Module -Name "$ModuleName")) {
    Import-Module (Resolve-Path "$root\$ModuleName\$ModuleName.psd1") -Force
#}

InModuleScope "$ModuleName" {
    Describe 'Join-Parts' {
        It "Join url" {
            Join-Parts -Separator '/' -Parts 'http://mysite',"sub/subsub",'/one/two/three' | Should Be 'http://mysite/sub/subsub/one/two/three'
            Join-Parts -Separator '/' -Parts 'http://mysite',$null,'one/two/three' | Should Be 'http://mysite/one/two/three'
            Join-Parts -Separator '/' -Parts 'http://mysite','','/one/two/three' | Should Be 'http://mysite/one/two/three'
            Join-Parts -Separator '/' -Parts 'http://mysite/','',$null,'/one/two/three' | Should Be 'http://mysite/one/two/three'
        }

        It "Harmonize separators" {
            Join-Parts -Separator '/' -ReplaceSeparator '\' -Parts 'http://mysite','sub\subsub','/one\two/three' | Should Be 'http://mysite/sub/subsub/one/two/three'

            Join-Parts -Separator '\' -ReplaceSeparator '/' -Parts 'http://mysite','sub/subsub','/one/two/three' | Should Be 'http:\\mysite\sub\subsub\one\two\three'
        }
    }
}