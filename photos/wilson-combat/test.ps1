$files = Get-ChildItem -Path .

$portraitFile = $null
$landscapeFile = $null

foreach ($file in $files) {
    # $file | Format-List
    # $file.BaseName

    if ($file.Extension -Ne ".jpg" -And $file.Extension -Ne ".png") {
        continue
    }

    if ($file.BaseName -Like "*-portrait") {
        $portraitFile = $file
    }
    elseif ($file.BaseName -Like "*-landscape") {
        $landscapeFile = $file
    }
}

if (!$portraitFile) {
    Write-Error "No portrait file found."
    exit
}

if (!$landscapeFile) {
    Write-Error "No landscape file found."
    exit
}

# $portraitFile | Format-List
# $landscapeFile | Format-List

$portraitWidths = @(
    320
    375,
    414,
    768
)

$landscapeWidths = @(
    568,
    667,
    812,
    1024,
    1366,
    1440,
    1680,
    1920
)

foreach ($width in $portraitWidths) {
    $fileName = "$($portraitFile.BaseName)-$($width)w$($portraitFile.Extension)"
    $webpFileName = "$($portraitFile.BaseName)-$($width)w.webp"
    
    Write-Host "Converting file '$fileName' to WebP file named '$webpFileName'."

    # magick $fileName -quality 100 $webpFileName
}

foreach ($width in $landscapeWidths) {
    $fileName = "$($landscapeFile.BaseName)-$($width)w$($landscapeFile.Extension)"
    $webpFileName = "$($landscapeFile.BaseName)-$($width)w.webp"
    
    Write-Host "Converting file '$fileName' to WebP file named '$webpFileName'."

    # magick $fileName -quality 100 $webpFileName
}

$htmlLines = @()

$htmlLines += "<picture>"

foreach ($width in $portraitWidths) {
    $fileName = "$($portraitFile.BaseName)-$($width)w.webp"
    $htmlLines += "<!-- $fileName -->"
}

foreach ($width in $landscapeWidths) {
    $fileName = "$($landscapeFile.BaseName)-$($width)w.webp"
    $htmlLines += "<!-- $fileName -->"
}

foreach ($width in $portraitWidths) {
    $fileName = "$($portraitFile.BaseName)-$($width)w$($portraitFile.Extension)"
    $htmlLines += "<!-- $fileName -->"
}

foreach ($width in $landscapeWidths) {
    $fileName = "$($landscapeFile.BaseName)-$($width)w$($landscapeFile.Extension)"
    $htmlLines += "<!-- $fileName -->"
}

$htmlLines += "</picture>"

$htmlLines | Out-File -FilePath "generated-snippet.txt"

# $portraitWidths
