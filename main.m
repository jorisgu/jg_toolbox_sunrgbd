clc;clear all;
% sunrgbd_path = '/c16/THESE.JORIS/datasets/SUNRGBD/';
% sunrgbd_target_path = '/c16/THESE.JORIS/datasets/SUNRGBD_pv/data';

sunrgbd_target_path = '/data/workspace/datasets/SUNRGBD_pv/data';
sunrgbd_path = '/data/workspace/datasets/SUNRGBD/';
addpath(genpath(fullfile(sunrgbd_path, 'SUNRGBDtoolbox')));
% load(fullfile(sunrgbd_path, 'SUNRGBDtoolbox/Metadata/', 'SUNRGBDMeta.mat'))
load(fullfile(sunrgbd_path, 'jg_toolbox_sunrgbd/', 'SUNRGBDMeta2DBB_v2.mat'))


nb_image = length(SUNRGBDMeta2DBB);

%% Loop
% for ii = 1:nb_image
for ii = 1:1
    
    disp(strcat('Processing image n°', num2str(ii), '/', num2str(nb_image)))
    data = SUNRGBDMeta2DBB(ii);
    depthpath = fullfile(sunrgbd_path,'data',data.depthpath(25:end));
    data.depthpath = depthpath;
    rgbpath = fullfile(sunrgbd_path,'data',data.rgbpath(25:end));
    data.rgbpath = rgbpath;
    
    a_rgb = imread(rgbpath);
    a_d_raw = imread(depthpath);
    
    %% copying files
    %     move rgb image to data/rgb_raw_i_100
    %     move rgb image to data/rgb
    %% annotations
    
    
    
    mystruct.annotation.folder = 'data';
    mystruct.annotation.filename = data.rgbname(1:end-4); % without extension
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
    
    xml_path = fullfile(sunrgbd_target_path,'Annotations_37');
    xml_filename = strcat(mystruct.annotation.filename,'.xml');
    struc2xml(mystruct, xml_path, xml_filename)
    
end