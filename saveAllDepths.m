function newImage8bits = saveAllDepths(img, pathDir, name, ext)

if isa(img,'uint16')
    newImage8bits = uint8(255.0 / 65535.0 * img );
    newImage16bits = img;
elseif isa(img,'uint8')
    newImage8bits = img;
    newImage16bits = uint16(65535.0 / 255.0 * img);
else
    disp('Check for format type : uint16 or uint8 accepted only');
end

% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%% normal
subfolder = 'd_raw_normal_8bits';
dir_path = fullfile(pathDir,subfolder);
if ~exist(dir_path, 'dir')
    mkdir(dir_path);
end
img_path = fullfile(dir_path,strcat(name,'.',ext));
imwrite(newImage8bits, img_path);
disp('d_raw_normal_8bits')

subfolder = 'd_raw_normal_16bits';
dir_path = fullfile(pathDir,subfolder);
if ~exist(dir_path, 'dir')
    mkdir(dir_path);
end
img_path = fullfile(dir_path,strcat(name,'.',ext));
imwrite(newImage16bits, img_path);
disp('d_raw_normal_16bits')
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%% jet
subfolder = 'd_raw_jet_8bits';
dir_path = fullfile(pathDir,subfolder);
if ~exist(dir_path, 'dir')
    mkdir(dir_path);
end
img_path = fullfile(dir_path,strcat(name,'.',ext));
imwrite(newImage8bits, jet, img_path);
disp('d_raw_jet_8bits')

% subfolder = 'd_raw_jet_16bits';
% dir_path = fullfile(pathDir,subfolder);
% if ~exist(dir_path, 'dir')
%     mkdir(dir_path);
% end
% img_path = fullfile(dir_path,strcat(name,'.',ext));
% imwrite(newImage16bits, jet, img_path);
% disp('d_raw_jet_16bits')

% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%% cubehelix
Map_CUBEHELIX = colormap(CubeHelix(256,1,-1.5,2,1.0));
subfolder = 'd_raw_cubehelix_8bits';
dir_path = fullfile(pathDir,subfolder);
if ~exist(dir_path, 'dir')
    mkdir(dir_path);
end
img_path = fullfile(dir_path,strcat(name,'.',ext));
imwrite(newImage8bits, Map_CUBEHELIX, img_path);
disp('d_raw_cubehelix_8bits')

% subfolder = 'd_raw_cubehelix_16bits';
% dir_path = fullfile(pathDir,subfolder);
% if ~exist(dir_path, 'dir')
%     mkdir(dir_path);
% end
% img_path = fullfile(dir_path,strcat(name,'.',ext));
% imwrite(newImage16bits, Map_CUBEHELIX, img_path);
% disp('d_raw_cubehelix_16bits')

% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%% histeqRandom
newImageWOartifact8bits = newImage8bits;
random_image8bits = uint8(255.0*rand([size(newImage8bits,1),size(newImage8bits,2)]));
newImageWOartifact8bits(newImage8bits==0) = random_image8bits(newImage8bits==0);
newImageWOartifactHisteq8bits = histeq(newImageWOartifact8bits);
subfolder = 'd_raw_histeqRandom_8bits';
dir_path = fullfile(pathDir,subfolder);
if ~exist(dir_path, 'dir')
    mkdir(dir_path);
end
img_path = fullfile(dir_path,strcat(name,'.',ext));
imwrite(newImageWOartifactHisteq8bits, img_path);
disp('d_raw_histeqRandom_8bits')

subfolder = 'd_raw_histeqRandom_jet_8bits';
dir_path = fullfile(pathDir,subfolder);
if ~exist(dir_path, 'dir')
    mkdir(dir_path);
end
img_path = fullfile(dir_path,strcat(name,'.',ext));
imwrite(newImageWOartifactHisteq8bits, jet, img_path);
disp('d_raw_histeqRandom_jet_8bits')

subfolder = 'd_raw_histeqRandom_cubehelix_8bits';
dir_path = fullfile(pathDir,subfolder);
if ~exist(dir_path, 'dir')
    mkdir(dir_path);
end
img_path = fullfile(dir_path,strcat(name,'.',ext));
imwrite(newImageWOartifactHisteq8bits, Map_CUBEHELIX, img_path);
disp('d_raw_histeqRandom_cubehelix_8bits')

