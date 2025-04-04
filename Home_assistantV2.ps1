Clear-Host

# Configuration
# Home Assistant URL and token
$token="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiIxM2VjYTRkNDFiYTA0OGY4OTVkZTZmYWZkMDVkMzk3MyIsImlhdCI6MTczNzQ4Nzc2NywiZXhwIjoyMDUyODQ3NzY3fQ.JhyDpRCqw9U32SpifpdfyAl2WsNLMj1V3oFfYO1LF14"
$homeAssistantUrl = "http://homeassistant.local:8123"
# Configuration
# Configuration

# Set headers for authorization
$headers = @{
    "Authorization" = "Bearer $token"
    "Content-Type"  = "application/json"
}

# Function to list all services
function Get-Services {param(
    [string]$Domain="all"
)
    Write-Host "Fetching services..." -ForegroundColor Green
$servicesEndpoint = "$homeAssistantUrl/api/services"
Write-Host "Fetching from $servicesEndpoint" -ForegroundColor Green
    $servicesResponse = Invoke-RestMethod -Uri $servicesEndpoint -Method GET -Headers $headers
    $ret=$servicesResponse | ForEach-Object {
        $_ | Select-Object domain
    }
 $ret
}

function List-Services {
    Write-Host "Fetching services..." -ForegroundColor Green
    $servicesEndpoint = "$homeAssistantUrl/api/services"
    $servicesResponse = Invoke-RestMethod -Uri $servicesEndpoint -Method GET -Headers $headers
    $servicesResponse | ForEach-Object {
        $_ | Select-Object domain, services | Format-List
    }
}


# Function to list all states
function Get-States {
    param([string]$domain)
    
    #param([string]$domain="light")
    Write-Host "Fetching entity states for $domain" -ForegroundColor Green
    $statesEndpoint = "$homeAssistantUrl/api/states"
    Write-Host "Fetching $statesEndpoint " -ForegroundColor Green
    
    $statesResponse = Invoke-RestMethod -Uri $statesEndpoint -Method GET -Headers $headers
    $statesResponse | ForEach-Object {
        $_ | Select-Object entity_id, state|sort-Object -Property entity_id
    } | Format-Table
    
    "all entities ($statesResponse.count)"
    
    $statesResponsedomain=$statesResponse|Where-Object { $_.entity_id -like $domain+"*" }|select-object -property entity_id
    "Entities by domain $domain  ($statesResponsedomain.count)"
    "Done"
    return $statesResponsedomain
    
}


# Function to list all states
function List-States {
    Write-Host "Fetching entity states..." -ForegroundColor Green
    $statesEndpoint = "$homeAssistantUrl/api/states"
    $statesResponse = Invoke-RestMethod -Uri $statesEndpoint -Method GET -Headers $headers
    $statesResponse | ForEach-Object {
        $_ | Select-Object entity_id, state|sort-Object -Property entity_id
    } | Format-Table
}

# Function to call a service
function Call-Service {
    param(
        [string]$Domain,
        [string]$Service,
        [hashtable]$Data
    )
    Write-Host "Calling service: $Domain.$Service" -ForegroundColor Yellow
    $serviceEndpoint = "$homeAssistantUrl/api/services/$Domain/$Service"
    $response = Invoke-RestMethod -Uri $serviceEndpoint -Method POST -Headers $headers -Body ($Data | ConvertTo-Json -Depth 10)
    Write-Host "Service called successfully!" -ForegroundColor Green
    $response
}

