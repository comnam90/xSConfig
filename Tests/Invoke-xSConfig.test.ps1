InModuleScope xSConfig {
    Describe "Invoke-xSConfig" {
        Context 'Desktop Experience Node' {
            It "Should error when SConfig isn't present"{
                Invoke-xSConfig | Should -throw
            }
        }
        Context 'Server Core Node' -skip {
        }
    }
}
