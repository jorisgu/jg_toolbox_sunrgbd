clc;clear all;close all;

matlab_toolbox = '/home/jogue/workspace/matlab_toolbox/';
dataset_path = '/home/jogue/workspace/datasets/';

addpath(fullfile(matlab_toolbox,'jg_toolbox_nyud_v2'),fullfile(matlab_toolbox,'colorspace_toolbox'))


oneraroom_path = fullfile(dataset_path,'ONERA.ROOM.extraits');


data_path = fullfile(dataset_path,'ONERA.ROOM.extraits/kv1/data/kv1/');
data_path_spreadout = fullfile(dataset_path,'ONERA.ROOM.extraits/data_spreadout/');

addpath(genpath(fullfile(oneraroom_path, 'SUNRGBDtoolbox')));


a_extension = 'png';


%% HHA dependencies :
addpath('/home/jogue/workspace/rcnn-depth/eccv14-code/rgbdutils')
addpath('/home/jogue/workspace/rcnn-depth/eccv14-code/mcg/depth_features')

%% depth_encodings
addpath(fullfile(matlab_toolbox,'jg_toolbox_sunrgbd','depth_encodings'))

% subfolder = 'Annotations_37';
% dir_path = fullfile(data_path,subfolder);
% if ~exist(dir_path, 'dir')
%     mkdir(dir_path);
% end





%% Loop
counter=0;
averageTime = -1;
tStart = tic;
nb_image = 11;
for ii=1:nb_image
    

    depthpath = fullfile(data_path,'depth',strcat(int2str(ii),'.png'));
    rgbpath = fullfile(data_path,'rgb',strcat(int2str(ii),'.jpg'));
    
    
    %     a_name = data.rgbname(1:end-4);
    a_name = sprintf('%05d', ii);
    
    disp(strcat('Processing image n°', num2str(ii), '/', num2str(nb_image),' : ',a_name))
    
    a_rgb = imread(rgbpath);
    a_d_raw = imread(depthpath);
    a_d_raw = uint16(65535/255*double(a_d_raw));
    %a_d_raw(a_d_raw > 8000)=8; % a_d_raw : depth info in mm on uint16
    
    %% rgb
        saveIt( a_rgb, data_path, 'rgb_i_100_8bits', a_name, a_extension);
        disp('rgb_i_100_8bits')
        for jj = 90:-10:10
            saveIt( changeLuminosity(a_rgb,jj), data_path, strcat('rgb_i_',int2str(jj),'_8bits'), a_name, a_extension);
            disp(strcat('rgb_i_',int2str(jj),'_8bits'))
        end
    
    %% depth
        saveAllDepths(a_d_raw, data_path, a_name, a_extension);
        a_d_raw_spreadout = uint16(8.192*a_d_raw); % 8000->65535
        saveAllDepths(a_d_raw_spreadout, data_path_spreadout, a_name, a_extension);
    
    %     %% Intrinsics
    intrinsic_source = fullfile(oneraroom_path,'data','intrinsic_kv1.txt');
    

    
    %% HHA
    makeHHA(a_d_raw, intrinsic_source, data_path, a_name, a_extension);
    
    %% DHA
    DHA(a_d_raw, intrinsic_source, data_path, a_name, a_extension);
    %% DEA
    DEA(a_d_raw, intrinsic_source, data_path, a_name, a_extension);
    %% HES
    HES(a_d_raw, data_path, a_name, a_extension);
    
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