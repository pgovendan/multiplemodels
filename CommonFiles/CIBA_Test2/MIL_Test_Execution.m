%This file executes test cases using MIL model and save outports value in MAT files.
%Inputs:  Updated MIL test Harness model
%Outputs: MAT-Files.It contains executed results of outports and time value

function [status]= MIL_Test_Execution(model_name)
try
    tcpath   = strcat(pwd,'\testcase_MAT\');
    
    covpath  = strcat(pwd,'\CoverageReport\');
    
    if ~exist(tcpath, 'dir')
        mkdir(tcpath);
    else
        rmdir(tcpath,'s');
        mkdir(tcpath);
    end

    % Execute test cases and save outputs in MAT file
    bdclose all
    %BCM_C1A_EcuMonitor_Constant_2;
    %SAMPLE_TIME;
    model_name_new = model_name; 
    mil_model_name = model_name_new(1:end-4);
    load_system(mil_model_name);
    f = find_system(mil_model_name,'SearchDepth',1,'BlockType','SubSystem');
    [time,data,signames,groupnames] = signalbuilder(f{1});
    num_of_grps = length(groupnames);

    for i = 1: num_of_grps
     signalbuilder(f{1},'activegroup',i)

     save_system();
     simout = sim(mil_model_name);%,'ReturnWorkspaceOutputs', 'on');%,'OutputSaveName','youtNew');

     output_logs = struct;
     to_workspace_blocks = find_system(mil_model_name,'BlockType','ToWorkspace');
     for j = 1: length(to_workspace_blocks)
        extract_name_toworskspace = get_param(to_workspace_blocks{j}, 'VariableName');
        g = eval(extract_name_toworskspace);
        output_logs.(extract_name_toworskspace) = g;
     end
     output_logs.tout=simout; %store time stamp
     tcname = strcat(mil_model_name,'_TC_',num2str(i));          
     save(tcname,'output_logs');
     movefile(strcat(tcname,'.mat'),tcpath,'f'); %move the mat file in a folder
     clear simout;

    end
    status = 0;
    disp('MIL Test cases Executed Successfully');
%     exit(0);
catch
    bdclose all;
    status = 1;
    disp('Error in MIL Test cases Execution');
%     exit(1);
end
end
