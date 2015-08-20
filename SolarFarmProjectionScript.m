%% Step 1: initialize solar farm and 2 cameras
camera1 = [0,0,0];%unit:mm
camera2 = [50000,0,0];
k=0;m=0;
for i=1:100
    m=m+1;
    for j=1:100
        k=k+1;
        cell(m,k,:) = [i*150,j*150,0];
    end
    k=0;
end
s0 = [0, 0, 0];
s1 = [500000,0,0];
s2 = [500000,-400000,0];
s3 = [0,-400000,0];
%% Step 2: mixed rbg picture
pc1_1 = imread('f1_1.jpg');
pc2_1 = imread('f2_1.jpg');
pc1_2 = imread('f1_2.jpg');
[sun1,cloud1] = FigureCenterDetect(pc1_1);
[sun2,cloud2] = FigureCenterDetect(pc2_1);
f_c=round(cloud2(1)-cloud1(1));
f_r=round(cloud2(2)-cloud1(2));
pic = Mix2Pictures(pc1_1,pc2_1,f_c,f_r);
%imshow(pic);

%% Step 3: calculate theta:the angle between photo side and the solar farm side
%%                     rou:mm/pixel
%based on f_c<0,f_r<0
sun2 = [sun2(1)-f_c,sun2(2)-f_r];
c1c2_p = sun2-sun1;
c1c2 = camera2-camera1;

syms rou theta real
[rou,theta]=solve(c1c2_p(1)*rou*cos(theta)-c1c2_p(2)*rou*sin(theta)-c1c2(1)...
   ,c1c2_p(1)*rou*sin(theta)+c1c2_p(2)*rou*cos(theta)-c1c2(2),'rou','theta');

rou = double(rou);
rou = rou(rou>=0);

theta = double(theta);
theta = theta(theta>=0);

%% Step 3: use 2 photos taken by camera1 to calculate motion vectors
seg_num = 40;
likelyhood_thres = 10;
blur_flag = false;
blur_index = 6;
p1 = rgb2gray(pc1_1);
p2 = rgb2gray(pc1_2);
[hex_r, hex_c] = HexMovDetector(p1,p2,seg_num,blur_flag,blur_index,likelyhood_thres);

%% Step 4: project solar farm on picture
[s0_p] = FindPointInPixel(theta,rou,s0,camera1,sun1);
[s1_p] = FindPointInPixel(theta,rou,s1,camera1,sun1);
[s2_p] = FindPointInPixel(theta,rou,s2,camera1,sun1);
[s3_p] = FindPointInPixel(theta,rou,s3,camera1,sun1);
x=[s0_p(1),s1_p(1),s2_p(1),s3_p(1)];
y=[s0_p(2),s1_p(2),s2_p(2),s3_p(2)];
ImagePlotSuper(pc1_1, pc1_2,seg_num,hex_r,hex_c);
hold on;
sf=fill(x,y,[1 1 1]);
alpha(sf,0.3);
hold off
%{
rectangle = 0;
if rectangle
    w = s2_p-s1_p;w = w(2);
    h = s1_p-s0_p;h = h(1);
    rectangle('Position',[s0_p(1),s0_p(2),w,h],'edgecolor','w','facecolor','b')
end
%}