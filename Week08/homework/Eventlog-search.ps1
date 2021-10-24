# Storyline: Review the Security Event Log

#Directory to save files:

$myDir = "C:\Users\champuser\Desktop\"

# List all the available Windows Event Logs
Get-EventLog -list

# Create a prompt to allow user to select the Log to view
$readLog = Read-host -Prompt "Please select a log to review from the list above."

# Print the results for the log

# Task: Create a prompt that allows the user to specify a keyword or phrase to search on
# Find a string from your event logs to search on
$searchMessage = Read-host -Prompt "What message would you like to search the logs for?"

Get-EventLog -LogName $readLog -Newest 40 | where {$_.Message -ilike "*$searchMessage*" } 
#| export-csv -NoTypeInformation -Path "$myDir\securityLogs.csv"