function [ x_pix, y_pix ] = calcDrift( input_args )
%CALCDRIFT Summary of this function goes here
%   Detailed explanation goes here

d1 = [0,0,1];
% generate the error that sum up to 1;
bar1 = rand;
bar2 = rand;
bar_low = min(bar1, bar2);
bar_high = max(bar1, bar2);
error_x = bar_low;
error_y = bar_high-bar_low;
error_z = 1 - bar_high;
%error_x + error_y + error_z
% error needs to varies from -0.5% to +0.5%
error = 0.01*[error_x - 0.5, error_y - 0.5, error_z - 0.5];
d2 = d1 + error;

%% parameters
d = 35;
camera_focal = 16;
half_alpha = atan(d/2/camera_focal); % approx 47dgree
cloud_height=1500;
resolution = 3000;
low_res = 600;


zoom_factor = cloud_height/d2(3);
d_x = d2(1)*zoom_factor;
d_y = d2(2)*zoom_factor;

real_x = cloud_height*tan(half_alpha);

x_pix = round(d_x/real_x*resolution/(resolution/low_res));
y_pix = round(d_y/real_x*resolution/(resolution/low_res));

end

