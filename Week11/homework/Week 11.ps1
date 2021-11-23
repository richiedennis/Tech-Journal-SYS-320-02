# Storyline: Set of tasks for week 11 assignment

# Prompt for user to choose save location
$output = read-host 'Enter full path where CSV should be saved (C:\Users\champuser\Desktop\Info.csv)'

# List of running process and the path for each process
Get-Process | Format-Table ProcessName, Path | Export-Csv -Path $output -NoTypeInformation

# List all registered services and the path to the executable controlling the service
Get-WmiObject -Class Win32_service | select Name, PathName | Export-Csv -Path $output -NoTypeInformation

# List all tcp network sockets
Get-NetTCPConnection -State Established | Export-Csv -Path $output -NoTypeInformation

# List all user account information
Get-WmiObject -Class Win32_UserAccount | Export-Csv -Path $output -NoTypeInformation

# List all network adapter configuration information
Get-WmiObject -Class Win32_NetworkAdapterConfiguration | Export-Csv -Path $output -NoTypeInformation

# 4 other Powershell Cmdlets
#1. Is useful for listing registery entries and can be beneficial for seeing persisting entries from malware
Get-ItemProperty C:\Windows | Export-Csv -Path $output -NoTypeInformation

#2. Useful for checking for GUID created by malware 
Get-ChildItem -Path $Env:APPDATA -Force -Recurse -Filter run.dat | Export-Csv -Path $output -NoTypeInformation

#3. Beneficial for getting the hashes of files created by malware
Get-FileHash -Path $Env:APPDATA | Export-Csv -Path $output -NoTypeInformation

#4. Needed in order to see logs of information to see what the malware got up to
Get-EventLog -LogName Application | Export-Csv -Path $output -NoTypeInformation

$output2 = read-host 'Enter the name of the zipped file (info2.zip)'

$compress = @{
    Path = $output
    CompressionLevel = "Fastest"
    DestinationPath = "C:\Users\champuser\Desktop\$output2"
}

Compress-Archive @compress