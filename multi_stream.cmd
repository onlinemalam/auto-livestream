@echo off
setlocal enabledelayedexpansion
set COUNT=0

REM Batasi maksimal jumlah stream paralel, misalnya 30
set MAX_PARALLEL=30

REM Ambil semua streamkey dari file
for /f "tokens=*" %%A in (streamkey.txt) do (
    set /a COUNT+=1
    echo Menjalankan stream ke channel %%A...
    start "" /b ffmpeg -re -stream_loop -1 -i input.mp4 -c:v libx264 -preset veryfast -maxrate 3000k -bufsize 6000k -pix_fmt yuv420p -g 50 -c:a aac -b:a 128k -f flv "rtmp://a.rtmp.youtube.com/live2/%%A"
    if !COUNT! geq %MAX_PARALLEL% (
        echo Menunggu proses...
        timeout /t 10 >nul
        set COUNT=0
    )
)
