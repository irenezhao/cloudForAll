function [ opt_r, opt_c, v ] = BrutalMovDetectorDebug( pixel1, pixel2, seg_num, ...
    BlurFlag, blur_index, debug_mode, thres, probe_row, probe_col)
%BRUTALMOVDETECTOR Summary of this function goes here
%   Detailed explanation goes here

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%% parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     %threshold = 6; %% still cannot cancel some noise
     %threshold = 7.5;
     %threshold = 10;
     threshold = thres;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%% pre-check two images %%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if( sum( size(pixel2) == size(pixel1)) == 2)

        [height, width] = size(pixel1);
    else
        disp('two frames have different size, abort!')
        assert(sum( size(pixel2) == size(pixel1)) == 2)
    end
    
    num = seg_num;
    rows = height/num; %240 and 320 should be changed 
    cols = width/num;
    blk_num = rows*cols;
    nframes = 2; %we only have two frames here

    pixel(:,:,1) = pixel1;
    pixel(:,:,2) = pixel2;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%% segment the two images: code style %%%%%%%%%
    %%%%%%%%%% 1,   2, ...  cols    %%%%%%%%%%%%%%%%%%
    %%%%%%%%%% c+1, c+2,...,2c      %%%%%%%%%%%%%%%%%%
    %%%%%%%%%% .................    %%%%%%%%%%%%%%%%%%
    %%%%%%%%%% (r-1)*c+1,..,r*c     %%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


    %seg is the two frames
    %seg(:,:,:,1) is frame1; seg(:,:,:,2) is frame2
    for i = 1:nframes
    %for i = 1:1
        for j = 1:rows
            for m = 1:cols
                %index = m + (j-1)*num;
                index = m + (j-1)*cols;
                seg(:,:,index,i) = pixel((((j-1)*num+1):(j*num)),(((m-1)*num+1):(m*num)),i);
            end
        end   
    end
    

    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%% search every possible position and find optima %%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    for i = probe_row:probe_row
        for j = probe_col:probe_col
         
            position.segr = i;
            position.segc = j;
%             BlockNum = position.segc + (position.segr-1)*num;
            opt_r = 0;
            opt_c = 0;
            
            index = j + (i-1)*cols;
            %disp(index);
            
            
            if(i ~=1 && i~=rows && j ~=1 && j ~= cols)
                
                %disp(index);

                if(BlurFlag == true)
                    I = pixel(:,:,2);
                    H = fspecial('disk',blur_index);
                    pixel_n = imfilter(I,H,'replicate');
            
                                    
                    %I = seg(:,:,(position.segc + (position.segr-1)*num),1);
                    I = seg(:,:,index,1);
                    H = fspecial('disk',blur_index);
                    test_seg = imfilter(I,H,'replicate');
                else
                    pixel_n = pixel(:,:,2);
                    %test_seg = seg(:,:,(position.segc + (position.segr-1)*num),1);
                    %test_seg = seg(:,:,(position.segr + (position.segc-1)*cols),1);
                    test_seg = seg(:,:,index,1);
                end

                numCounter = num;
                for m = -numCounter:numCounter
                    for n = -numCounter:numCounter       
                        position.dx = m; % row offset
                        position.dy = n; % col offset
                        diff = MAD(test_seg, pixel_n, position,num, threshold);
                        v(m+numCounter+1,n+numCounter+1) = diff.value;
                        d_r(m+numCounter+1,n+numCounter+1) = diff.row;
                        d_c(m+numCounter+1,n+numCounter+1) = diff.col;
                    end
                end
                
%                 if (index == 25)
%                     m = 72 - 41;
%                     n = 29 - 41;
%                     position.segr = 1;
%                     position.segc = 9;
%                     position.dx = m;
%                     position.dy = n;
%                     cannot_be_true = MAD(test_seg,pixel_n,position, num);
%                 end
                %[cx,cy] = find(v == min(min(v)));
                [cx, cy] = findOptPos(v);
                %surf(v)

                opt_r = d_r(min(abs(cx)),min(abs(cy)));
                opt_c = d_c(min(abs(cx)),min(abs(cy)));
                
                if (debug_mode)
                    %surf(v)
                    msg = sprintf('Row: %d, Col: %d: Motion vector is: (%d, %d)',i, j, opt_r, opt_c);
                    disp(msg);
                    test = 1;
                    org_r = (i-1)*num + 1;
                    org_c = (j-1)*num + 1;
                    next_r = org_r + opt_r;
                    next_c = org_c + opt_c;
                    %plot2Segs(pixel1, org_r, org_c, pixel2, next_r, next_c, num);
                end
                
            end
            
%             disp(i)
%             disp(j)
            
            res_r(i,j) = opt_r;
            res_c(i,j) = opt_c;
        end
    end
    
end

