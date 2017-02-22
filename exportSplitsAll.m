clc;clear all;close all;

% matlab_toolbox = '/home/jogue/workspace/matlab_toolbox/';
% dataset_path = '/home/jogue/workspace/datasets/';

matlab_toolbox = '/c16/THESE.JORIS/matlab_toolbox/';
dataset_path = '/c16/THESE.JORIS/datasets';


addpath(fullfile(matlab_toolbox,'jg_toolbox_nyud_v2'),fullfile(matlab_toolbox,'colorspace_toolbox'))
sunrgbd_path = fullfile(dataset_path,'SUNRGBD');
data_path = fullfile(dataset_path,'SUNRGBD_pv/data');
data_path_spreadout = fullfile(dataset_path,'SUNRGBD_pv/data_spreadout');

% sunrgbd_target_path = '/data/workspace/datasets/SUNRGBD_pv/data';
% sunrgbd_path = '/data/workspace/datasets/SUNRGBD/';
addpath(genpath(fullfile(sunrgbd_path, 'SUNRGBDtoolbox')));



% load(fullfile(sunrgbd_path, 'SUNRGBDtoolbox/Metadata/', 'SUNRGBDMeta.mat'))
load('./SUNRGBDMeta2DBB_v2.mat');
load('./allsplit.mat');


nb_image = length(SUNRGBDMeta2DBB);
a_extension = 'png';




%% Loop
counter=0;
averageTime = -1;
averageTime_hha = 0;
tStart = tic;
nb_image = 10335;


split=zeros(10335,1,'int8');

train_split = cell(5285,1);
test_split = cell(5050,1);

train_id=0;
test_id=0;
for ii = 1:nb_image
    
    data = SUNRGBDMeta2DBB(ii);
    
    %     a_name = data.rgbname(1:end-4);
    a_name = sprintf('%05d', ii);
    
    disp(strcat('Processing image n°', num2str(ii), '/', num2str(nb_image),' : ',a_name,'[',data.sensorType,']'))
    
    if isempty(find(cellfun('length',regexp(alltrain,SUNRGBDMeta2DBB(ii).sequenceName)) == 1,1))
        test_id=test_id+1;
        test_split{test_id}=a_name;
    else
        train_id=train_id+1;
        train_split{train_id}=a_name;        
    end
    
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



close all


dlmcell('/c16/THESE.JORIS/datasets/SUNRGBD_pv/data/sets/sunrgbd/train.txt',train_split)
dlmcell('/c16/THESE.JORIS/datasets/SUNRGBD_pv/data/sets/sunrgbd/test.txt',test_split)