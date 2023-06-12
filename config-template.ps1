# Update these values for your environment and save as config.ps1
$SummerSchoolName = 'Aeries Summer School Name'
$ExportPath = 'C:\temp\AeriesExtracts\SummerSchool\'
$AeriesUrl = 'https://aeries.school.com/'
$DbYear = '2021' # To always get current year, use $DbYear = (Get-Date).Year.ToString()
                 # In testing before you have data ready, you may want to try pulling last year's data

# Download all student and teacher records from the Clever data browser
# CSV of existing teachers in Clever to exclude from export
$CleverTeachers = Get-Content -Path "$ExportPath\teachers.csv" | ConvertFrom-Csv
# CSV of existing students in Clever to exclude from export
$CleverStudents = Get-Content -Path "$ExportPath\students.csv" | ConvertFrom-Csv


# Retrieve Aeries API Key from key vault
$ AeriesApiKey = get-secret -Name 'AeriesCleverSummerExtractApiKey'
# To store the cert string in your vault using PowerShell SecretManagement, use the following command:
# $ApiKey = 'APIKeyFromAeriesHere' | ConvertTo-SecureString -AsPlainText -Force
# Set-Secret -Vault 'MyVault' -Name 'AeriesCleverSummerExtract' -Secret $ApiKey

# TERM DATA
# Hardcoding this into the config, as this is needed and need a last minute fix.
# Our district only has 1 term for summer school, so should be straight forward.
# If a district has multiple terms, would need to associate the correct term with each section in the main script.
$TermName = 'Summer' # Run Get-AeriesSchoolTerms -SchoolCode $SummerSchool.SchoolCode to get the correct term name
$TermStart = '06-13-2023' # Should be in MM-DD-YYYY format.
$TermEnd = '07-13-2023' # Should be in MM-DD-YYYY format.