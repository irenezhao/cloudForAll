function [ res_r, res_c ] = BrutalMovDetectorSA( pixel1, pixel2, seg_num, BlurFlag, blur_index)
%BRUTALMOVDETECTOR Summary of this function goes here
%   Detailed explanation goes here


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
    
    for m = 1:rows
%     for m = 2:2
        for n = 1:cols
%         for n = 6:6
            position.segr = m;
            position.segc = n;
            %BlockNum = position.segc + (position.segr-1)*num;
            index = n + (m-1)*cols;
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

                localoptflag = 0;
                firstflag = 1;
                vmin = 1000000000000;
                xmin = 0;
                ymin = 0;
                vmin_local = 1000000000000;
                suboptIdx = 0;
                % parameters for simulated annealing
                T_max = 30;  % total max temp
                T_steps = 5; % local max temp
                t = 0;       % current temp
                step = 0;
                while step<T_max
                    step = step + 1;
                    disp(['step ', num2str(t), 'in total step of ', num2str(step), ...
                        '. current value:', num2str(vmin_local), ', optimal:', num2str(vmin) ]);
                    if firstflag == 1
                        center_pos.r = 0;
                        center_pos.c = 0;
                        firstflag = 0;
                    else
                        suboptIdx
                        center_pos.r = para_pos(suboptIdx - 1).r
                        center_pos.c = para_pos(suboptIdx - 1).c;
                    end

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
                            diff = MAD(test_seg, pixel_n, position,seg_num);
                            v(i) = diff.value;
                            x(i) = diff.x;
                            y(i) = diff.y;
                        else
                            j = i-1;
                            position.dx = para_pos(j).r;
                            position.dy = para_pos(j).c;
                            diff = MAD(test_seg, pixel_n, position,seg_num);
                            v(i) = diff.value;
                            x(i) = diff.x;
                            y(i) = diff.y;
                        end
                    end
                    [vmin_local, suboptIdx] = min(v);
                    if suboptIdx == 1
                        disp('hahaha')
                    end

                    % local optimal or not
                    %%%%% if the optimal is the center of the hexogal%%%%%%
                    localoptflag = (vmin_local<vmin && suboptIdx==1);
                    if localoptflag
                        t = 0;
                    else
                        t = t+1;
                    end
                    if vmin_local<vmin %optimal
                        vmin = vmin_local;
                        if suboptIdx ~= 1
                            center_pos.r = para_pos(suboptIdx - 1).r;
                            center_pos.c = para_pos(suboptIdx - 1).c;
                            %cannot search beyond boundry
                            if(abs(center_pos.r) > (num -3) || abs(center_pos.c) > (num -3))
                                opt_r = center_pos.r;
                                opt_c = center_pos.c;
                                break;
                            end
                        end
                    end

                    % continue heat or not
                    cont = binornd(1, exp(-t/T_steps));
                    if cont
                        if suboptIdx==1 %center is optimal, use 2nd optimal point
                            % + 1 in case they all have the same value and
                            % 2nd optimal becomes the central point again
                            v(suboptIdx) = max(v)+1;
                            [vmin_local, suboptIdx] = min(v);
                        end
                    else
                        break;
                    end

                end


                clear v;
                clear x;
                clear y;

                sub_pos(1).r = center_pos.r;
                sub_pos(1).c = center_pos.c + 1;
                sub_pos(2).r = center_pos.r - 1;
                sub_pos(2).c = center_pos.c;
                sub_pos(3).r = center_pos.r;
                sub_pos(3).c = center_pos.c - 1;
                sub_pos(4).r = center_pos.r + 1;
                sub_pos(4).c = center_pos.c;

                for i = 1:5
                    if(i == 1)
                        position.dx = center_pos.r;
                        position.dy = center_pos.c;
                        diff = MAD(test_seg, pixel_n, position,seg_num);
                        v(i) = diff.value;
                        x(i) = diff.x;
                        y(i) = diff.y; 
                    else
                        j = i-1;
                        position.dx = sub_pos(j).r;
                        position.dy = sub_pos(j).c;
                        diff = MAD(test_seg, pixel_n, position,seg_num);
                        v(i) = diff.value;
                        x(i) = diff.x;
                        y(i) = diff.y;
                    end
                end

                %%%% locate the optimal solution %%%%%%%%
                [opt_value, opt_ind] = min(v);
                opt_r = x(opt_ind);
                opt_c = y(opt_ind);
                end
            
%             disp(m)
%             disp(n)
            res_r(m,n) = opt_r;
            res_c(m,n) = opt_c;
        end
    end
end

   


