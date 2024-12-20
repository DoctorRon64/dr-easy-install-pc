# Define the GitHub URL for the PowerShell script
$githubUrl = "https://raw.githubusercontent.com/yourusername/yourrepo/main/install.ps1"

# Download the script
Invoke-WebRequest -Uri $githubUrl -OutFile "C:\Temp\install.ps1"

# Run the script
PowerShell -ExecutionPolicy Bypass -File "C:\Temp\install.ps1"
