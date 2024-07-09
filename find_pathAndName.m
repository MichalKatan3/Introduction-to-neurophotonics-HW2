function [path,folderName] = find_pathAndName(path_mother_dir)

cd(path_mother_dir); % Change directory to the folder named by the number

% List the contents of the current directory
contents = dir;
isDir = [contents.isdir]; % Logical array of whether the contents are directories
subfolders = contents(isDir); % Keep only the directories

% Remove '.' and '..' directories
subfolders = subfolders(~ismember({subfolders.name}, {'.', '..'}));

% Check that there is only one subfolder
if length(subfolders) ~= 1
    error('There should be exactly one subfolder inside the directory named by the number.');
end

%Enter the identified subfolder
folderName = subfolders.name;
cd(folderName); % Change directory to the subfolder

%Obtain the path to the subfolder and save the name of the subfolder
path = pwd; % Get the current directory path

end

