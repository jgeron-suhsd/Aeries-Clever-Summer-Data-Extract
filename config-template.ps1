# Going to create an array of objects for each school in the district using all the variables in the config file.
#

$ExportPath = 'C:\temp\AeriesExtracts\SummerSchool\'
$AeriesUrl = 'https://aeries.school.com/'
$DbYear = '2023'

# Download all student and teacher records from the Clever data browser
# CSV of existing teachers in Clever to exclude from export
$CleverTeachers = Get-Content -Path "$ExportPath\CleverTeachers.csv" | ConvertFrom-Csv
# CSV of existing students in Clever to exclude from export
$CleverStudents = Get-Content -Path "$ExportPath\CleverStudents.csv" | ConvertFrom-Csv

$Configs = @(
    @{
        SummerSchoolName = 'Summer School 1'
        TermName = '1st Quarter'
        TermStart = '06-5-2024'
        TermEnd = '07-22-2024'
        SectionPrefix = '770_S' # Section IDs need to be unique in Clever, prefix should be the school code _ S for summer
                                # Can work this into the core code in the future, but have to do it this way for now.
    }
    # multiple hashtables can be added here for each summer school "school" in Aeries.
    @{
        SummerSchoolName = 'Summer School 2'
        TermName = '1st Quarter'
        TermStart = '06-12-2024'
        TermEnd = '07-10-2024'
        SectionPrefix = ''
    }
)

# Update these values for your environment and save as config.ps1
#$SummerSchoolName = 'Summer School'
#$ExportPath = 'C:\Temp\2024-Clever-Summer-School\'
#$AeriesUrl = 'https://aeries.school.com/'
#$DbYear = '2023' # To always get current year, use $DbYear = (Get-Date).Year.ToString()
                 # In testing before you have data ready, you may want to try pulling last year's data



#retrieve Aeries API Key from key vault
$AeriesApiKey = get-secret -Name 'AeriesCleverSummerExtractApiKey'
# To store the cert string in your vault using PowerShell SecretManagement, use the following command:
# $ApiKey = 'APIKeyFromAeriesHere' | ConvertTo-SecureString -AsPlainText -Force
# Set-Secret -Vault 'MyVault' -Name 'AeriesCleverSummerExtract' -Secret $ApiKey

# TERM DATA
# Hardcoding this into the config, as this is needed and need a last minute fix.
# Our district only has 1 term for summer school, so should be straight forward.
# If a district has multiple terms, would need to associate the correct term with each section in the main script.
#$TermName = '1st Quarter' # Run Get-AeriesSchoolTerms -SchoolCode $SummerSchool.SchoolCode to get the correct term name
#$TermStart = '06-5-2024' # Should be in MM-DD-YYYY format.
#$TermEnd = '07-22-2024' # Should be in MM-DD-YYYY format.
