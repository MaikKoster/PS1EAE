function New-AEDeviceTag {
    <#
        .SYNOPSIS
        Adds a single device tag to the list of device tags

        .DESCRIPTION
        The New-AEDeviceTag Cmdlet adds a single device tag to the list of device tags.
        Device tags are identified by category, name and index. They do not have an explicit
        id. If tag with the same category, name and index already exists, the value and the
        modified date get updated.

        .EXAMPLE
        PS C:\>

    #>
    [CmdLetBinding()]
    param(
        # Specified the URL of the 1E ActiveEfficiency server
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$AEServer,

        # Specifies the AE DeviceID
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [Alias("Id")]
        [string]$DeviceID,

        # Specifies the category (namespace) for the tag.
        # The category and name uniquely identify the resource.
        # Category is mandatory. It must not be null, empty or only whitespace.
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Category,

        # Specifies the tag name.
        # Name is mandatory. It must not be null, empty or only whitespace.
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        # Specifies the tag index.
        # Will be 0 on default.
        [int]$Index,

        # Specifies the actual value of the tag.
        # TODO: Implement handling of different types
        [string]$Value,

        # Specifies the name of the client creating the tag entry.
        # Currently not mandatory.
        [string]$CreatedBy = "1E Nomad"
    )

    process{
        $Path = "devices/$DeviceID/tags"

        $Tag = @{
            Category = $Category
            Name = $Name
            Index = $Index
            Type = 0
            StringValue = ($Value.ToString())
        }

        if (-Not([string]::IsNullOrWhiteSpace($CreatedBy))) {
            $Tag.CreatedBy = $CreatedBy
        }

        Invoke-AERequest -Method Post -AEServer $AEServer -ResourcePath $Path -Body $Tag
    }
}