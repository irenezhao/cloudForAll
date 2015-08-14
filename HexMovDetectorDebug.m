function [opt_r,opt_c,vv] = HexMovDetectorDebug( pixel1, pixel2,seg_num,...
 BlurFlag,blur_index, thres, probe_r, probe_c, gt_v)
%MOVDETECTOR Summary of this function goes here
%   Detailed explanation goes here
% input args is the two frames and the blur flag
% ooutput args is the moving vector for each small blocks
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %  parameters
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %likelyhood_thres = 10; % under thres, the two segments are the same
                           % used in MAD
    likelyhood_thres = thres;                 
    
    gt_value = gt_v;
    vv = zeros(91,91);
    vv = vv - 1;
    vv_center_r = 41;
    vv_center_c = 41;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %for each frame, segment as 20 by 20 small blocks%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    if( sum( size(pixel2) == size(pixel1)) == 2)

        [height, width] = size(pixel1);
    else
        disp('two frames have different size, abort!')
        assert(sum( size(pixel2) == size(pixel1)) == 2)
    end
    num = seg_num;
    rows = height/num; 
    cols = width/num;
    blk_num = rows*cols;
    nframes = 2; %we only have two frames here

    pixel(:,:,1) = pixel1;
    pixel(:,:,2) = pixel2;


    %seg is the two frames
    %seg(:,:,:,1) is frame1; seg(:,:,:,2) is frame2
    for i = 1:nframes
    %for i = 1:1
        for j = 1:rows
            for m = 1:cols
                index = m + (j-1)*cols;
                seg(:,:,index,i) = pixel((((j-1)*num+1):(j*num)),(((m-1)*num+1):(m*num)),i);
            end
        end   
    end
    
        
    for m = probe_r:probe_r
%     for m = 2:2
        for n = probe_c:probe_c
%         for n = 6:6
            position.segr = m;
            position.segc = n;
            %BlockNum = position.segc + (position.segr-1)*num;
            index = n + (m-1)*cols;
%             if (index == 18)
%                 test_seg = seg(:,:,index,1);
%                 next_seg = seg(:,:,index,2);
%             end
            opt_r = 0;
            opt_c = 0;
            
            if(m ~=1 && m~=rows && n ~=1 && n ~= cols)
            
                if(BlurFlag == true)
                    I = pixel(:,:,2);
                    H = fspecial('disk',blur_index);
                    pixel_n = imfilter(I,H,'replicate');

                    I = seg(:,:,index,1);
                    H = fspecial('disk',blur_index);
                    test_seg = imfilter(I,H,'replicate');
                else
                    pixel_n = pixel(:,:,2);
                    test_seg = seg(:,:,index,1);
                end

                %%%%%%% seven checking points positions
                position.segr = m;
                position.segc = n;

                center_pos.r = 0;
                center_pos.c = 0;
                optflag = 0;

                while optflag == 0
                    clear v;
                    clear x;
                    clear y;

                    %%% the big pattern search
                    para_pos(1).r = center_pos.r;
                    para_pos(1).c = center_pos.c + 2;

                    para_pos(2).r = center_pos.r + 2;
                    para_pos(2).c = center_pos.c + 1;

                    para_pos(3).r = center_pos.r + 2;
                    para_pos(3).c = center_pos.c - 1;

                    para_pos(4).r = center_pos.r;
                    para_pos(4).c = center_pos.c - 2;

                    para_pos(5).r = center_pos.r - 2;
                    para_pos(5).c = center_pos.c - 1;

                    para_pos(6).r = center_pos.r - 2;
                    para_pos(6).c = center_pos.c + 1;

                    for i = 1:7
                        if( i == 1)
                            position.dx = center_pos.r;
                            position.dy = center_pos.c;
                            diff = MAD(test_seg, pixel_n, position,num, likelyhood_thres);
                            v(i).v = diff.value;
                            v(i).x = position.dx;
                            v(i).y = position.dy;
                            % record MAD of that position
                            vv_r = vv_center_r + center_pos.r;
                            vv_c = vv_center_c + center_pos.c;
                            vv(vv_r, vv_c) = v(i).v;
                        else
                            j = i-1;
                            position.dx = para_pos(j).r;
                            position.dy = para_pos(j).c;
                            diff = MAD(test_seg, pixel_n, position,num, likelyhood_thres);
                            v(i).v = diff.value;
                            v(i).x = position.dx;
                            v(i).y = position.dy;
                            % record MAD of that position
                            vv_r = vv_center_r + position.dx;
                            vv_c = vv_center_c + position.dy;
                            vv(vv_r, vv_c) = v(i).v;
                        end
                    end
                    
                    %%% we might have multiple minimum in the values
                    %%% tempsubopt should be choose as the one closest to
                    %%% the center, which is 1
