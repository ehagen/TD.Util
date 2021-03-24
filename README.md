# Introduction

This module contains collection general utility functions for PowerShell, Azure, Azure DevOps and Slack

Start browsing the documentation [here](./docs/index.md)

![PowerShell Gallery](https://img.shields.io/powershellgallery/v/td.util.svg?label=PSGallery%20Version&logo=PowerShell&style=flat-square)
![PowerShell Gallery](https://img.shields.io/powershellgallery/dt/td.util.svg?label=PSGallery%20Downloads&logo=PowerShell&style=flat-square)
[![Build Status](https://dev.azure.com/tedon/TD.Deploy/_apis/build/status/ehagen.TD.Util?branchName=master)](https://dev.azure.com/tedon/TD.Deploy/_build/latest?definitionId=52&branchName=master)

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