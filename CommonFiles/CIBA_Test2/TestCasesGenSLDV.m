%this file generates test cases using SLDV and also generates MIL test harness model and coverage report.
%Inputs:  Simulink Model
%Outputs: Testcases in MAT file format
%         Test Harness model
%         Model coverage report(HTML).
         
function [ret]=TestCasesGenSLDV(Model_Name,MFile_name,model_complx)
try
	bdclose all;
	evalin('base', MFile_name);
	
    if(exist('sldv_output','dir'))
        rmdir('sldv_output','s')
    end
	
	opts = sldvoptions;
	opts.Mode = 'TestGeneration';
    disp(model_complx)
	opts.ModelCoverageObjectives = 'MCDC';  
	opts.MaxTestCaseSteps = 10000;
    disp('2')
	opts.TestSuiteOptimization = 'Auto';
	opts.SaveHarnessModel = 'on';
    disp('3')
	opts.SaveReport = 'on';
    if(model_complx==1)
	opts.MaxProcessTime = 1800;     % 30 Minutes to testcase generation
    elseif(model_complx==2)
    opts.MaxProcessTime = 3600;      % 60 Minutes to testcase generation
    elseif(model_complx==3)
    opts.MaxProcessTime = 14400;      % 120(2 hrs) Minutes to testcase generation
    elseif(model_complx==4)
    opts.MaxProcessTime = 28800;      % 240(4hrs) Minutes to testcase generation
    else
    opts.MaxProcessTime = 1800;      %  default 30 Minutes to testcase generation
    end
    
    opts.SaveExpectedOutput = 'on';
    opts.SaveDataFile = 'on';

    disp('loading model')
	load_system(Model_Name);
	
     disp('SLDV run on model')
	[ status, files ] = sldvrun(Model_Name, opts, true);
	close_system(Model_Name,0);

    disp('Test cases generated  successfully')
    ret = 0;
	exit(0);
catch
    disp('Error While creating test cases')
    ret = 1;
	exit(1);
end
end

