@echo off

set SAVEDIR=%CD%
cd %~d0
cd %SAVEDIR%

set JAVACMD=java

%JAVACMD% %JAVA_OPTS% -jar wpmanager.jar
