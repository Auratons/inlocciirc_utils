function name = filename(pth)
    [~, name, ext] = fileparts(pth);
    name = [name, ext];
end
