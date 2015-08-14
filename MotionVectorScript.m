%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Part 1 Motion Vection
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function Parameters
seg_num = 40; % segment size 
blur_flag = false; % do we need to blur image?
blur_index = 6; % low pass filter paramter
debug_mode = true;
% hard thres for noise cancelling
% when it is 0, no noise cancelling
likelyhood_thres = 10; 

% Step 1. Load 2 consecutive images
p1 = imread('f1.jpg');
p1 = rgb2gray(p1);
p2 = imread('f2.jpg');
p2 = rgb2gray(p2);

% show 2 images
if 0
    subplot(3,1,1);
    v1 = zeros(10,16);
    v2 = zeros(10,16);
    ImagePlot(p1,40,v1,v2);

    subplot(3,1,2);
    v1 = zeros(10,16);
    v2 = zeros(10,16);
    ImagePlot(p2,40,v1,v2);

    subplot(3,1,3);
    ImagePlotSuper(p1, p2,40,v1,v2);
end

% Step 2. Algorithm 1: Brutal Force 
if 0
[gt_r,gt_c] = BrutalMovDetector(p1,p2,seg_num,blur_flag,blur_index, debug_mode, likelyhood_thres);
figure;
ImagePlotSuper(p1, p2,seg_num,gt_r,gt_c);
end

% Step 3. Algorithm 2: HEXBS
[hex_r, hex_c] = HexMovDetector(p1,p2,seg_num,blur_flag,blur_index,likelyhood_thres);
figure;
ImagePlot(p1,seg_num,hex_r,hex_c);

% to debug difference between BF and HEXBS
% error_analysis;

% Step 4. Algorithm 3: HEXBS with Simulated Annealing
if 0
[hexsa_x, hexsa_y] = HexMovDetectorSA(p1,p2,seg_num,false,blur_index);
figure
ImagePlot(p1,seg_num,hexsa_x,hexsa_y);
end
