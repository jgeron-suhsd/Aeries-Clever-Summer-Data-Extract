# Aeries-Clever Summer School Data Extract

This PowerShell script is intended to supplement regular school year data synced from the Aeries Student Information System with summer school data for Clever, a rostering and Single Sign-On (SSO) solution for schools. The problem being solved is the decision of whether to pause your Clever sync and have your spring students and teachers lose access to Clever over the summer, or to let the Clever sync run through the summer which means that data from the spring term will be lost. This script let's you have the best of both worlds by supplementing your paused spring data so it can persist throughout the summer alongside your summer school data from Aeries.

The script exports the data into CSV files, which can be used to be manually uploaded into Clever as an interim solution while the regular school year data is paused for summer. Clever currently requires manual uploads for custom data, but has said an automated process may be introduced in the future.

## Prerequisites

- PowerShell 5.1 or later
- AeriesApi PowerShell module
- PowerShell SecretManagement module

## Setup

1. Clone or download this repository.
2. Install the required modules, if not already installed:
   `Install-Module -Name AeriesApi`
   `Install-Module -Name SecretManagement`
3. Update the `config-template.ps1` file with the appropriate values for your environment, and save it as `config.ps1`. You can also set the `$DbYear` variable to `(Get-Date).Year` if you want to use the current year.
4. Store your Aeries API key in the PowerShell SecretManagement vault:
   `$ApiKey = 'APIKeyFromAeriesHere' | ConvertTo-SecureString -AsPlainText -Force`
   `Set-Secret -Vault 'MyVault' -Name 'AeriesCleverSummerExtractApiKey' -Secret $ApiKey`
   Replace `'MyVault'` with the name of your vault, and `'APIKeyFromAeriesHere'` with your Aeries API key.
   This step ensures that your credentials are stored securely in the vault under your users credentials instead of being stored in plain text in the script file.

## Usage

Run the `Invoke-AeriesCleverSummerExtract.ps1` script in PowerShell. This script will call the main script, which will retrieve summer school data from Aeries, format it for Clever, and export it to CSV files.

The exported CSV files will be located in the specified `$ExportPath` directory, in a subfolder named with the current date and time.

## Disclaimer

This script is provided "as is" without any warranties or guarantees. The authors and contributors are not responsible for any errors or issues that may arise from using this script. Always test the script in a non-production environment before using it in a production setting.