[array] $inputs = get-childitem -filter *.mkv -name 
$vid_bitrate = "25M"
$codec = ""
if ($inputs.Length -ne 0) {
    for ($num = 0 ; $num -lt $inputs.Length ; $num++) {
        if ($codec -eq "AV1") {
            $output_name = "C_" + $inputs[$num].Split('.')[0] + "_AV1_" + $vid_bitrate + ".mp4"
            $ffmpeg_codec = "av1_nvenc"
        }
        else {
            $output_name = "C_" + $inputs[$num].Split('.')[0] + "_HEVC_" + $vid_bitrate + ".mp4"
            $ffmpeg_codec = "hevc_nvenc"
        }
        if (Test-Path -Path $output_name -PathType Leaf) {
            if ((Get-Item $output_name).length -gt 500mb) {
                Write-Host "Assuming input file '" -NoNewline;
                Write-Host $inputs[$num] -ForegroundColor Green -NoNewline;
                Write-Host "' has the output '" -NoNewline;
                Write-Host $output_name -ForegroundColor Yellow -NoNewline;
                Write-Host "', skipped"
                continue
            }
        }
        $current_job = $num + 1
        [string]$current_job = $current_job.ToString()
        $total_jobs = $inputs.Length
        [string]$total_jobs = $total_jobs.ToString()
        $info_string = "Running job " + $current_job + " out of " + $total_jobs
        Write-Host $info_string -ForegroundColor Yellow

        .\ffmpeg -hide_banner -hwaccel cuda -i $inputs[$num] -c:v $ffmpeg_codec -b:v $vid_bitrate -c:a copy $output_name
    }
}
else {
    Write-Warning "No file(s) in this directory matches .mkv suffix, exiting..."
}