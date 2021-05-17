%this file generates test cases using SLDV and also generates MIL test harness model and coverage report.
%Inputs:  Simulink Model
%Outputs: Testcases in MAT file format
%         Test Harness model
%         Model coverage report(HTML).
         
function [ret]=TestCasesGenSLDV(Model_Name,MFile_name)
try
	bdclose all;
	evalin('base', MFile_name);
	
    if(exist('sldv_output','dir'))
        rmdir('sldv_output','s')
    end
	
	opts = sldvoptions;
	opts.Mode = 'TestGeneration';
    disp('1')
	opts.ModelCoverageObjectives = 'MCDC';  
	opts.MaxTestCaseSteps = 10000;
    disp('2')
	opts.TestSuiteOptimization = 'Auto';
	opts.SaveHarnessModel = 'on';
    disp('3')
	opts.SaveReport = 'on';
	opts.MaxProcessTime = 1800; 
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

