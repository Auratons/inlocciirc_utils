function [new_path] = inloc_add_abs_fn_path(varargin)
    % addAbsFnPath Adds valid absolute OS filesystem path of
    % specified function name to MATLAB path, if not already present.
    % Relies on the file structure of this repository.

    % Get absolute path to folder containing this very file.
    [filepath, ~, ~] = fileparts(mfilename('fullpath'));
    % Addpath does not create duplicities.
    addpath(fullfile(filepath, '..', varargin{:}));
    new_path = path;
end
