% clear all;close all; clc;
% % matlab_toolbox = '/home/jogue/workspace/matlab_toolbox/';
% % dataset_path = '/home/jogue/workspace/datasets/';
% 
% matlab_toolbox = '/c16/THESE.JORIS/matlab_toolbox/';
% dataset_path = '/c16/THESE.JORIS/datasets';
% 
% 
% addpath(fullfile(matlab_toolbox,'jg_toolbox_nyud_v2'),fullfile(matlab_toolbox,'colorspace_toolbox'))
% sunrgbd_path = fullfile(dataset_path,'SUNRGBD');
% data_path = fullfile(dataset_path,'SUNRGBD_pvf/data');
% 
% 
% 
% pathToMat = '/c16/THESE.JORIS/datasets/SUNRGBD/SUNRGBDtoolbox/Metadata/SUNRGBD2Dseg.mat';
% disp('Opening mat file')
% matObj = matfile(pathToMat); 
% 
% % 13 % 15 % 39 % 53 % 65 % 159 % 195 % 265 % 689 % 795 % 2067 % 3445
% nb_image = 10335;
% divider = 3445;
% a_extension = 'png';
for i=1:divider:10335
    disp('##########################################################')
    disp(strcat('Loading first values : [',int2str(i),',',int2str(i+divider-1),']'))
    clear a;
    a = matObj.SUNRGBD2Dseg(1,i:i+divider-1);
    disp('Loaded.')
    disp('Saving seg labels :')
    for j=1:divider
        a_name = sprintf('%05d', i+j-1);
        disp(strcat('Processing image n°', num2str(i+j-1), '/', num2str(nb_image),' : (',a_name,')'))
        a_label_sunrgbd = uint8(a(j).seglabel);
        saveIt( a_label_sunrgbd, data_path, 'labels_segmentation_37', a_name, a_extension)
        
    end
end