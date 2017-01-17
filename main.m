clc;clear all;close all;
addpath('/c16/THESE.JORIS/matlab_toolbox/jg_toolbox_nyud_v2','/c16/THESE.JORIS/matlab_toolbox/colorspace_toolbox')
sunrgbd_path = '/c16/THESE.JORIS/datasets/SUNRGBD/';
data_path = '/c16/THESE.JORIS/datasets/SUNRGBD_pv/data';

% sunrgbd_target_path = '/data/workspace/datasets/SUNRGBD_pv/data';
% sunrgbd_path = '/data/workspace/datasets/SUNRGBD/';
addpath(genpath(fullfile(sunrgbd_path, 'SUNRGBDtoolbox')));
% load(fullfile(sunrgbd_path, 'SUNRGBDtoolbox/Metadata/', 'SUNRGBDMeta.mat'))
load('./SUNRGBDMeta2DBB_v2.mat');


nb_image = length(SUNRGBDMeta2DBB);
a_extension = 'png';





subfolder = 'Annotations_37';
dir_path = fullfile(data_path,subfolder);
if ~exist(dir_path, 'dir')
    mkdir(dir_path);
end





%% Loop
for ii = 1:nb_image
% for ii = 10000:10010
    
    
    data = SUNRGBDMeta2DBB(ii);
    depthpath = fullfile(sunrgbd_path,'data',data.depthpath(25:end));
    data.depthpath = depthpath;
    rgbpath = fullfile(sunrgbd_path,'data',data.rgbpath(25:end));
    data.rgbpath = rgbpath;
    
    %     a_name = data.rgbname(1:end-4);
    a_name = sprintf('%05d', ii);
    
    disp(strcat('Processing image n°', num2str(ii), '/', num2str(nb_image),' : ',a_name,'[',data.sensorType,']'))
    
    a_rgb = imread(rgbpath);
    a_d_raw = imread(depthpath);
    
    
    %% rgb
    %     saveIt( a_rgb, data_path, 'rgb_3x8bits', a_name, a_extension);
    saveIt( a_rgb, data_path, 'rgb_i_100_8bits', a_name, a_extension);
    disp('rgb_i_100_8bits')
    for jj = 90:-10:10
        saveIt( changeLuminosity(a_rgb,jj), data_path, strcat('rgb_i_',int2str(jj),'_8bits'), a_name, a_extension);
        disp(strcat('rgb_i_',int2str(jj),'_8bits'))
    end
    
    %% depth
    %     subfolder = 'depth_16bits';
    %     dir_path = fullfile(data_path,subfolder);
    %     if ~exist(dir_path, 'dir')
    %         mkdir(dir_path);
    %     end
    %     img_path = fullfile(dir_path,strcat(a_name,'.',a_extension));
    %     imwrite(a_d_raw, img_path);
    saveAllDepths(a_d_raw, data_path, a_name, a_extension);
    
    
    %% Entropy Gray HistogramEq
    a_EGH=zeros(size(a_d_raw,1),size(a_d_raw,2),3,'uint8');
    E = entropyfilt(a_d_raw);
    E = uint8(255.0*E/max(E(:)));
    G = rgb2gray(a_rgb);
    H = uint8(255.0/65535.0*histeq(a_d_raw));
    a_EGH(:,:,1)=E;
    a_EGH(:,:,2)=G;
    a_EGH(:,:,3)=H;
    saveIt( a_EGH, data_path, 'rgbd_egh_8bits', a_name, a_extension);
    disp('rgbd_egh_8bits')
    
    %% rgbd tiff
    %     a_RGBD=zeros(size(a_d_raw,1),size(a_d_raw,2),4,'uint16');
    %     a_RGBD(:,:,1:3)=uint16(65535.0/255.0*a_rgb);
    %     a_RGBD(:,:,4)=a_d_raw;
    %     saveIt( a_RGBD, data_path, 'rgbd_range01', a_name, 'tif');
    %     disp('rgbd_range01')
    
    
    %% annotations
    mystruct.annotation.folder = 'data';
    mystruct.annotation.filename = data.depthname;
    mystruct.annotation.source.database = 'The SUNRGBD database';
    mystruct.annotation.source.sensorType = data.sensorType;
    mystruct.annotation.source.image = 'Princeton';
    mystruct.annotation.owner = 'B. Zhou et al';
    mystruct.annotation.size.width = size(a_rgb,2);
    mystruct.annotation.size.height = size(a_rgb,1);
    mystruct.annotation.size.depth = size(a_rgb,3);
    mystruct.annotation.segmented = 0;
    
    for k=1:length(data.groundtruth2DBB)
        mystruct.annotation.object(k).name = data.groundtruth2DBB(k).classname;
        mystruct.annotation.object(k).pose = 'unknown';
        mystruct.annotation.object(k).truncated = -1;
        mystruct.annotation.object(k).difficult = 0;
        mystruct.annotation.object(k).bndbox.xmin = max(1,floor(data.groundtruth2DBB(k).gtBb2D(1)));
        mystruct.annotation.object(k).bndbox.ymin = max(1,floor(data.groundtruth2DBB(k).gtBb2D(2)));
        mystruct.annotation.object(k).bndbox.xmax = min(size(a_rgb,2),floor(data.groundtruth2DBB(k).gtBb2D(1)+data.groundtruth2DBB(k).gtBb2D(3)-1));
        mystruct.annotation.object(k).bndbox.ymax = min(size(a_rgb,1),floor(data.groundtruth2DBB(k).gtBb2D(2)+data.groundtruth2DBB(k).gtBb2D(4)-1));
    end
    
    xml_path = fullfile(data_path,'Annotations_37');
    xml_filename = strcat(a_name,'.xml');
    struc2xml(mystruct, xml_path, xml_filename)
    disp('Annotations_37')
    
    %% Intrinsics
    %     intrinsic_source = fullfile(sunrgbd_path,'data',data.sequenceName(9:end),'intrinsics.txt');
    %     intrinsic_destination_folder = fullfile(data_path,'intrinsics');
    %     if ~exist(intrinsic_destination_folder, 'dir')
    %         mkdir(intrinsic_destination_folder);
    %     end
    %     copyfile(intrinsic_source,fullfile(intrinsic_destination_folder,strcat(a_name,'.txt')))
end