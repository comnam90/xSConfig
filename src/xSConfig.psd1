#
# Module manifest for module 'xSConfig'
#
# Generated by: Ben Thomas
#
# Generated on: 15/09/2020
#

@{

# Script module or binary module file associated with this manifest.
RootModule = 'xSConfig'

# Version number of this module.
ModuleVersion = '0.1.2'

# Supported PSEditions
# CompatiblePSEditions = @()

# ID used to uniquely identify this module
GUID = '658775dc-bc40-4efe-8ff8-db940e7ab550'

# Author of this module
Author = 'Ben C Thomas'

# Company or vendor of this module
CompanyName = 'Ben C Thomas'

# Copyright statement for this module
Copyright = 'Copyright (c) Ben C Thomas. All rights reserved.'

# Description of the functionality provided by this module
Description = 'A module that customises SConfig for HCI'

# Minimum version of the Windows PowerShell engine required by this module
PowerShellVersion = '5.1'

# Name of the Windows PowerShell host required by this module
# PowerShellHostName = ''

# Minimum version of the Windows PowerShell host required by this module
# PowerShellHostVersion = ''

# Minimum version of Microsoft .NET Framework required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
# DotNetFrameworkVersion = ''

# Minimum version of the common language runtime (CLR) required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
# CLRVersion = ''

# Processor architecture (None, X86, Amd64) required by this module
# ProcessorArchitecture = ''

# Modules that must be imported into the global environment prior to importing this module
# RequiredModules = @()

# Assemblies that must be loaded prior to importing this module
# RequiredAssemblies = @()

# Script files (.ps1) that are run in the caller's environment prior to importing this module.
# ScriptsToProcess = @()

# Type files (.ps1xml) to be loaded when importing this module
# TypesToProcess = @()

# Format files (.ps1xml) to be loaded when importing this module
# FormatsToProcess = @()

# Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
# NestedModules = @()

# Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
FunctionsToExport = 'Invoke-xSConfig'

# Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
CmdletsToExport = @()

# Variables to export from this module
VariablesToExport = @()

# Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
AliasesToExport = @()

# DSC resources to export from this module
# DscResourcesToExport = @()

# List of all modules packaged with this module
# ModuleList = @()

# List of all files packaged with this module
# FileList = @()

# Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
PrivateData = @{

    PSData = @{

        # Tags applied to this module. These help with module discovery in online galleries.
        Tags = @('PSEdition_Desktop','Windows','AzureStackHCI','SConfig')

        # A URL to the license for this module.
        LicenseUri = 'https://github.com/comnam90/xSConfig/blob/main/LICENSE'

        # A URL to the main website for this project.
        ProjectUri = 'https://github.com/comnam90/xSConfig'

        # A URL to an icon representing this module.
        # IconUri = ''

        # ReleaseNotes of this module
        ReleaseNotes = '# 0.1.2

- Fixed display of storage pool count in extras menu.

# 0.1.1

- Fixed SConfig module import

# 0.1.0

Initial Release'

    } # End of PSData hashtable

} # End of PrivateData hashtable

# HelpInfo URI of this module
# HelpInfoURI = ''

# Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
# DefaultCommandPrefix = ''

}

