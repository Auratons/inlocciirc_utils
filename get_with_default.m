function [value] = get_with_default(structure, field_name, default_value)
    % get Equivalent of Python's dict.get(name, default).
    if ~isfield(structure, field_name)
        value = default_value;
    else  % Yummy string field name access syntax:
        value = structure.(field_name);
    end
end
