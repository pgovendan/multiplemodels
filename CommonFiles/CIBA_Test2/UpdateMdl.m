%this file update the model.
%Inputs:  None
%Outputs: None.
         
function [ret]=UpdateMdl(Mdl_name,MFile_name)
try	
	disp(Mdl_name);
	db = load_system(Mdl_name)		
   
	disp('Model loaded successfully');
    evalin('base', MFile_name);
	set_param(Mdl_name,'SimulationCommand','Update');
	disp('Model updation completed successfully')
	ret = 0;

    exit(0);
catch e
    disp('Error While updating the model')
    
    disp(Mdl_name);
    ret = e.message;
	exit(1);
end
end
