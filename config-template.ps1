# Update these values for your environment and save as config.ps1
$SummerSchoolName = 'Aeries Summer School Name'
$ExportPath = 'C:\temp\AeriesExtracts\SummerSchool\'
$AeriesUrl = 'https://aeries.school.com/'
$DbYear = '2021' # To always get current year, use $DbYear = (Get-Date).Year.ToString()
                 # In testing before you have data ready, you may want to try pulling last year's data

#retrieve Aeries API Key from key vault
$AeriesApiKey = get-secret -Name 'AeriesCleverSummerExtractApiKey'


# To store the cert string in your vault using PowerShell SecretManagement, use the following command:
# $ApiKey = 'APIKeyFromAeriesHere' | ConvertTo-SecureString -AsPlainText -Force
# Set-Secret -Vault 'MyVault' -Name 'AeriesCleverSummerExtract' -Secret $ApiKey