Param(
    [Parameter(Mandatory=$true)][string]$sourceBranch,
    [Parameter(Mandatory=$true)][string]$grafanaToken,
    [Parameter(Mandatory=$true)][string]$grafanaUrl,
    [Parameter(Mandatory=$true)][string]$gitUser,
    [Parameter(Mandatory=$true)][string]$gitUserMail
    )

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

Write-host "Checkout to branch $sourceBranch"
git checkout --track origin/$sourceBranch
git config  user.name "$gitUser"
git config  user.email "$gitUserMail"


# Set the required headers in order to access Grafana API 
$auth = "Bearer $grafanaToken"
$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers.Add("Authorization", $auth)


$sourceDir = $env:BUILD_SOURCESDIRECTORY


Write-host "Grafana Url: $grafanaUrl"
Write-host "Adding new folders"
$folders = (Invoke-RestMethod "$grafanaUrl/api/folders" -Method 'GET' -Headers $headers | ConvertTo-Json |ConvertFrom-Json).value

foreach($folder in $folders) {
    
    $title = $folder.title
    if(!(Test-Path $sourceDir\$title)) {
        New-Item $sourceDir\$title -ItemType Directory
        New-Item $sourceDir\$title\.gitkeep -ItemType File
    }
}


Write-host "Updating dashboards"
$dashboards = (Invoke-RestMethod "$grafanaUrl/api/search?type=dash-db&limit=5000" -Method 'GET' -Headers $headers | ConvertTo-Json |ConvertFrom-Json).value

foreach($dashboard in $dashboards) {
    if((Test-Path "$sourceDir\$($dashboard.folderTitle)\") -and ($dashboard.folderTitle.Length -gt 3))
    {
        $title = $dashboard.title.Replace('/',' ')
        $title = $title.Replace('\',' ')
        write-host $title
        $dashboardData = Invoke-RestMethod "$grafanaUrl/api/dashboards/uid/$($dashboard.uid)" -Method 'GET' -Headers $headers
        $dashboardData.dashboard | convertto-json -depth 100 | Out-File -FilePath ".\$($dashboard.folderTitle)\$title.json" 
    }
}


Write-host "Adding all changes to git"
git add .
$msg = get-date -Format dd-MM-yyyy
git commit -am $msg

git push origin

Write-host "Running git status command"
git status