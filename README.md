# Introduction

This module contains collection general utility functions for PowerShell, Azure, Azure DevOps and Slack

Start browsing the documentation [here](./docs/index.md)

[![MIT licensed](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/ehagen/TD.Util/master/LICENSE)
![PowerShell Gallery](https://img.shields.io/powershellgallery/v/td.util.svg?label=PSGallery%20Version&logo=PowerShell&style=flat-square)
![PowerShell Gallery](https://img.shields.io/powershellgallery/dt/td.util.svg?label=PSGallery%20Downloads&logo=PowerShell&style=flat-square)
[![Build Status](https://dev.azure.com/tedon/TD.Deploy/_apis/build/status/ehagen.TD.Util?branchName=master)](https://dev.azure.com/tedon/TD.Deploy/_build/latest?definitionId=52&branchName=master)

<p align="center">
  <a href="https://www.powershellgallery.com/packages/TD.Util"><img src="https://img.shields.io/powershellgallery/p/TD.Util.svg"></a>
  <a href="https://github.com/ehagen/TD.Util"><img src="https://img.shields.io/github/languages/top/ehagen/TD.Util.svg"></a>
  <a href="https://github.com/ehagen/TD.Util"><img src="https://img.shields.io/github/languages/code-size/ehagen/TD.Util.svg"></a>
</p>

## Dependencies

- Scriptbook Module
- PowerShellBuild Module

## Requirements

- PowerShell 6.* or higher
- Windows PowerShell 5.1

## Build and Test

- run the build.ps1 file from ps console

## Structure TD.Util module

Each module contains private functions, public functions and PSake tasks. The folder layout used within git repo is:

    - module
        - Private
        - Public
          - Ado (Azure DevOps)
          - Azure
          - Config 
          - Git
          - Json
          - Slack
          - Utilities
        psd file
        psm file
        psakefile (optional)
