function [params] = inloc_parse_inputs(varargin)
    parser = inputParser;
    addRequired(parser, 'params_file');
    addOptional(parser, 'experiment_name', '');
    parse(parser, varargin{:});

    params = ReadYaml(parser.Results.params_file);
    if parser.Results.experiment_name ~= ""
        params = params.(parser.Results.experiment_name);
    end
end
