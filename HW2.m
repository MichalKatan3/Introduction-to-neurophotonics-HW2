%% Reset
clear all;
close all;
clc;
cd ('C:\Users\katanmi\OneDrive - Bar-Ilan University - Students\BIU server\M.Sc research\1courses\Introduction to neurophotonics\HW2')

for rec_idx=1:4
    %% Loading the files
    % Reading all frames of the record
    path_directory = 'C:\Users\katanmi\OneDrive - Bar-Ilan University - Students\BIU server\M.Sc research\1courses\Introduction to neurophotonics\HW2\OneDrive_1_07-07-2024\records';
   
    [full_path,exp_name{rec_idx}]=find_pathAndName([path_directory,'\',num2str(rec_idx)]);
    % go back to the parent file directory
    cd ('C:\Users\katanmi\OneDrive - Bar-Ilan University - Students\BIU server\M.Sc research\1courses\Introduction to neurophotonics\HW2')
    % finding TIFF files
    files = dir([full_path '/*.TIFF']);
    num_files = length(files);
    rec=ReadRecord(full_path);
    
    %% Temporal & spatial noise
    t_noise(rec_idx,1) = mean2(std(rec,0,3)); % temporal noise
    s_noise(rec_idx,1) = std2(mean(rec,3));   % spatial noise
    s_loc_noise(rec_idx,1) = mean2(stdfilt(mean(rec,3), ones(7))); % Local Spatial Noise with window size of 7
    for image_idx=1:num_files
        loc_fram_noise(:,image_idx)=mean(stdfilt(rec(:,:,image_idx),ones(7)));
    end
    s_loc_frame_noise(rec_idx,1) = mean2(loc_fram_noise); % Local Spatial Noise with window size of 7 per frame
    
    tot_noise(rec_idx,1)=sqrt(t_noise(rec_idx,1).^2+s_loc_noise(rec_idx,1).^2); % total noise
    
   
end

%% Table of noise
% Creating a table:
noise_table = table();
noise_table.temporal = t_noise;
noise_table.global_spatial   = s_noise;
noise_table.spatial_local = s_loc_noise;
noise_table.spatial_local_frame = s_loc_frame_noise;
noise_table.total = tot_noise;
noise_table.Properties.RowNames = exp_name;
noise_table.delta = 100*(abs(tot_noise - s_loc_frame_noise)./tot_noise);

% Printing the table:
[numRows, numCols] = size(noise_table); % Calculate the number of rows and columns
cellWidth = 100; % Width of each cell of the table
cellHeight = 30; % Height of each cell of the table
tableWidth = cellWidth * numCols+421; % Width of the uitable
tableHeight = cellHeight * numRows-26.5;   % Height of the uitable
f = figure('Position', [100, 100, tableWidth, tableHeight + 60]); % Create a figure with adjusted size
uit = uitable('Parent', f, 'Data', table2cell(noise_table), ...
    'ColumnName', noise_table.Properties.VariableNames, ...
    'RowName', noise_table.Properties.RowNames, ...
    'Position', [20, 20, tableWidth, tableHeight]); % Create a uitable in the figure

%% Calculations of Q5
rec_idx=4;
calc=t_noise(rec_idx,1)^2/mean2(mean(rec,3));
exp_info=GetParamsFromFileName(exp_name{rec_idx});
info = GetRecordInfo(full_path);
gain_db=exp_info.Gain;
n_bits=info.nBits;
max_capacity=10500;%[e]
G_base=2^n_bits*10^(gain_db/20)/max_capacity;

%% Figure of mean(rec,3)
figure()
imagesc(mean(rec,3));
title('mean(rec,3)')
colormap jet
colorbar 
