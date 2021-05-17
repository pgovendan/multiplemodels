@echo off
SET mname=%1 
SET mfilename=%2
SET /A stage_num=%3
SET build_n=%4%
SET funPath=%5

SET matlabpath_2018b="C:\MATLAB\R2018b\bin\matlab.exe"
SET matlabpath_2019b="C:\MATLAB\R2019b\bin\matlab.exe"
REM echo "MFile Name in Batch File Selected as: = %mfilename%
REM echo "Stage number is: = %stage_num%

IF %stage_num%==2 (
	%matlabpath_2018b% -wait -log -nodesktop -nosplash -r "cd(getenv('funPath'));mf=getenv('mfilename'); mfile_name=strtrim(mf); ip=getenv('mname');model_file=strtrim(ip);ret=UpdateMdl(model_file,mfile_name);pause(5);exit"
	goto return_value
)
IF %stage_num%==3 (
	%matlabpath_2018b% -wait -log -nodesktop -nosplash -r "cd(getenv('funPath'));mf=getenv('mfilename'); mfile_name=strtrim(mf); ip=getenv('mname');model_file=strtrim(ip);ret=apply_config_setting(model_file,'New_config_setting');pause(5); exit"
	goto return_value
)
IF %stage_num%==4 (
	%matlabpath_2018b% -wait -log -nodesktop -nosplash -r "cd(getenv('funPath'));mf=getenv('mfilename'); mfile_name=strtrim(mf); ip=getenv('mname');model_file=strtrim(ip);ret=Simmdl(model_file,mfile_name);pause(5);exit"
	goto return_value
)
IF %stage_num%==5 (
	%matlabpath_2018b% -wait -log -nodesktop -nosplash -r "cd(getenv('funPath'));mf=getenv('mfilename'); mfile_name=strtrim(mf); ip=getenv('mname');model_file=strtrim(ip);ret=SLDV_verifier(model_file,mfile_name);pause(5);exit"
	goto return_value
)
IF %stage_num%==6 (
	%matlabpath_2019b% -wait -log -nodesktop -nosplash -r "cd(getenv('funPath'));mf=getenv('mfilename'); mfile_name=strtrim(mf);ip=getenv('mname');model_file=strtrim(ip);ret=apply_advisory_setting(model_file,mfile_name);pause(5);exit"
	goto return_value
)
IF %stage_num%==7 (
	%matlabpath_2018b% -wait -log -nodesktop -nosplash -r "cd(getenv('funPath'));mf=getenv('mfilename'); mfile_name=strtrim(mf); ip=getenv('mname');model_file=strtrim(ip);ret=TestCasesGenSLDV(model_file,mfile_name);pause(5);exit"
	goto return_value
)
IF %stage_num%==8 (
	%matlabpath_2018b% -wait -log -nodesktop -nosplash -r "cd(getenv('funPath'));mf=getenv('mfilename'); mfile_name=strtrim(mf); ip=getenv('mname');model_file=strtrim(ip);ret=MIL_Testing(model_file,1,mfile_name);pause(5);exit"
	goto return_value
)
IF %stage_num%==9 (
	%matlabpath_2018b% -wait -log -nodesktop -nosplash -r "cd(getenv('funPath'));mf=getenv('mfilename'); mfile_name=strtrim(mf); ip=getenv('mname');model_file=strtrim(ip);ret=SIL_Testing(model_file,mfile_name);pause(5);exit"
	goto return_value
)
IF %stage_num%==10 (
 	%matlabpath_2018b% -wait -log -nodesktop -nosplash -r "cd(getenv('funPath'));mf=getenv('mfilename'); mfile_name=strtrim(mf); ip=getenv('mname');model_file=strtrim(ip);bp=getenv('build_n');build_num=strtrim(bp);ret=create_comparison_report(model_file,build_num);pause(5);exit"
REM	%matlabpath_2018b% -wait -log -nodesktop -nosplash -r "cd(getenv('funPath'));mf=getenv('mfilename'); mfile_name=strtrim(mf); ip=getenv('mname');model_file=strtrim(ip);bp=getenv('build_n');build_num=strtrim(bp);ret=create_comparison_report();pause(5);exit"
	goto return_value
)
:return_value
echo %ERRORLEVEL%
