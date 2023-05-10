#Requires -Modules AeriesApi, SecretManagement

# Import Config
. .\config.ps1

# Create Export Directory
$Timestamp = Get-Date -Format 'yyyy-MM-dd_HH-mm-ss'
$ExportDirectory = Join-Path -Path $ExportPath -ChildPath $Timestamp
if (-not (Test-Path -Path $ExportDirectory)) {
    New-Item -ItemType Directory -Path $ExportDirectory
}

# Initialize Aeries API
Initialize-AeriesApi -URL $AeriesUrl -Certificate ($AeriesApiKey | ConvertFrom-SecureString -AsPlainText) -DatabaseYear $DbYear

# Get Summer School Data from Aeries
$SummerSchool = Get-AeriesSchool | Where-Object {$_.Name -like $SummerSchoolName}
$SummerStudents = Get-AeriesStudent -SchoolCode $SummerSchool.SchoolCode
$SummerTeachers = Get-AeriesTeacher -SchoolCode $SummerSchool.SchoolCode
$SummerSections = Get-AeriesSection -SchoolCode $SummerSchool.SchoolCode
$SummerRosters = $SummerSections | ForEach-Object {Get-AeriesSectionRoster -SchoolCode $SummerSchool.SchoolCode -SectionNumber $_.SectionNumber}

# Create HT for Courses by course ID
$Courses = Get-AeriesCourseInformation
$CourseHT = @{}
$Courses | ForEach-Object {$CourseHT.Add($_.ID, $_)}

# Format school data for Clever
$Schools = $SummerSchool | ForEach-Object {
    [pscustomobject]@{
        # REQUIRED PROPERTIES
        School_id = $_.SchoolCode
        School_name = $_.Name
        School_number = $_.SchoolCode
        # OPTIONAL PROPERTIES
        State_id = $_.StateSchoolID
        Low_grade = $_.LowGradeLevel
        High_grade = $_.HighGradeLevel
        Principal = $_.PrincipalName
        Principal_email = $_.PrincipalEmailAddress
        School_address = $_.Address
        School_city = $_.AddressCity
        School_state = $_.AddressState
        School_zip = $_.AddressZipCode
        School_phone = $_.PhoneNumber
        #ext.* Additional data sent over in extension field.
    }
}
# Export School Data to CSV
$schools | export-csv -path $ExportDirectory\Schools.csv -NoTypeInformation

# Format student data for Clever
$students = $SummerStudents | ForEach-Object {
    [pscustomobject]@{
        School_id = $_.SchoolCode #Required
        Student_id = $_.StudentID #Required
        Student_number = $_.StudentID # There is also a StudentNumber property, but this is the default Aeries/Clever mapping
        State_id = $_.StateStudentID
        Last_name = $_.LastName #Required
        Middle_name = $_.MiddleName
        First_name = $_.FirstName #Required
        Grade = $_.Grade
        Gender = $_.Gender
        #Graduation_year = $_.
        DOB = $_.BirthDate
        #Race = $_
        #Hispanic_Latino = $_
        Home_language = $_.HomeLanguageCode
        #Ell_status = $_
        #Frl_status = $_
        #IEP_status = $_
        Student_Street = $_.MailingAddress
        Student_City = $_.MailingAddressCity
        Student_State = $_.MailingAddressState
        Student_zip = $_.MailingAddressZipCode
        Student_email = $_.StudentEmailAddress
        #Contact_relationship = $_
        #Contact_type = $_
        #Contact_name = $_
        #Contact_phone = $_
        #Contact_phone_type = $_
        #Contact_email = $_
        #Contact_sis_id = $_
        Username = $_.StudentEmailAddress
        Password = $_.NetworkLoginID
        #Unweighted_gpa = $_
        #Weighted_gpa = $_
        #ext.* Additional data sent over in extension field.
    }
}
# Export Student Data to CSV
$Students | export-csv -path $ExportDirectory\Students.csv -NoTypeInformation

# Format teacher data for Clever
$teachers = $SummerTeachers | ForEach-Object {
    [pscustomobject]@{
        School_id = $_.SchoolCode #Required
        Teacher_id = $_.StaffID1 #Required
        Teacher_number = $_.StaffID1
        #State_teacher_id = $_.
        Teacher_email = $_.EmailAddress
        First_name = $_.FirstName #Required
        Last_name = $_.LastName #Required
        #Title = $_
        #Username = $_
        #Password = $_
        #ext.* Additional data sent over in extension field.
    }
}
# Export Teacher Data to CSV
$Teachers | export-csv -path $ExportDirectory\Teachers.csv -NoTypeInformation

# Format section data for Clever
$Sections = $SummerSections | ForEach-Object {
    [pscustomobject]@{
        School_id = $_.SchoolCode #Required
        Section_id = $_.SectionNumber #Required
        Teacher_id = $_.SectionStaffMembers[0] #Required
        Teacher_2_id = $_.SectionStaffMembers[1]
        Teacher_3_id = $_.SectionStaffMembers[2]
        Teacher_4_id = $_.SectionStaffMembers[3]
        Teacher_5_id = $_.SectionStaffMembers[4]
        Teacher_6_id = $_.SectionStaffMembers[5]
        Teacher_7_id = $_.SectionStaffMembers[6]
        Teacher_8_id = $_.SectionStaffMembers[7]
        Teacher_9_id = $_.SectionStaffMembers[8]
        Teacher_10_id = $_.SectionStaffMembers[9]
        Name = $CourseHT[$_.CourseID].Title
        Section_number = $_.SectionNumber
        Grade = $_.HighGrade
        Course_name = $CourseHT[$_.CourseID].Title
        Course_number = $_.CourseID
        Course_description = $CourseHT[$_.CourseID].ContentDescription
        Period = $_.Period
        #Subject = $_ #May need to cross reference elsewhere
        #Term_name = $_.Semester # ??? Maybe? Maybe we pull it from the school?
        #Term_start = $_.Same as above?
        #Term_end = $_.Same as above?
        #ext.* Additional data sent over in extension field.
    }
}
# Export Section Data to CSV
$Sections | export-csv -path "$ExportDirectory\Sections.csv" -NoTypeInformation -Force

# Format enrollment data for Clever
$enrollments = $SummerRosters | ForEach-Object {
    [pscustomobject]@{
        School_id = $_.SchoolCode #Required
        Section_id = $_.SectionNumber #Required
        Student_id = $_.StudentID #Required
    }
}
# Export Enrollment Data to CSV
$Enrollments | export-csv -path $ExportDirectory\Enrollments.csv -NoTypeInformation