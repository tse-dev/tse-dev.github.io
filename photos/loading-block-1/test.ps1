$convert = "D:\Tools\ImageMagick-7.1.0-4-portable-Q16-HDRI-x64\convert.exe"
$magick = "D:\Tools\ImageMagick-7.1.0-4-portable-Q16-HDRI-x64\magick.exe"
$force = $true
$quality = 95
$relativeHrefPath = "/photos/loading-block-1"

$imgStyle = "position: absolute; top: 0; width: 100%; height: 100%; object-fit: cover; object-position: center center; opacity: 0.6;"
$imgAltText = "Revolver loading block"

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

[int[]] $portraitWidths = @(
    320
    375,
    414,
    768
)

[int[]] $landscapeWidths = @(
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

    if (!(Test-Path -Path $fileName) -or $force) {
        Write-Host "Creating portrait image with width $width"

        & $convert "$($portraitFile.BaseName)$($portraitFile.Extension)" -resize "$width" $fileName
    }

    if (!(Test-Path -Path $webpFileName) -or $force) {
        Write-Host "Converting file '$fileName' to WebP file named '$webpFileName'."

        & $magick $fileName -quality $quality $webpFileName
    }
}

foreach ($width in $landscapeWidths) {
    $fileName = "$($landscapeFile.BaseName)-$($width)w$($landscapeFile.Extension)"
    $webpFileName = "$($landscapeFile.BaseName)-$($width)w.webp"

    if (!(Test-Path -Path $fileName) -or $force) {
        Write-Host "Creating landscape image with width $width"

        & $convert "$($landscapeFile.BaseName)$($landscapeFile.Extension)" -resize "$width" $fileName
    }

    if (!(Test-Path -Path $webpFileName) -or $force) {
        Write-Host "Converting file '$fileName' to WebP file named '$webpFileName'."

        & $magick $fileName -quality $quality $webpFileName
    }
}

$htmlLines = @()

$htmlLines += "<picture>"

foreach ($width in $portraitWidths) {
    $fileName = "$($portraitFile.BaseName)-$($width)w.webp"
    $htmlLines += "<source type=""image/webp"" media=""(max-width: $($width)px) and (orientation: portrait)"" srcset=""$relativeHrefPath/$fileName"">"
}

foreach ($width in $landscapeWidths) {
    $fileName = "$($landscapeFile.BaseName)-$($width)w.webp"
    $htmlLines += "<source type=""image/webp"" media=""(max-width: $($width)px)"" srcset=""$relativeHrefPath/$fileName"">"
}

foreach ($width in $portraitWidths) {
    $fileName = "$($portraitFile.BaseName)-$($width)w$($portraitFile.Extension)"
    $htmlLines += "<source media=""(max-width: $($width)px) and (orientation: portrait)"" srcset=""$relativeHrefPath/$fileName"">"
}

foreach ($width in $landscapeWidths) {
    $fileName = "$($landscapeFile.BaseName)-$($width)w$($landscapeFile.Extension)"
    $htmlLines += "<source media=""(max-width: $($width)px)"" srcset=""$relativeHrefPath/$fileName"">"
}

$lastWidth = $landscapeWidths[-1]

$htmlLines += "<img style=""$imgStyle"" src=""$relativeHrefPath/$($landscapeFile.BaseName)-$($lastWidth)w$($landscapeFile.Extension)"" loading=""lazy"" alt=""$imgAltText"" />"

$htmlLines += "</picture>"

$htmlLines | Out-File -FilePath "generated-snippet.txt"

# $portraitWidths
