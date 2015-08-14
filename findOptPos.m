function [ opt_x, opt_y ] = findOpt( v )
%FINDOPT Summary of this function goes here
%   Detailed explanation goes here
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%  find the minimun value in matrix value %%% 
%%%%%%  that is closed to th center %%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%% find the center %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[m, n] = size(v);
center_m = -1;
center_n = -1;
if ( mod(m,2) == 0) % even number
    center_m = floor(m/2);
else
    center_m = floor(m/2) + 1;
end

if ( mod(n,2) == 0) % even number
    center_n = floor(n/2);
else
    center_n = floor(n/2) + 1;
end

%%%%% find all possible opts %%%%%
[cx,cy] = find(v == min(min(v)));

%%%%%% compute dist from each opt to center %%%%%%
num_opt_pair = size(cx,1);
dist = [];
for i = 1: num_opt_pair
    this_m = cx(i);
    this_n = cy(i);
    %%% using Manhatten dist to save computation %%
    %%% using sqrt instead, might confuse since 4,0 and 3,1 have the same
    %%% dist in Manhatten
    temp_dist = sqrt(abs(this_m - center_m)^2 + abs(this_n - center_n)^2);
    dist(i) = temp_dist;
end

%%%%% find the minimum of disp %%%%%%%%
opt_pos = find(dist == min(dist));
opt_x = cx(opt_pos(1));
opt_y = cy(opt_pos(1));




end

