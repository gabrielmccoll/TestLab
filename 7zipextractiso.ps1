$isoloc ="C:\ISOs\6mnth2016.ISO"
$isoOut ="C:\ISOs\6mnth2016ext"

start-process -FilePath "$env:ProgramFiles\7-zip\7z.exe" `
-ArgumentList "e $isoloc -o $isoOut"