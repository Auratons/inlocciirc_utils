function [params] = inloc_parse_inputs(varargin)
    parser = inputParser;
    addRequired(parser, 'config');
    addOptional(parser, 'config_section', '');
    parse(parser, varargin{:});

    params = ReadYaml(parser.Results.config);
    if parser.Results.config_section ~= ""
        params = params.(parser.Results.config_section);
    end
end
