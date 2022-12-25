function IDs = addnaught(input)
IDs_x = string(input);
for i = 1:length(IDs_x)
    if length(char(IDs_x(i))) == 1
        x = IDs_x(i);
        IDs_x(i) = sprintf("00%s", x);
    elseif length(char(IDs_x(i))) == 2
        x = IDs_x(i);
        IDs_x(i) = sprintf("0%s", x);
    end
    IDs = IDs_x;
end
end
