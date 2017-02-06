clc;clear all;close all;

matlab_toolbox = '/home/jogue/workspace/matlab_toolbox/';
dataset_path = '/home/jogue/workspace/datasets/';

% matlab_toolbox = '/c16/THESE.JORIS/matlab_toolbox/';
% dataset_path = '/c16/THESE.JORIS/datasets';


addpath(fullfile(matlab_toolbox,'jg_toolbox_nyud_v2'),fullfile(matlab_toolbox,'colorspace_toolbox'))
sunrgbd_path = fullfile(dataset_path,'SUNRGBD');
data_path = fullfile(dataset_path,'SUNRGBD_pv/data');



nb_image = 10335;
a_extension = 'png';




%% Loop
counter=0;
averageTime = -1;
averageTime_hha = 0;
tStart = tic;


folderInput = 'd_raw_PLDI_16bits';
folderOutput = 'd_raw_PLDI_8bits';
dir_path = fullfile(data_path,folderOutput);
if ~exist(dir_path, 'dir')
    mkdir(dir_path);
end
for ii = 1:nb_image
    % for ii = 1:1

    
    a_name = sprintf('%05d', ii);
    
    disp(strcat('Processing image n°', num2str(ii), '/', num2str(nb_image),' : ',a_name))
    
    imgInPath = fullfile(data_path,folderInput,strcat(a_name,'.png'));
    imgOutPath = fullfile(data_path,folderOutput,strcat(a_name,'.png'));
    
    imIn = imread(imgInPath);
    imOut= uint8(255.0/65535*double(imIn));
    imwrite(imOut,imgOutPath);
    
    tElapsed = toc(tStart);
    tStart = tic;
    averageTime = (averageTime*counter+tElapsed)/(counter+1);
    counter=counter+1;
    estimatedTimeLeft = averageTime*(nb_image-counter);
    hoursLeft = floor(estimatedTimeLeft/3600);
    minutesLeft = floor((estimatedTimeLeft - hoursLeft*3600)/60);
    SecondsLeft = floor(estimatedTimeLeft-3600*hoursLeft-60*minutesLeft);
    disp(strcat('######################### Estimated time left :   ',num2str(hoursLeft),'h ',num2str(minutesLeft),'mn ',num2str(SecondsLeft), 's #########################'))
end


