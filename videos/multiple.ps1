[array] $inputs = ""
[array] $outputs = ""
if ($inputs.Length -eq $outputs.Length -and $inputs.Length -gt 0 -and $outputs.Length -gt 0) {
    for ($num = 0 ; $num -lt $inputs.Length ; $num++) {
        if ($inputs[$num].Length -ne 0 -and $outputs[$num].Length -ne 0) {
            .\ffmpeg -hwaccel cuda -i $inputs[$num] -c:v hevc_nvenc -b:v 30M -c:a copy -tag:v hvc1 $outputs[$num]
        }
        
    }
}else{
    Write-Output "ERROR: Inputs and Outputs does not have the same length!"
}

