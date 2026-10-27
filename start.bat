@echo off
setlocal EnableExtensions
cd /d "%~dp0"

docker info >nul 2>&1
if errorlevel 1 (
  echo Docker calismiyor. Docker'i acip tekrar deneyin.
  exit /b 1
)

if not exist .env copy /Y .env.example .env >nul

docker compose up --build -d
if errorlevel 1 exit /b 1

echo GestureBot hazir olana kadar bekleniyor...
set /a TRIES=0

:waitloop
if %TRIES% GEQ 60 (
  echo Web konteyneri saglikli olmadi. docker compose logs web
  exit /b 1
)

set CID=
for /f %%I in ('docker compose ps -q web') do set CID=%%I
set STATUS=
if defined CID (
  for /f "delims=" %%S in ('docker inspect --format "{{if .State.Health}}{{.State.Health.Status}}{{else}}{{.State.Status}}{{end}}" %CID%') do set STATUS=%%S
)
if "%STATUS%"=="healthy" goto ready

set /a TRIES+=1
ping -n 3 127.0.0.1 >nul
goto waitloop

:ready
echo GestureBot hazir: http://localhost:8080
start "" "http://localhost:8080"
