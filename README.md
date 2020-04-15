[![Build status](https://ci.appveyor.com/api/projects/status/7mfb39slx2s8yuok/branch/master?svg=true)](https://ci.appveyor.com/project/MKoster/ps1eae/branch/master) [![PS Gallery](https://img.shields.io/badge/install-PS%20Gallery-blue.svg)](https://www.powershellgallery.com/packages/PS1EAE)

# PS1EAE PowerShell module

The "PS1EAE" PowerShell module is a wrapper around the 1E Active Efficiency Server API.

Active Efficiency is an infrastructure component from 1E to support other products like 1E Nomad or AppClarity. It allows access via a REST based web api for certain actions. However documentation is very sparse and the correct syntax is pretty difficult to figure out for certain calls.

The "PS1EAE" PowerShell module is supposed to make access to the Active Efficiency api easier.

It's currently in alpha stage and only a part of the existing functionality is covered. All names and values are subject to possible changes. Please test properly before using this module.

This module is provided "AS IS" in accordance with the repository license.

## Requirements

PowerShell Version 3.0+

## Install

### PowerShell Gallery Install (Requires PowerShell v5)

```powershell
    Install-Module -Name PS1EAE
```

### Manual Install

Download [PS1EAE-0.0.1.zip](https://github.com/MaikKoster/PS1EAE/releases/download/v0.0.1/PS1EAE-0.0.1.zip) and extract the contents into `'C:\Users\[User]\Documents\WindowsPowerShell\Modules\PS1EAE'` (you may have to create these directories if they don't exist.). Then run

```powershell
    Get-ChildItem 'C:\Users\[User]\Documents\WindowsPowerShell\Modules\PS1EAE\' -Recurse | Unblock-File
    Import-Module PSNlog
```

## Initial setup and queries

### Get Active Efficiency related information

All CmdLets require the URL under which the Active Efficiency web api can be reached. If you have any 1E component installed and Active Efficiency is enabled, you should be abe to use the 'Get-AELocalDeviceInfo CmdLet, which queries the local registry for further information. One of them being the correct URL.

```powershell
    $AEInfo = Get-AELocalDeviceInfo
    $URL = $AEInfo.PlatformUrl
    $DeviceID = $AEInfo.DeviceId
```

Then this information can be used to get further information about an Active Efficiency resource. E.g. get a list of Active Efficiency devices

```powershell
    $Devices = Get-AEDevice -AEServer $Url
```

Most of the CmdLets that could potentially return a lot of entries return the entries in batches. You can use the 'Top' and 'Skip' parameters, to iterate through the batches. On default, standard queries will return 100 entries. Set 'Top' to 0, to return all entries. Be aware, depending on the size of your environment, that might return a large amount of data.

```powershell
    $AllDevices = Get-AEDevice -AEServer $Url -Top 0
```

Or get information about a device

```powershell
    $Device = Get-AEDevice -AEServer $Url -DeviceID $DeviceID
```

The content that is associated with the device, which can be very helpful to validate devices that are configured as precaches

```powershell
    $Content = Get-AEDeviceContent -AEServer $Url -DeviceID $DeviceID
```

Or to find devices that host content in a subnet

```powershell
    $Adapter = Get-AEDeviceAdapterConfiguration -AEServer $Url -DeviceID $DeviceID

    $Sources = Find-AEContent -AEServer $Url -Subnet $Adapter.Ipv4Subnet -Content TST012345 -Version 1 -Extend Subnet
```

For certain scenarios, it might be usefull to persist some information about a device. So rather than using a separate database, how about using the device tags from Active Efficiency

```powershell
    New-AEDeviceTag -AEServer $Url -DeviceID $DeviceID -Category 'OSD' -Name 'InstallO365' -Value 'YES'
```

As mentioned, there are certain limitation on the Web api, e.g. you can't remove a device or device tag, so handle with care ;)

## Contributors

* [Maik Koster](https://github.com/MaikKoster)
* Rustam Gadeev

## License

* see [LICENSE](LICENSE) file

## Contact

* Twitter: [@Maik_Koster](https://twitter.com/Maik_Koster)
* Blog: [MaikKoster.com](http://MaikKoster.com/)
