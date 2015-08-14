%all test for 100cases
pic1 = imread('f1.jpg');

%a:random angle:(-1.8degree~+1.8degree)
a = rand(1,100);
a = a-0.5;
a = a/0.5*1.8;

%parameter for HEXBS
seg_num = 40;
blur_index = 6;
blur_flag = false;
debug_mode = false;
likelyhood_thres = 10;



%% step 1:angle analysis--(-1.8%~+1.8%)
if 0
for i=1:100
    pic2 = imrotate(pic1,a(i),'crop');
    %imwrite(pic2,'f2-1.jpg');
    p1 = rgb2gray(pic1);
    p2 = rgb2gray(pic2);
    
    disp('Normal HEXBS')
    [hex_r, hex_c] = HexMovDetector(p1,p2,seg_num,blur_flag,blur_index,likelyhood_thres);
    [m,n] = size(hex_r);
    angle_error_mean(1,i) = mean(mean(hex_c(2:(m-1),2:(n-1))));
    angle_error_mean(2,i) = mean(mean(hex_r(2:(m-1),2:(n-1))));
    angle_error_mean_center(1,i) = mean(mean(hex_c(4:(m-3),4:(n-3))));
    angle_error_mean_center(2,i) = mean(mean(hex_r(4:(m-3),4:(n-3))));
end
save('angle_error_mean')
save('angle_error_mean_center')
end

%% step 2:shift analysis
if 0
for i=1:100
    [ x_pix, y_pix ] = calcDrift;
    se=translate(strel(1),[x_pix, y_pix]);
    pic2=imdilate(pic1,se);
    p1 = rgb2gray(pic1);
    p2 = rgb2gray(pic2);
    
    disp('Normal HEXBS')
    [hex_r, hex_c] = HexMovDetector(p1,p2,seg_num,blur_flag,blur_index,likelyhood_thres);
    [m,n] = size(hex_r);
    shift_error_mean(1,i) = mean(mean(hex_c(2:(m-1),2:(n-1))));
    shift_error_mean(2,i) = mean(mean(hex_r(2:(m-1),2:(n-1))));
    shift_error_mean_center(1,i) = mean(mean(hex_c(4:(m-3),4:(n-3))));
    shift_error_mean_center(2,i) = mean(mean(hex_r(4:(m-3),4:(n-3))));
end
save('shift_error_mean')
save('shift_error_mean_center')
end



%% Step 3: angle&shift analysis
for i=1:100
    pic2 = imrotate(pic1,a(i),'crop');
    
    [ x_pix, y_pix ] = calcDrift;
    se=translate(strel(1),[x_pix, y_pix]);
    pic2=imdilate(pic2,se);
    
    p1 = rgb2gray(pic1);
    p2 = rgb2gray(pic2);
    
    disp('Normal HEXBS')
    [hex_r, hex_c] = HexMovDetector(p1,p2,seg_num,blur_flag,blur_index,likelyhood_thres);
    [m,n] = size(hex_r);
    angle_shift_error_mean(1,i) = mean(mean(hex_c(2:(m-1),2:(n-1))));
    angle_shift_error_mean(2,i) = mean(mean(hex_r(2:(m-1),2:(n-1))));
    angle_shift_error_mean_center(1,i) = mean(mean(hex_c(4:(m-3),4:(n-3))));
    angle_shift_error_mean_center(2,i) = mean(mean(hex_r(4:(m-3),4:(n-3))));
end
save('angle_shift_error_mean')
save('angle_shift_error_mean_center')