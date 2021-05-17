%This file applies the advisory settings to the model and generate compliance report.
%Inputs:  Simulink Model
%Outputs: Simulink design error report(HTML).


function [ret]=apply_advisory_setting(model_file,MFile_name)
try
    bdclose all
    % model_file = model_file(1:end-4);
	evalin('base', MFile_name);
    sel_req_chks = selected_checks();
    disp(strcat('model name is: ',model_file));
    
    load_system(model_file);   
    
	disp('Loading the Model & Checks...')

    %Get model advisor object of the model
    ma = Simulink.ModelAdvisor.getModelAdvisor(model_file);
    
    %Close any model advisor report
    setBaselineMode(ma,true)
    closeReport(ma);
    %Deselect All Checks/Tasks
    oc = deselectCheckAll(ma);
    %ot = deselectTaskAll(ma)
    selectCheck(ma,sel_req_chks);
         

    %run the selected task
    disp('Running Selected JMAAB Advisory Checks on the Model...')
    % pause(2);
	%ss = runTask(ma)
    ss = runCheck(ma,sel_req_chks);

    %Generate Advisor Report
	disp('Showing Advisory Checks Report...')
    % pause(1);
    displayReport(ma);
   
    disp('Advisory Settings Report Successfully Generated')
    % pause(1);
    close_system(model_file);
    movefile slprj JMAAB_Report
    ret = 1;
    %close(waitbar_status);
	%exit(0)
catch
    %close(waitbar_status);
    disp('Error While Running Model Advisory Checks')
    % pause(3);
    ret = 0;
	%exit(1)

end
end


