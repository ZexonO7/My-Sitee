# PowerShell script to move and replace paths

# Create needed directories if they don't exist
$mediaDir = "assets\media"
if (!(Test-Path $mediaDir)) {
    New-Item -ItemType Directory -Force -Path $mediaDir
}

# Move remaining files from _assets/media to assets/media
if (Test-Path "_assets\media") {
    Get-ChildItem "_assets\media\*" -File | ForEach-Object {
        $destFile = Join-Path "assets\media" $_.Name
        if (!(Test-Path $destFile)) {
            Copy-Item $_.FullName $destFile -Force
        }
    }
    Remove-Item "_assets\media" -Recurse -Force -ErrorAction SilentlyContinue
}

# Clean up empty _assets directory if it exists
if (Test-Path "_assets") {
    Remove-Item "_assets" -Recurse -Force -ErrorAction SilentlyContinue
}

# Now read the index.html file
$content = Get-Content "index.html" -Raw

# Replace all occurrences of _assets/media with assets/media in JSON strings
$content = $content -replace '"_assets/media/', '"assets/media/'

# Save the updated content back to index.html
$content | Set-Content "index.html" -NoNewline

Write-Host "File paths updated successfully!"
