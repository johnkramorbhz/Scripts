[array] $inputs = get-childitem -filter *.mp4 -name 
if ($inputs.Length -ne 0) {
    for ($num = 0 ; $num -lt $inputs.Length ; $num++) {
        $output_arr = $inputs[$num].Split('.') 
        $output_name = $output_arr[0] + "_av1." + $output_arr[1]
        Write-Output $output_name
        if(Test-Path -Path $output_name -PathType Leaf){
            if((Get-Item $output_name).length -gt 500mb){
                Write-Host "Input file '" -NoNewline;
                Write-Host $inputs[$num] -ForegroundColor Green -NoNewline;
                Write-Host "' has the output '" -NoNewline;
                Write-Host $output_name -ForegroundColor Yellow -NoNewline;
                Write-Host "', skipped"
                continue
            }
        }
        .\ffmpeg -hwaccel cuda -i $inputs[$num] -c:v av1_nvenc -b:v 15M -c:a copy $output_name
    }
}