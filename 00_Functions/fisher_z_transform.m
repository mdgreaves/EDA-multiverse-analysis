function [z_val, ci] = fisher_z_transform(stat, n, type)

switch type
    case 'r'
        z_val = 1/2*log((1+stat)/(1-stat));
        stderr = 1/sqrt(n-3);
        ci = 1.96 * stderr;
    case 't'
        r_val = sign(stat)*(sqrt((stat^2)/((stat^2) + n-2)));
        z_val = 1/2*log((1+r_val)/(1-r_val));
        stderr = 1/sqrt(n-3);
        ci = 1.96 * stderr;
end




