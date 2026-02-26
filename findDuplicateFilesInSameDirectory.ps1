#From Blog post https://aspyn.com/2026/02/25/windows-finding-and-removing-accidentally-created-duplicate-files-through-a-mistaken-copy/
$startPath = "C:\users\BusinessUser\downloads"

Write-Host "Scanning for duplicate '-copy' files in $RootPath..." -ForegroundColor Cyan
Write-Host ""

# Get all files matching * -copy.*
Get-ChildItem -Path $startPath -Recurse -File -Filter "* -copy.*" | ForEach-Object {

    $CopyFile = $_
    
    # Build original filename (remove "-copy" before extension)
  
    $OriginalName = $CopyFile.Name -replace ' -copy(?=\.)', ''
    $OriginalPath = Join-Path $CopyFile.DirectoryName $OriginalName
    
    #Debugging Entries
    #Write-Host "  Checking File: $($CopyFile.Name)"
    #Write-Host "Checking original path: $($OriginalPath)"

    # Check if original file exists
    if (Test-Path $OriginalPath) {

        $OriginalFile = Get-Item $OriginalPath

        # First compare file sizes (quick check)
        if ($CopyFile.Length -eq $OriginalFile.Length) {

            # Compute hashes
            $CopyHash = Get-FileHash $CopyFile.FullName -Algorithm SHA256
            $OriginalHash = Get-FileHash $OriginalFile.FullName -Algorithm SHA256

            if ($CopyHash.Hash -eq $OriginalHash.Hash) {

                Write-Host "----------------------------------------" -ForegroundColor Yellow
                Write-Host "Duplicate Found:" -ForegroundColor Green
                Write-Host ""
                Write-Host "Original File:"
                Write-Host "  Path: $($OriginalFile.FullName)"
                Write-Host "  Size: $($OriginalFile.Length) bytes"
                Write-Host "  Hash: $($OriginalHash.Hash)"
                Write-Host ""
                Write-Host "Copy File:"
                Write-Host "  Path: $($CopyFile.FullName)"
                Write-Host "  Size: $($CopyFile.Length) bytes"
                Write-Host "  Hash: $($CopyHash.Hash)"
                Write-Host ""

                $Response = Read-Host "Delete the copy file? (Y/N)"

                if ($Response -match '^[Yy]$') {
                    Remove-Item $CopyFile.FullName -Force
                    Write-Host "Deleted: $($CopyFile.FullName)" -ForegroundColor Red
                }
                else {
                    Write-Host "Skipped." -ForegroundColor Gray
                }

                Write-Host ""
           }
        }
    }
}

Write-Host "Scan complete." -ForegroundColor Cyan
