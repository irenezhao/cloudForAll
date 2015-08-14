function [feature]=getCloudFeature(seg,seg_num,seg_index)
% features are:
% averaged normalized distance between current segment color to the 3 base
% colors
blue =[80; 95; 120];
grey = [130; 130; 130];
white =[255; 255; 255];

b=zeros(1,seg_index);g=zeros(1,seg_index);w=zeros(1,seg_index);
%accumulative distance to blue/grey/white
for i=1:seg_index
    for j=1:seg_num
        for m=1:seg_num
            color = double(squeeze(seg(j,m,:,i)));
            b(i) = b(i)+ sqrt(((color(1)-blue(1))^2 +(color(2)-blue(2))^2 + (color(3)-blue(3))^2))/3;
            g(i) = g(i)+ sqrt(((color(1)-grey(1))^2 +(color(2)-grey(2))^2 + (color(3)-grey(3))^2))/3;
            w(i) = w(i) +sqrt(((color(1)-white(1))^2 +(color(2)-white(2))^2 + (color(3)-white(3))^2))/3;
        end
    end
end

%normalize the distance
feature = [b;g;w];
for i = 1:seg_index
    feature(:,i)=feature(:,i)/norm(feature(:,i));
end
feature = feature';


