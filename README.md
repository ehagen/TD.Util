# Introduction

This module contains collection general utility functions for PowerShell, Azure, Azure DevOps and Slack

Start browsing the documentation [here](./docs/index.md)

## Dependencies

- PSake Module
- PowerShellBuild Module

## Requirements

- PowerShell Core 6.* or higher
- Windows version PowerShell Core

## Build and Test

- run the build.ps1 file from ps console

## Structure module

Each module contains private functions, public functions and PSake tasks. The folder layout used within git repo is:

    - module
        - Private
        - Public
          - Ado (Azure DevOps)
          - Azure
          - Config 
          - Slack
        psd file
        psm file
        psakefile (optional)

For examples look at the documentation of PowerShellBuild at https://github.com/psake/PowerShellBuild. You can also use this repo as a reference.
