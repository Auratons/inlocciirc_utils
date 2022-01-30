function create_parent_folder(filename)
    [parent_folder, ~, ~] = fileparts(filename);
    if exist(parent_folder, 'dir') ~= 7
        mkdir(parent_folder);
    end
end
