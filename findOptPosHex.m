function [ opt_index ] = findOptPosHex( value )
%FINDOPTPOSHEX Summary of this function goes here
%   Detailed explanation goes here

[m ,n] = size(value);
assert( (m == 1) && (n >= 1) );

for i = 1:n
    vv(i) = value(i).v;
end

possible_opt = find(vv == min(vv));

[m_p, n_p] = size(possible_opt);

if (n_p == 1)
    opt_index = possible_opt;
else
    % multiple minimum opts, find the one closest to the center
    % the center position is 1
    
    for i = 1: n_p
        temp_index = possible_opt(i);
        dist(i) = sqrt(abs(value(temp_index).x)^2 + abs(value(temp_index).y)^2);
    end
    
    min_dist_index = find(dist == min(dist)); % if still have multiple min, select the first one
    opt_index = possible_opt(min_dist_index(1));
end


end

