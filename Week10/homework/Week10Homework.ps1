# Storyline: View the registered services, and print the results


function select_service() {

    cls

    #List all registeredServices
    $theServices = Get-Service | select Name
    $theSerivces | Out-Host

    # Initialize the array to store the services
    $arrService = @()

    foreach ($tempService in $theServices) {

        # Add each service to the array
        # NOTE: These are stored in the array as a hashtable in the format:
        # @{Service=SERVICENAME}
        $arrService += $tempService

    }

    # Test to be sure our array is being populated.
    #$arrSerivce

    # Prompt the user for the service to view or quit.
    $readService = read-host -Prompt "Do you want to view all, stopped, or running services?"

    # Check if the user wants to quit
    if ($readService -match "^[qQ]$") {

        # Stop executing the program and close the script
        break

    }

    service_check -serviceToSearch $readService


} # ends the select_service()



function service_check() {

    # String the user types in within the select_service function
    Param([string]$serviceToSearch)

    # Format the user input.
    # Example: @{Service=Security}
    $theService = "^@{Service=" + $serviceToSearch + "}$"

    # Search the array for the exact hashtable string
    if ($arrService -match $theService){

        write-host -BackgroundColor Green -ForegroundColor white "Please wait, it may take a few moments to retrieve the service entries."
        sleep 2

        # Call the function to view the log.
        view_service -serviceToSearch $serviceToSearch


    } else {

        write-host -BackgroundColor red -ForegroundColor white "the service specified doesn't exist."

        sleep 2

        select_service

    }

} # ends the service_check()



function view_service() {

    cls
    
    # Get the logs
    Get-Service -Service $serviceToSearch

    #Pause the screen and wait until the user is ready to proceed.
    read-host -Prompt "Press enter when you are done"

    # Go back to the select log
    select_service

} # ends the view_log()

# Run the select_log as the first function
select_service