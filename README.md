# TD.Util

This module contains collection general utility functions for PowerShell

- Azure DevOps Utilities

This script uses the default PowershellBuild commands to build and publish the Module

- Imports PowerShell Build module
- Builds the psm module in the output folder
- Builds need to occur on a Windows machine (Linux not supported by PowershellBuild module)
- Generates help file from comments in source
- Publish the module on the PSGallery