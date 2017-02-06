pathToLabels = '/home/jogue/workspace/datasets/SUNRGBD_pv/data/labels_segmentation_37/';
pathToLabelsD = '/home/jogue/workspace/datasets/SUNRGBD_pv/data/labels_segmentation_37d/';
imagefiles = dir(strcat(pathToLabels,'*.png'));
nfiles = length(imagefiles);    % Number of files found
for ii=1:nfiles
% for ii=1:1
   currentfilename = imagefiles(ii).name;
   currentimage = imread(strcat(pathToLabels,currentfilename));
   newImage = currentimage - 1;
   newImage(currentimage==0)=255;
   imwrite(newImage,strcat(pathToLabelsD,currentfilename));
%    images{ii} = currentimage;
end