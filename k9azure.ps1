$database = "meteohub"
$influx_ip = "52.232.32.94"
$Influx_URI = "http://$($influx_ip):8086"
$influx_write_uri=”$($Influx_URI)/write?db=$database&precision=ms”
$influx_query_uri=”$($Influx_URI)/query?db=$database”

### note there is neither a rest api, nor a json protocol in iflux "!"!!!
$authheader = "Basic " + ([Convert]::ToBase64String([System.Text.encoding]::ASCII.GetBytes("a:meteohub")))
$postParams = "q=CREATE DATABASE `"$database`""
Invoke-WebRequest -Method POST -uri "$Influx_URI/query" -Body  $postParams  -Verbose

$postParams = "q=CREATE USER meteohub WITH PASSWORD 'meteohub' WITH ALL PRIVILEGES"
Invoke-WebRequest -Method POST -uri "$Influx_URI/query"  -Body  $postParams  -Verbose


## verify Grafana
$IE=new-object -com internetexplorer.application
$IE.navigate2("http://$($influx_ip):3000")
$IE.visible=$true
