

function Get-MHDSensors
{
    [CmdletBinding()]
    [OutputType([int])]
    Param
    (
    $meteohub = $global:meteohub.name
    )
$body = @{'info'="sensorids";'quotes'="1";"mode"="info";type="xml"}
$uri = 
[xml]$sensors = Invoke-WebRequest -UseBasicParsing -Uri $uri -ContentType "text/xml" -body @{'info'="sensorids";'quotes'="1";"mode"="info";type="xml"}# ).logger.sensor # -split "," | where {$_ -ne " "}
 
[psobject]$sensorsout = $sensors.logger.sensor 

$sensorsout | Add-Member -TypeName MeteohubSensors
$sensorsout | Add-Member -Name Station -MemberType NoteProperty -Value $meteohub
$sensorsout
}

function Get-MHDSensorData
{
    [CmdletBinding()]

    [OutputType([int])]
    Param
    (
    [Parameter(Mandatory = $true,ValueFromPipelineByPropertyName=$true)]
    #[ValidatePattern("[0-9A-F]{16}")]
    [String]$Station,
    [Parameter(Mandatory = $true,ValueFromPipelineByPropertyName=$true)]
    [string]$ID,
    [Parameter(Mandatory = $true,ValueFromPipelineByPropertyName=$true)]
    [string]$TYPE
    )
begin
    {

    }
process
    {
    if ($fromdate)
        {
        $body =  @{'sensor'=$id;quotes=1;"mode"="data";"type"="xml";start=$fromdate}
        }
    else
        {
        $body =  @{'sensor'=$id;quotes=1;"mode"="data";"type"="xml"}
        }
    $uri = "http://$($station)/meteolog.cgi"
    Write-Verbose $uri
    Write-Verbose $ID
    Write-Verbose $TYPE
    Write-Verbose $Station
    Write-Verbose $body
    [xml]$my = Invoke-WebRequest -UseBasicParsing -Uri $uri -ContentType "text/xml" -body $body
    #$hello =$my.Content -split " " -replace "<" -replace ">" -replace ""  -replace "\n" | where {$_ -ne ""}  
    #$type = $hello[0]
    #Write-Verbose $type
    #$data = $hello[1..($hello.Length -1 )]
    #$data  | ConvertFrom-StringData 
    $my | Select-Object -ExpandProperty $TYPE
    }
end
{

}
}

function Get-MHDSensorDataFromDate
{
    [CmdletBinding()]

    [OutputType([int])]
    Param
    (
    [Parameter(Mandatory = $true,ValueFromPipelineByPropertyName=$true)]
    #[ValidatePattern("[0-9A-F]{16}")]
    [String]$Station,
    [Parameter(Mandatory = $true,ValueFromPipelineByPropertyName=$true)]
    [string]$ID,
    [Parameter(Mandatory = $true,ValueFromPipelineByPropertyName=$true)]
    [string]$TYPE,
    [parameter(Mandatory = $false)]
    $fromdate
    )
begin
    {

    }
process
    {
    if ($fromdate)
        {
        $body =  @{'sensor'=$id;quotes=1;"mode"="data";"type"="xml";start=$fromdate}
        }
    else
        {
        $body =  @{'sensor'=$id;quotes=1;"mode"="data";"type"="xml"}
        }
    $uri = "http://$($station)/meteolog.cgi"
    Write-Verbose $uri
    Write-Verbose $ID
    Write-Verbose $TYPE
    Write-Verbose $Station
    Write-Verbose $body
    [xml]$my = Invoke-WebRequest -UseBasicParsing -Uri $uri -ContentType "text/xml" -body $body
    #$hello =$my.Content -split " " -replace "<" -replace ">" -replace ""  -replace "\n" | where {$_ -ne ""}  
    #$type = $hello[0]
    #Write-Verbose $type
    #$data = $hello[1..($hello.Length -1 )]
    #$data  | ConvertFrom-StringData 
    $my.logger | Select-Object -ExpandProperty $TYPE
    }
end
{

}
}