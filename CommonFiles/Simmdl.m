%this file Simulate the model.
%Inputs:  Simulink Model
%Outputs: None.

function [ret]=Simmdl(Model_Name,MFile_name,file_path)
try
	bdclose all;        
	evalin('base', MFile_name);
	simOut = sim(Model_Name)  %  Error code generation 
	disp('Model Simulation completed successfully')	 
        ret = 0;
	exit(0);
	
catch e
    disp('Error While simulating the model')
    fid = fopen(file_path, 'w');
    fprintf(fid,'%s\n',e.message);  
    fclose(fid);
    ret = 1;
    exit(1);
end
end
