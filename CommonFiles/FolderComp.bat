@echo off
SET workspace=%1
SET ProjectName=%2
SET n=0
SET nmc=0
SET Data_Lines[]=0
SET changed_dirs=
SET changed_models=
SET xpvar=0	
SET p_dir=

REM Get the parent directory from Jenkins workspace
for %%a in ("%workspace%") do set "p_dir=%%~dpa"

REM Copy the checkout folders in Workspace to its parent directory
REM Xcopy /E /I /Y %workspace% %p_dir%\BackupTesting\ >NUL

REM Create directory in Backup folder
if not exist "%p_dir%\Backup\%ProjectName%\" mkdir %p_dir%\Backup\%ProjectName%\

REM Use Robocopy to comapre two folders
robocopy %workspace% %p_dir%\Backup\%ProjectName%\ /L /TS /MIR /LOG:%p_dir%\Diff.txt>NUL

REM Read the Diff.txt file
SET Line_No=15
:readfile
for /F "skip=%Line_No% delims=" %%i in (%p_dir%\Diff.txt) do (
	setlocal EnableDelayedExpansion
	SET /A "Line_No=!Line_No!+1"
	SET Data_Lines[!Line_No!]=%%i	
	goto condition
)
	:condition
	echo !Data_Lines[%Line_No%]!|find "\" >nul 
	if not errorlevel 1 (
		goto condition1
	)
	if errorlevel 1 (		
		set xpvar=!Data_Lines[%Line_No%]!				
		goto ModelName		
	)
	goto end	
	REM Find Newly added directory
	:condition1
	echo !Data_Lines[%Line_No%]!|find "新しいディレクトリ" >nul 
	if not errorlevel 1 (
		set line=!Data_Lines[%Line_No%]!
		REM setlocal EnableDelayedExpansion
		FOR /f "tokens=2 delims= " %%a IN ("!Data_Lines[%Line_No%]!") do set changed_dirs=%changed_dirs%,%%a
		REM endlocal & set n=%n%
		setlocal EnableDelayedExpansion
		SET /A "n=!n!+1"
		goto end
	)
	goto condition2
	:condition2
	REM Find deleted directory
	echo !Data_Lines[%Line_No%]!|find "*EXTRA Dir" >nul 
	if not errorlevel 1 (			
		set line=!Data_Lines[%Line_No%]!
		REM setlocal EnableDelayedExpansion
		FOR /f "tokens=3 delims= " %%a IN ("!Data_Lines[%Line_No%]!") do set changed_dirs=%changed_dirs%,%%a
		REM endlocal & set n=%n%
		REM setlocal EnableDelayedExpansion
		SET /A "n=!n!+1"
		goto end
	)
	goto condition3
	:condition3
	REM Read the next line	
	for /F "skip=%Line_No% delims=" %%p in (%p_dir%\Diff.txt) do ( 
		set xpvar=%%p
		goto break
	)
	:break
	REM Find Modified file 	
	echo %xpvar%|find "新しいディレクトリ" >nul
	if not errorlevel 1 (
		goto end
	)
	echo %xpvar%|find "新しい" >nul
	if not errorlevel 1 (
		REM setlocal EnableDelayedExpansion
		set line=!Data_Lines[%Line_No%]!
		REM setlocal EnableDelayedExpansion
		FOR /f "tokens=2 delims= " %%a IN ("!Data_Lines[%Line_No%]!") do set changed_dirs=%changed_dirs%,%%a
		REM endlocal & set n=%n%
		REM setlocal EnableDelayedExpansion
		SET /A "n=!n!+1"
		goto end
	)
	goto condition4
	:condition4
	REM Find Modified file 
	echo %xpvar%|find "古い" >nul  
	if not errorlevel 1 (
		set line=!Data_Lines[%Line_No%]!
		REM setlocal EnableDelayedExpansion
		FOR /f "tokens=2 delims= " %%a IN ("!Data_Lines[%Line_No%]!") do set changed_dirs=%changed_dirs%,%%a
		REM endlocal & set n=%n%
		REM setlocal EnableDelayedExpansion
		SET /A "n=!n!+1"
		goto end
	)
	goto condition5
	:condition5
	REM Find deleted file 
	echo %xpvar%|find "*EXTRA File" >nul 
	if not errorlevel 1 (
		REM setlocal EnableDelayedExpansion
		set line=!Data_Lines[%Line_No%]!
		REM setlocal EnableDelayedExpansion
		FOR /f "tokens=2 delims= " %%a IN ("!Data_Lines[%Line_No%]!") do set changed_dirs=%changed_dirs%,%%a
		REM endlocal & set n=%n%
		REM setlocal EnableDelayedExpansion
		SET /A "n=!n!+1"
		goto end
	)
	goto condition6
	:condition6
	REM Find Newly added file 
	echo %xpvar%|find "新しいファイル" >nul 
	if not errorlevel 1 (
		REM setlocal EnableDelayedExpansion
		set line=!Data_Lines[%Line_No%]!
		REM setlocal EnableDelayedExpansion
		FOR /f "tokens=2 delims= " %%a IN ("!Data_Lines[%Line_No%]!") do set changed_dirs=%changed_dirs%,%%a
		REM endlocal & set n=%n%
		REM setlocal EnableDelayedExpansion
		SET /A "n=!n!+1"
		goto end
	)	
	:ModelName
	echo %xpvar%|find "*EXTRA File" >nul 
	if not errorlevel 1 (
		goto end
	)
	echo %xpvar%|find ".mdl" >nul
	if not errorlevel 1 (		
		setlocal EnableDelayedExpansion
		FOR /f "tokens=3 delims=	" %%a IN ("!xpvar!") do set changed_models=%changed_models%,%%a
		SET /A "nmc=!nmc!+1"		
	)
	echo %xpvar%|find ".slx" >nul
	if not errorlevel 1 (		
		REM setlocal EnableDelayedExpansion
		FOR /f "tokens=3 delims=	" %%a IN ("!xpvar!") do set changed_models=%changed_models%,%%a
		SET /A "nmc=!nmc!+1"
		goto end
	)

	:end
	echo !Data_Lines[%Line_No%]!|find "-----" >nul 
	if not errorlevel 1 (		
		goto stopread
	)

	if errorlevel 1 (		
		goto readfile
	)
:stopread
REM Print all the changed directory names
if %n%==0 echo No Changes 
if %nmc%==0 set changed_models= No Changes
if NOT %n%==0 echo %changed_dirs%;%changed_models%
REM Clean the backup folder
del /q "%p_dir%\Backup\%ProjectName%\*"
for /D %%p in ("%p_dir%\Backup\%ProjectName%\*.*") do rmdir "%%p" /s /q
REM Copy the checkout folders in Workspace to its parent directory
Xcopy /E /I /Y %workspace% %p_dir%\Backup\%ProjectName%\ >NUL
endlocal
endlocal
endlocal