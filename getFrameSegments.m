function [seg]=getFrameSegments(pic1,pic2,seg_num)
%初始化所有色块
if( sum( size(pic1) == size(pic2)) == 3)

        [height, width,color] = size(pic1);
    else
        disp('two frames have different size, abort!')
        assert(sum( size(pic2) == size(pic1)) == 3)
end
    
    num = seg_num;
    rows = height/num; %240 and 320 should be changed 
    cols = width/num;
    blk_num = rows*cols;
    nframes = 2; %we only have two frames here
    
    for i = 1:nframes
        for j = 1:rows
            for m = 1:cols
                index = blk_num*(i-1)+m + (j-1)*cols;
                seg(:,:,:,index) = pic1((((j-1)*num+1):(j*num)),(((m-1)*num+1):(m*num)),:);
            end
        end   
    end


%seg中存有320个色块
%segment = seg(:,:,:,index);
%imshow(seg(:,:,:,1)) 第一块  
    
    


