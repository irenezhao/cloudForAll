function [] = ImagePlot( image, seg_num, x_vector, y_vector )
%IMAGEPLOT Summary of this function goes here
%   Detailed explanation goes here
% image is the picture that you want to show
% seg_num is the block size of the image, here due to the
% image size is 360*600 we can use seg_num = 20, 30, 40, 60, etc.
% x_vector and y_vector are the x and y of the motion vector

rgb = image;
a = x_vector;
b = y_vector;
% subplot(1,2,1);
imshow(rgb)

hold on;

M = size(rgb,1);
N = size(rgb,2);

for k = 1:seg_num:M
    x = [1 N];
    y = [k k];
    plot(x,y,'Color','w','LineStyle','-');
    plot(x,y,'Color','k','LineStyle',':');
end

for k = 1:seg_num:N
    x = [k k];
    y = [1 M];
    plot(x,y,'Color','w','LineStyle','-');
    plot(x,y,'Color','k','LineStyle',':');
end

hold on;


[X, Y] = meshgrid(seg_num/2:seg_num:(M),seg_num/2:seg_num:(N));
X = X';
Y = Y';
a = a;
b = b;

quiver(Y,X,b,a,'r');

% colormap hsv;
hold off;


end

