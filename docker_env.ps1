function flatten($a) { ,@($a | % {$_}) }

Set-PSDebug -Trace 1
$MODES = @(
    @('--optimize', '-O'),
    @('--restore', '-R'),
    @('--start', '-S')
)
$mode = $args[0]
if (!$Env:Path.Contains('docker') -or !(flatten $MODES).Contains($mode)) {
    Write-Error "docker doesnt install on this computer on not added to PATH system varible"
    return -1
}
if ($MODES[0].Contains($mode)) {
    optimize-vhd -Path .\ext4.vhdx -Mode full
} elseif ($MODES[1].Contains($mode)) {
    docker run --name postgresql -e POSTGRES_PASSWORD=root -d -p 5432:5432 postgres
    docker run --name rabbitmq -p 5672:5672 -p 15672:15672 rabbitmq
    docker run --name mongodb -p 27017:27017 postgres
} elseif ($MODES[2].Contains($mode)) {
    Start-Service -Name com.docker.service
}
return 0