newImageWOartifact16bits = newImage16bits;
random_image16bits = uint16(65535.0*rand([size(newImage16bits,1),size(newImage16bits,2)]));
newImageWOartifact16bits(newImage16bits==0) = random_image16bits(newImage16bits==0);
newImageWOartifactHisteq16bits = histeq(newImageWOartifact16bits);
subfolder = 'd_raw_histeqRandom_16bits';
dir_path = fullfile(pathDir,subfolder);
if ~exist(dir_path, 'dir')
    mkdir(dir_path);
end
img_path = fullfile(dir_path,strcat(name,'.',ext));
imwrite(newImageWOartifactHisteq16bits, img_path);
disp('d_raw_histeqRandom_16bits')

% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%% histeqBack
newImageWOartifact8bits = newImage8bits;
newImageWOartifact8bits(newImage8bits==0) = 255;
newImageWOartifactHisteq8bits = histeq(newImageWOartifact8bits);
subfolder = 'd_raw_histeqBack_8bits';
dir_path = fullfile(pathDir,subfolder);
if ~exist(dir_path, 'dir')
    mkdir(dir_path);
end
img_path = fullfile(dir_path,strcat(name,'.',ext));
imwrite(newImageWOartifactHisteq8bits, img_path);
disp('d_raw_histeqBack_8bits')

subfolder = 'd_raw_histeqBack_jet_8bits';
dir_path = fullfile(pathDir,subfolder);
if ~exist(dir_path, 'dir')
    mkdir(dir_path);
end
img_path = fullfile(dir_path,strcat(name,'.',ext));
imwrite(newImageWOartifactHisteq8bits, jet, img_path);
disp('d_raw_histeqBack_jet_8bits')

subfolder = 'd_raw_histeqBack_cubehelix_8bits';
dir_path = fullfile(pathDir,subfolder);
if ~exist(dir_path, 'dir')
    mkdir(dir_path);
end
img_path = fullfile(dir_path,strcat(name,'.',ext));
imwrite(newImageWOartifactHisteq8bits, Map_CUBEHELIX, img_path);
disp('d_raw_histeqBack_cubehelix_8bits')


newImageWOartifact16bits = newImage16bits;
newImageWOartifact16bits(newImage16bits==0) = 65535;
newImageWOartifactHisteq16bits = histeq(newImageWOartifact16bits);
subfolder = 'd_raw_histeqBack_16bits';
dir_path = fullfile(pathDir,subfolder);
if ~exist(dir_path, 'dir')
    mkdir(dir_path);
end
img_path = fullfile(dir_path,strcat(name,'.',ext));
imwrite(newImageWOartifactHisteq16bits, img_path);
disp('d_raw_histeqBack_16bits')

% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%% histeqFront
newImageWOartifact8bits = newImage8bits;
newImageWOartifact8bits(newImage8bits==0) = 0;
newImageWOartifactHisteq8bits = histeq(newImageWOartifact8bits);
subfolder = 'd_raw_histeqFront_8bits';
dir_path = fullfile(pathDir,subfolder);
if ~exist(dir_path, 'dir')
    mkdir(dir_path);
end
img_path = fullfile(dir_path,strcat(name,'.',ext));
imwrite(newImageWOartifactHisteq8bits, img_path);
disp('d_raw_histeqFront_8bits')

subfolder = 'd_raw_histeqFront_jet_8bits';
dir_path = fullfile(pathDir,subfolder);
if ~exist(dir_path, 'dir')
    mkdir(dir_path);
end
img_path = fullfile(dir_path,strcat(name,'.',ext));
imwrite(newImageWOartifactHisteq8bits, jet, img_path);
disp('d_raw_histeqFront_jet_8bits')

subfolder = 'd_raw_histeqFront_cubehelix_8bits';
dir_path = fullfile(pathDir,subfolder);
if ~exist(dir_path, 'dir')
    mkdir(dir_path);
end
img_path = fullfile(dir_path,strcat(name,'.',ext));
imwrite(newImageWOartifactHisteq8bits, Map_CUBEHELIX, img_path);
disp('d_raw_histeqFront_cubehelix_8bits')


newImageWOartifact16bits = newImage16bits;
newImageWOartifact16bits(newImage16bits==0) = 0;
newImageWOartifactHisteq16bits = histeq(newImageWOartifact16bits);
subfolder = 'd_raw_histeqFront_16bits';
dir_path = fullfile(pathDir,subfolder);
if ~exist(dir_path, 'dir')
    mkdir(dir_path);
end
img_path = fullfile(dir_path,strcat(name,'.',ext));
imwrite(newImageWOartifactHisteq16bits, img_path);
disp('d_raw_histeqFront_16bits')


end


