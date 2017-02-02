function I = makeHHA(a_d_raw, intrinsic_source, data_path, name, ext)
% a_d_raw : depth in mm

% get K
fID = fopen(intrinsic_source,'r');
K = reshape(fscanf(fID,'%f'),[3,3])';
fclose(fID);


D = double(a_d_raw)./1000; %depth in meters
missingMask = a_d_raw == 0;
[pc, N, yDir, h, ~, ~] = processDepthImage(D*100, missingMask, K); % depth in cm
angl = acosd(min(1,max(-1,sum(bsxfun(@times, N, reshape(yDir, 1, 1, 3)), 3))));

% Making the minimum depth to be 100, to prevent large values for disparity!!!
pc(:,:,3) = max(pc(:,:,3), 100);
I(:,:,1) = 31000./pc(:,:,3);
I(:,:,2) = h;
I(:,:,3) = (angl+128-90); %Keeping some slack
I = uint8(I);

subfolder = 'd_raw_HHA_8bits';
dir_path = fullfile(data_path,subfolder);
if ~exist(dir_path, 'dir')
    mkdir(dir_path);
end
img_path = fullfile(dir_path,strcat(name,'.',ext));
imwrite(I, img_path);
end
