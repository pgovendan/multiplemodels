%this file checks model design errors(dead logic,division by zero etc..)
%Inputs:  Simulink Model
%Outputs: Simulink design error report(HTML).
         
function [ret]=SLDV_verifier(Model_Name,MFile_name)
try
	bdclose all;
	evalin('base', MFile_name);
	model_file = Model_Name;
	open_system(model_file);
	load_system(model_file);		
	set_param(model_file,'SimulationCommand','Update');
	
	opts = sldvoptions;
	opts.Mode = 'DesignErrorDetection';
	opts.DesignMinMaxConstraints= 'on';
	opts.DetectDivisionByZero = 'on';
	opts.DetectIntegerOverflow = 'on';
	opts.DetectInfNaN =  'on';
	opts.DesignMinMaxCheck = 'on';
	opts.SaveReport = 'on';
	opts.MaxProcessTime = 500;
    opts.SaveExpectedOutput = 'on';
    opts.SaveDataFile = 'on';

	[ status, files ] = sldvrun(Model_Name,opts,true);
	close_system(model_file,0);
	disp('Model design verification completed successfully')
    ret = 0;
	exit(0);
	
catch
    disp('Error While model design verification')
    ret = 1;
	exit(1);
end
end