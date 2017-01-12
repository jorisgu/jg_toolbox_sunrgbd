function struc2xml(aStruc, dir_path, filename)
% writexml from a struc matlab
if ~exist(dir_path, 'dir')
    mkdir( dir_path);
end
full_path = fullfile(dir_path,filename);
fid=fopen(full_path,'w');
writexml(fid,aStruc,0);
fclose(fid);

function xml = writexml(fid,aStruc,depth)
% this function is extracted from the PASCAL VOC challenge toolbox
fn=fieldnames(aStruc);
for i=1:length(fn)
    f=aStruc.(fn{i});
    if ~isempty(f)
        if isstruct(f)
            for j=1:length(f)            
                fprintf(fid,'%s',repmat(char(9),1,depth));
                fprintf(fid,'<%s>\n',fn{i});
                writexml(fid,aStruc.(fn{i})(j),depth+1);
                fprintf(fid,'%s',repmat(char(9),1,depth));
                fprintf(fid,'</%s>\n',fn{i});
            end
        else
            if ~iscell(f)
                f={f};
            end       
            for j=1:length(f)
                fprintf(fid,'%s',repmat(char(9),1,depth));
                fprintf(fid,'<%s>',fn{i});
                if ischar(f{j})
                    fprintf(fid,'%s',f{j});
                elseif isnumeric(f{j})&&numel(f{j})==1
                    fprintf(fid,'%s',num2str(f{j}));
                else
                    error('unsupported type');
                end
                fprintf(fid,'</%s>\n',fn{i});
            end
        end
    end
end