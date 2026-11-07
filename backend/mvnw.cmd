@echo off
setlocal
set "MAVEN_VERSION=3.9.16"
set "MAVEN_HOME=%USERPROFILE%\.m2\wrapper\dists\cloudcart-maven\%MAVEN_VERSION%\apache-maven-%MAVEN_VERSION%"
if not exist "%MAVEN_HOME%\bin\mvn.cmd" (
  echo CloudCart needs Apache Maven %MAVEN_VERSION%. Downloading it to your user profile...
  powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0maven-bootstrap.ps1" -Version %MAVEN_VERSION%
  if errorlevel 1 exit /b 1
)
call "%MAVEN_HOME%\bin\mvn.cmd" %*
exit /b %errorlevel%
