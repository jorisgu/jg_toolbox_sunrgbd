function [I, H, E, S] = HES(a_d_raw, data_path, name, ext)
% a_d_raw : depth in mm

% HES : Histeq / entropy / stdfilt

a_d_raw=double(a_d_raw);

H = uint8(255*histeq(a_d_raw));
H = uint8(255.0/8000*a_d_raw);

E = uint8(255*(entropyfilt(a_d_raw)));
% E = uint8(255.0/8000*E);

S = stdfilt(a_d_raw);
S = uint8(255./max(S(:))*S);
% S = a_d_raw;
% S = uint8(255.0/8000*S);


    
I(:,:,1) = H;
I(:,:,2) = E;
I(:,:,3) = S;

subfolder = 'd_raw_HES_8bits';
dir_path = fullfile(data_path,subfolder);
if ~exist(dir_path, 'dir')
    mkdir(dir_path);
end
img_path = fullfile(dir_path,strcat(name,'.',ext));
imwrite(I, img_path);
disp(subfolder)
end
