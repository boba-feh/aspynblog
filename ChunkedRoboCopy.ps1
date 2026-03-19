# ------------------------------
# Aspyn Safe Chunked Copy of Large Files
# ------------------------------
#Reduce I/O impacts on Virtual Machine host when doing large file transfers
#Edit Src and Dest Variables for your locations

$src = "F:\AspynExportDrive\Virtual Hard Disks\AccountingServer.vhdx"
$dest = "D:\virtualHDs\AccountingServer.vhdx"

# Copy settings
$chunkSizeMB = 16          # size of each chunk in MB
$sleepMS = 50              # pause between chunks in milliseconds

# Convert MB to bytes
$chunkSize = $chunkSizeMB * 1MB

# Get total file size
$totalBytes = (Get-Item $src).Length
$copiedBytes = 0

# Open file streams
$reader = [System.IO.File]::OpenRead($src)
$writer = [System.IO.File]::OpenWrite($dest)

# Create buffer
$buffer = New-Object byte[] $chunkSize

Write-Host "Starting chunked copy..."
Write-Host "File size: $([math]::Round($totalBytes/1GB,2)) GB"

while (($read = $reader.Read($buffer,0,$chunkSize)) -gt 0) {
    $writer.Write($buffer,0,$read)
    $copiedBytes += $read

    # Show progress
    $percent = [math]::Round(($copiedBytes / $totalBytes) * 100, 2)
    Write-Progress -Activity "Copying VHD..." -Status "$percent% Complete" -PercentComplete $percent

    # Pause to reduce I/O contention
    Start-Sleep -Milliseconds $sleepMS
}

# Close streams
$reader.Close()
$writer.Close()
Write-Host "Copy completed successfully!"
