# Storyline: View the event logs, check for valid logs, and print the results


function select_log() {

    cls

    #List all event logs
    $theLogs = Get-EventLog -list | select Log
    $theLogs | Out-Host

    # Initialize the array to store the logs
    $arrLog = @()

    foreach ($tempLog in $theLogs) {

        # Add each log to the array
        # NOTE: These are stored in the array as a hashtable in the format:
        # @{Log=LOGNAME}
        $arrLog += $tempLog

    }

    # Test to be sure our array is being populated.
    #$arrLog

    # Prompt the user for the log to view or quit.
    $readLog = read-host -Prompt "Please enter a log from the list above or 'q' to quit the program"

    # Check if the user wants to quit
    if ($readLog -match "^[qQ]$") {

        # Stop executing the program and close the script
        break

    }

    log_check -logToSearch $readLog


} # ends the select_log()



function log_check() {

    # String the user types in within the select_log function
    Param([string]$logToSearch)

    # Format the user input.
    # Example: @{Log=Security}
    $theLog = "^@{Log=" + $logToSearch + "}$"

    # Search the array for the exact hashtable string
    if ($arrLog -match $theLog){

        write-host -BackgroundColor Green -ForegroundColor white "Please wait, it may take a few moments to retrieve the log entries."
        sleep 2

        # Call the function to view the log.
        view_log -logToSearch $logToSearch


    } else {

        write-host -BackgroundColor red -ForegroundColor white "the log specified doesn't exist."

        sleep 2

        select_log

    }

} # ends the log_check()



function view_log() {

    cls
    
    # Get the logs
    Get-EventLog -Log $logToSearch -Newest 10 -after "1/18/2020"

    #Pause the screen and wait until the user is ready to proceed.
    read-host -Prompt "Press enter when you are done"

    # Go back to the select log
    select_log

} # ends the view_log()

# Run the select_log as the first function
select_log