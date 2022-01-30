function [new_path] = add_abs_fn_path(varargin)
    % addAbsFnPath Adds valid absolute OS filesystem path of
    % specified function name to MATLAB path, if not already present.
    % Relies on the file structure of this repository.

    % Get absolute path to folder containing this very file.
    [filepath, ~, ~] = fileparts(mfilename('fullpath'));
    % OS independent path creation.
    fn_path = fullfile(filepath, '..', '..', varargin{:});
    % ispc returns true on Windows which is case insensitive
    if ~contains( ...
        [pathsep, path, pathsep], ...
        [pathsep, fn_path, pathsep], ...
        'IgnoreCase', ...
        ispc)
        addpath(fn_path)
    end
    new_path = path;
end
