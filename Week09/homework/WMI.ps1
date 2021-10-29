# Storyline: Using the Get-process and Get-service
# Get-Process | Select-Object ProcessName, Path, ID | Export-Csv -Path "C:\Users\champuser\Desktop\myProcesses.csv" -NoTypeInformation
# Get-Process | Get-Member
# Get-Service | where { $_.Status -eq "Running" }

# Use the Get-WMI cmdlet
# Get-WmiObject -Class Win32_process | select Name, PathName, ProcessId
# Get-WmiObject -list | where { $_.Name -ilike "Win32_[p-s]*" } | Sort-Object
# Get-WmiObject -Class win32_Account | Get-Member

# Task: Grab the network adapter information using the WMI class
# Get the IP address, default gateway, DHCP server, and the DNS servers.
Get-WmiObject -Class Win32_NetworkAdapterConfiguration | select IPAddress, DefaultIPGateway, DHCPServer, DNSDomain
# Export list of running process and running services into separate files
Get-WmiObject -Class Win32_service | select Name, PathName, ProcessID | Export-Csv -Path "C:\Users\champuser\Desktop\myServices.csv" -NoTypeInformation
Get-WmiObject -Class Win32_process | select Name, PathName, ProcessID | Export-Csv -Path "C:\Users\champuser\Desktop\myProcesses.csv" -NoTypeInformation
# Start and Stop Windows Calculator (calc.exe)
Start-Process calc
Sleep 2
Stop-Process -Name "win32calc"
# Running your code using a screen recorder.
