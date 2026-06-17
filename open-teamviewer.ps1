param([string]$url)
#Aspyn Information Services Customer TeamViewer Protocol Launcher Example

$log = "C:\Users\Public\scripts\teamviewer-debug.log"

function Write-Log($msg) {
    $time = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Add-Content -Path $log -Value "$time  $msg"
}

Write-Log "---- Launch triggered ----"
Write-Log "Raw URL: $url"

# Extract ID
$id = $url -replace "open-teamviewer://", "" -replace "/+$", ""

Write-Log "Extracted ID: $id"

if (-not $id) {
    Write-Log "ERROR: No ID extracted"
    exit 1
}
# Replace with your Teamviewer install location
$exe = "C:\Program Files (x86)\TeamViewer\TeamViewer.exe"

# Grab the AAAAARGGGGS matey
$args = @("-i", $id)

Write-Log "Executable: $exe"
Write-Log "Arguments: $($args -join ' ')"

try {
    Write-Log "Launching TeamViewer..."
    Start-Process -FilePath $exe -ArgumentList $args
    Write-Log "Launch command issued successfully"
}
catch {
    Write-Log "ERROR launching TeamViewer: $_"
}

Write-Log "---- End ----"