function Select-FromList{
    param([array]$myArray)
    $myArray=$sl
    #$myArray = "Option 1", "Option 2", "Option 3"
    for ($i = 0; $i -lt $myArray.Count; $i++) {
        Write-Host "$($i + 1). $($myArray[$i])"
    }
    $choice = Read-Host "Enter your choice (1-$($myArray.Count))"
    if ($choice -in 1..$myArray.Count) {
    $selectedOption = $myArray[$choice - 1]
    #Write-Host "You selected: $selectedOption"
    } else {
        Write-Host "Invalid choice."
    }
    $selectedOption
}
function Control-Light{
    param([string]$action="toggle",
    [string]$entityid="light.hallway_hall")
  
    # Define the service endpoint and data
$domain = "light"
$serviceon = "turn_on"

$serviceoff = "turn_off"
$servicetoggle = "toggle"


#$entityId = "light.hallway_hall"  # Replace with your light's entity ID
$brightness = 150                # Optional: Set brightness (0-255)
$color = @("255", "200", "100")  # Optional: RGB color (red, green, blue)

#$action="on"
#$action="off"
#$action="toggle"

# Create the service data
$serviceDataon = @{
    "entity_id" = $entityId
    "brightness" = $brightness    
}
$service=$serviceon
$serviceDataoff = @{
    "entity_id" = $entityId
}
$service=$serviceoff
$serviceData=$serviceDataoff

#$service=$servicetoggle
#$service=$serviceon


switch ($action)
{
"on" {$service=$serviceon
      $serviceData=$serviceDataon
    }
"off" {$service=$serviceoff
       $serviceData=$serviceDataoff
    }
"toggle" {$service=$servicetoggle
    $serviceData=$serviceDataoff}
}
# Convert data to JSON
$jsonBody = $serviceData | ConvertTo-Json -Depth 10

# Define the service endpoint
$serviceEndpoint = "$homeAssistantUrl/api/services/$domain/$service"
$serviceEndpoint
# Call the service
$response = Invoke-RestMethod -Uri $serviceEndpoint -Method POST -Headers $headers -Body $jsonBody

# Output the response
Write-Host "Response from Home Assistant:" -ForegroundColor Green
$response | Format-List

}

# Function to explore the API
function Explore-API {
    Write-Host "Choose an option:" -ForegroundColor Cyan
    Write-Host "1. List all services"
    Write-Host "2. List all entity states"
    Write-Host "3. Call a service"
    Write-Host "4. List entity states By Service"
    Write-Host "5. Control Light"
    
    Write-Host "6. Exit"

    $choice = Read-Host "Enter your choice"
    switch ($choice) {
        "1" {
            List-Services
            Explore-API
        }
        "2" {
            List-States
            Explore-API
        }
        "3" {
            $domain = Read-Host "Enter the service domain (e.g., light)"
            $service = Read-Host "Enter the service name (e.g., turn_on)"
            $data = Read-Host "Enter the service data in JSON format (e.g., {\"entity_id\": \"light.living_room\"})"
            $dataHashTable = $data | ConvertFrom-Json
            Call-Service -Domain $domain -Service $service -Data $dataHashTable
            Explore-API
        }
        "4"{
          $sl=Get-Services
          $so=Select-FromList $sl
          #$so    
          write-host "You selected $($so.domain)" -ForegroundColor Green
          $gs=Get-States    $($so.domain)
          "State count $gs.count"
          Explore-API
        
        }
        "5"{
            #Select Light
            $states=Get-States
            $states
            Control-Light 
            Explore-API
        
            }
        "6" {
            Write-Host "Exiting..." -ForegroundColor Red
            return
        }
        default {
            Write-Host "Invalid choice. Try again." -ForegroundColor Red
            Explore-API
        }   
    }
}



$explore=$true
# Start the script
if($explore)
    {Explore-API}
#3. Call a service
#Enter the service domain (e.g., light): light
#Enter the service name (e.g., turn_on): turn_on
#Enter the service data in JSON format (e.g., {"entity_id": "light.living_room"}): 

<#


light.master_bedroom_sconces_2                   unavailable
light.master_bedroom_main_lights                 unavailable
light.sylvania_smart_10_year_a19_3               unavailable
light.sylvania_smart_10_year_a19_2               unavailable
light.dining_room_lights_2                       unavailable
light.living_room_fireplace_2                    unavailable
light.living_room_main_lights_2                  unavailable
light.kitchen_lights_2                           unavailable
light.hallway_hall_2                             unavailable
light.laurens_room_lauren_2
#>