%                     tempsubopt = find (v == min(v));
%                     subopt = min(tempsubopt);
                      
                    subopt = findOptPosHex(v);

%                     subopt = find (v == min(v))
                    if (subopt == 1)
                        %%% start small pattern search %%%%
                        clear v;
                        clear x;
                        clear y;

                        %{
                        sub_pos(1).r = center_pos.r;
                        sub_pos(1).c = center_pos.c + 1;
                        
                        sub_pos(2).r = center_pos.r - 1;
                        sub_pos(2).c = center_pos.c;
                        
                        sub_pos(3).r = center_pos.r;
                        sub_pos(3).c = center_pos.c - 1;
                        
                        sub_pos(4).r = center_pos.r + 1;
                        sub_pos(4).c = center_pos.c;
                        %}
                        
                        %%% using all 9 points instead of 5 points
                        sub_pos(1).r = center_pos.r;
                        sub_pos(1).c = center_pos.c + 1;
                        
                        sub_pos(2).r = center_pos.r + 1;
                        sub_pos(2).c = center_pos.c + 1;
                        
                        sub_pos(3).r = center_pos.r + 1;
                        sub_pos(3).c = center_pos.c;
                        
                        sub_pos(4).r = center_pos.r + 1;
                        sub_pos(4).c = center_pos.c - 1;
                        
                        sub_pos(5).r = center_pos.r;
                        sub_pos(5).c = center_pos.c - 1;
                        
                        sub_pos(6).r = center_pos.r - 1;
                        sub_pos(6).c = center_pos.c - 1;
                        
                        sub_pos(7).r = center_pos.r - 1;
                        sub_pos(7).c = center_pos.c;
                        
                        sub_pos(8).r = center_pos.r - 1;
                        sub_pos(8).c = center_pos.c + 1;
                        

                        for i = 1:9
                            if(i == 1)
                                position.dx = center_pos.r;
                                position.dy = center_pos.c;
                                diff = MAD(test_seg, pixel_n, position,num, likelyhood_thres);
                                v(i).v = diff.value;
                                v(i).x = position.dx;
                                v(i).y = position.dy;
                                x(i) = diff.row;
                                y(i) = diff.col;
                                % record MAD of that position
                                vv_r = vv_center_r + center_pos.r;
                                vv_c = vv_center_c + center_pos.c;
                                vv(vv_r, vv_c) = v(i).v;
                            else
                                j = i-1;
                                position.dx = sub_pos(j).r;
                                position.dy = sub_pos(j).c;
                                diff = MAD(test_seg, pixel_n, position,num, likelyhood_thres);
                                v(i).v = diff.value;
                                v(i).x = position.dx;
                                v(i).y = position.dy;
                                x(i) = diff.row;
                                y(i) = diff.col;
                                % record MAD of that position
                                vv_r = vv_center_r + position.dx;
                                vv_c = vv_center_c + position.dy;
                                vv(vv_r, vv_c) = v(i).v;
                            end
                        end
                        %%%% locate the optimal solution %%%%%%%%
                        optflag = 1;
                        
                        opt_index = findOptPosHex(v);
                        %opt_ind = find(v == min(v));
                        %opt_value = min(v);
                        opt_r = x(opt_index);
                        opt_c = y(opt_index);


                    else
                        %%%% change the search center of the big pattern and restart the
                        %%%% search
%                         para_pos(subopt - 1).r
%                         disp('center pos');
                        center_pos.r = para_pos(subopt - 1).r;
                        center_pos.c = para_pos(subopt - 1).c;
                        
                        %cannot search beyond boundry
                        if(abs(center_pos.r) > (num -3) || abs(center_pos.c) > (num -3))
                            disp('beyong the boundry!!!!')
                            opt_r = center_pos.r;
                            opt_c = center_pos.c;
                            break;
                        end

                    end

                end
            end
%             disp(m)
%             disp(n)
            res_r(m,n) = opt_r;
            res_c(m,n) = opt_c;
        end
    end

    %%%%%%%% from here record the data into the output %%%%%%%%%

end

