clc;clear all;close all;

matlab_toolbox = '/home/jogue/workspace/matlab_toolbox/';
dataset_path = '/home/jogue/workspace/datasets/';

% matlab_toolbox = '/c16/THESE.JORIS/matlab_toolbox/';
% dataset_path = '/c16/THESE.JORIS/datasets';


addpath(fullfile(matlab_toolbox,'jg_toolbox_nyud_v2'),fullfile(matlab_toolbox,'colorspace_toolbox'))
sunrgbd_path = fullfile(dataset_path,'SUNRGBD');
data_path = fullfile(dataset_path,'SUNRGBD_pvf/data');

% sunrgbd_target_path = '/data/workspace/datasets/SUNRGBD_pv/data';
% sunrgbd_path = '/data/workspace/datasets/SUNRGBD/';
addpath(genpath(fullfile(sunrgbd_path, 'SUNRGBDtoolbox')));



% load(fullfile(sunrgbd_path, 'SUNRGBDtoolbox/Metadata/', 'SUNRGBDMeta.mat'))
load('./SUNRGBDMeta2DBB_v2.mat');


nb_image = length(SUNRGBDMeta2DBB);
% nb_image = 1
a_extension = 'png';


%% Loop
counter=0;
averageTime = -1;
tStart = tic;


map_seqences_indices = containers.Map;
map_seqences_imgnames = containers.Map;
counterNYUDV2 = 0;

for ii = 1:nb_image
% for ii = 2200:2200
    
    
    data = SUNRGBDMeta2DBB(ii);
    
    %     a_name = data.rgbname(1:end-4);
    a_name = sprintf('%05d', ii);
    
    disp(strcat('Processing image n°', num2str(ii), '/', num2str(nb_image),' : ',a_name,'[',data.sensorType,']'))
    

    
    folders = strsplit(data.sequenceName,'/');
    sensorType = data.sensorType;
    sequence = folders{3};
    
    
    if ~map_seqences_indices.isKey(strcat(sensorType,'_',sequence))
        map_seqences_indices(strcat(sensorType,'_',sequence))=[];
    end
    map_seqences_indices(strcat(sensorType,'_',sequence))=[map_seqences_indices(strcat(sensorType,'_',sequence)) ii]; 
    
    if ~map_seqences_imgnames.isKey(strcat(sensorType,'_',sequence))
        map_seqences_imgnames(strcat(sensorType,'_',sequence))=[];
    end
    map_seqences_imgnames(strcat(sensorType,'_',sequence))=[map_seqences_imgnames(strcat(sensorType,'_',sequence)) str2num(data.rgbname(4:end-4))];
    
%     if strcmp(sequence,'NYUdata')
%         counterNYUDV2=counterNYUDV2+1;
%     end
%     set_destination_folder = fullfile(data_path,'sets',sequence);
%     set_file_name = fullfile(set_destination_folder,strcat(a_name,'.txt'))
%     if ~exist(set_destination_folder, 'dir')
%         mkdir(set_destination_folder);
%     end
    
    
    
    
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
% disp(strcat('NYUdata nb =',num2str(counterNYUDV2)))
close all

% objectif : from i in 1:1449 get 
kv1_NYUdata_indices = map_seqences_indices('kv1_NYUdata');
kv1_NYUdata_imgnames = map_seqences_imgnames('kv1_NYUdata');
nyudv2_subset = [];
for i = 1:1449
    nyudv2_indice = i;
    positionInList = find(kv1_NYUdata_imgnames==nyudv2_indice);
    correspondingIndiceInPVF = kv1_NYUdata_indices(positionInList);
    nyudv2_subset = [nyudv2_subset correspondingIndiceInPVF];
    disp(strcat(int2str(nyudv2_indice),'->',int2str(positionInList),'->',int2str(correspondingIndiceInPVF)));
end



% GuptaSetsPath = '/c16/THESE.JORIS/matlab_toolbox/rcnn-depth/eccv14-data/benchmarkData/metadata';
% GuptaSetsPath = '/home/jogue/workspace/rcnn-depth/eccv14-data/benchmarkData/metadata';
% load(fullfile(GuptaSetsPath,'eccv14-splits.mat'))
% sets_path = fullfile(data_path ,'sets','nyudv2_gupta');
% if ~exist(sets_path, 'dir')
%     mkdir(sets_path);
% end
% 
% indice_Test = test - 5000;
% indice_Val = val - 5000;
% indice_TrainOnly = train - 5000;
% 
% fileID = fopen(fullfile(sets_path,'testGupta.txt'),'w');
% for ii = 1:numel(indice_Test)
%     num_image = nyudv2_subset(indice_Test(ii));
%     fprintf(fileID,'%04d\n', num_image);
% end
% fclose(fileID);
% 
% fileID = fopen(fullfile(sets_path,'valGupta.txt'),'w');
% for ii = 1:numel(indice_Val)
%     num_image = nyudv2_subset(indice_Val(ii));
%     fprintf(fileID,'%04d\n', num_image);
% end
% fclose(fileID);
% 
% fileID = fopen(fullfile(sets_path,'trainGupta.txt'),'w');
% for ii = 1:numel(indice_TrainOnly)
%     num_image = nyudv2_subset(indice_TrainOnly(ii));
%     fprintf(fileID,'%04d\n', num_image);
% end
% fclose(fileID);
% 
% fileID = fopen(fullfile(sets_path,'trainvalGupta.txt'),'w');
% for ii = 1:numel(indice_TrainOnly)
%     num_image = nyudv2_subset(indice_TrainOnly(ii));
%     fprintf(fileID,'%04d\n', num_image);
% end
% for ii = 1:numel(indice_Val)
%     num_image = nyudv2_subset(indice_Val(ii));
%     fprintf(fileID,'%04d\n', num_image);
% end
% fclose(fileID);
















