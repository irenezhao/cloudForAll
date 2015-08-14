%% Step 1. Get Cloud SVM features
if 0
if 0
pic1 = imread('f1.jpg');
pic2 = imread('f2.jpg');
seg_num = 40;
seg = getFrameSegments(pic1,pic2,seg_num);
seg_index=320;
feature=getCloudFeature(seg,seg_num,seg_index);
save('feature');
end

load feature
load cloud
cloud = cloud';

% train(80) crossvalid(80) test(160)
% data for train and crossvalid
xdata = feature(1:160,:);
group = cloud(1:160);
p=0.5; % ratio of train data from 160 samples
[Train,Cross] = crossvalind('HoldOut',group,p);
TrainingSample = xdata(Train,:);
TrainingLabel = group(Train,1);
CrossSample = xdata(Cross,:);
CrossLabel = group(Cross,1);
svmStruct = svmtrain(TrainingSample,TrainingLabel,...
    'kernel_function','linear')%,'rbf_sigma',0.1);
% valid through crossvalid data
OutLabel = svmclassify(svmStruct,CrossSample);
% c1 = 1 - error%
c1=sum(grp2idx(OutLabel) == grp2idx(CrossLabel))/sum(Cross);


% validate through testing data
resdata = feature(161:end,:);
resgroup = cloud(161:end);
resLabel = svmclassify(svmStruct,resdata);
c2 = sum(grp2idx(resLabel) == grp2idx(resgroup))/160;
end 

%% Step 2. Find CLouds in Real Pictures and Revise motion vectors

svmStruct = load ('svmStruct.mat');
pic1 = imread('f1.jpg');
p1 = rgb2gray(pic1);
pic2 = imread('f2.jpg');
p2 = rgb2gray(pic2);

seg_num = 40;
seg = getFrameSegments(pic1,pic2,seg_num);
seg_index=320;
feature=getCloudFeature(seg,seg_num,seg_index);
CloudLabel = svmclassify(svmStruct.svmStruct,feature);

likelyhood_thres = 10;
blur_flag = false;
blur_index = 6;

[hex_r, hex_c] = HexMovDetector(p1,p2,seg_num,blur_flag,blur_index,likelyhood_thres);
[hex_r, hex_c] = CloudMotionRevise(hex_r,hex_c,CloudLabel);
figure;
ImagePlotSuper(pic1, pic2,seg_num,hex_r,hex_c);