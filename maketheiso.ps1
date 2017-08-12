
$filesforiso = "C:\ISOs\6mnth2016ext"
$newiso = "C:\ISOs\6mnth2016GMMOD.iso"

dir $filesforiso | New-IsoFile -Path $newiso -BootFile "$filesforiso\boot\etfsboot.com" -Media DVDPLUSR -Title "Win2016mod6mo"
$filesforiso = "C:\ISOs\6mnth2016ext"
$newiso = "C:\ISOs\6mnth2016GMMOD.iso"

dir $filesforiso | New-IsoFile -Path $newiso -BootFile "$filesforiso\boot\etfsboot.com" -Media DVDPLUSR -Title "Win2016mod6mo"