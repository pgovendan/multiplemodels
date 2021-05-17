%This file executes test cases using SIL model and save outports value in MAT files.
%Inputs:  Updated SIL test Harness model
%Outputs: MAT-Files.It contains executed results of outports and time value

function [status]= SIL_Test_Execution(model_name)
try
    tcpath   = strcat(pwd,'\testcase_MAT\');
    covpath  = strcat(pwd,'\CoverageReport\');
    
    if ~exist(tcpath, 'dir')
        mkdir(tcpath);
%     else
%         rmdir(tcpath);
%         mkdir(tcpath);
    end
    
    % Execute test cases and save outputs in MAT file
    bdclose all
    model_name_new = model_name; 
    sil_model_name = model_name_new(1:end-4);
    load_system(sil_model_name);

    f = find_system(sil_model_name,'SearchDepth',1,'BlockType','SubSystem');
    [time,data,signames,groupnames] = signalbuilder(f{1});
    num_of_grps = length(groupnames);

    for i = 1: num_of_grps
     signalbuilder(f{1},'activegroup',i)

     save_system();
     simout = sim(sil_model_name);%,'ReturnWorkspaceOutputs', 'on');%,'OutputSaveName','youtNew');

     output_logs = struct;
     to_workspace_blocks = find_system(sil_model_name,'BlockType','ToWorkspace');
     for j = 1: length(to_workspace_blocks)
        extract_name_toworskspace = get_param(to_workspace_blocks{j}, 'VariableName');
        g = eval(extract_name_toworskspace);
        output_logs.(extract_name_toworskspace) = g;
     end
     output_logs.tout=simout; %store time stamp
     tcname = strcat(sil_model_name,'_TC_',num2str(i));          
     save(tcname,'output_logs');
     movefile(strcat(tcname,'.mat'),tcpath,'f'); %move the mat file in a folder
     clear simout;

    end          
    status = 0;
    disp('SIL Test cases Executed Successfully');
%     exit(0);
catch
    status = 1;
    bdclose all;
    disp('Error in SIL Test cases Execution');
%     exit(1);
end
end