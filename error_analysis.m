error_r = gt_r - hex_r;
error_c = gt_c - hex_c;
% show error in figure
figure
ImagePlot(p1,seg_num,error_r,error_c);
[m,n] = size(error_r);





for i = 1:m
    for j = 1:n
        if (error_r(i,j) ~= 0 || error_c(i,j) ~= 0)
            msg = sprintf('Row %d, Col %d has error vec <%d, %d>',i,j,error_r(i,j),error_c(i,j));
            disp(msg);
            

            %%%%% run the GT algo for this segment
            [gt_rr, gt_cc, gt_v] = BrutalMovDetectorDebug(p1,p2,seg_num,blur_flag,blur_index, ~debug_mode,likelyhood_thres, i,j);
            msg = sprintf('Ground Truth Row: %d, Col: %d: Motion vector is: (%d, %d)',i, j, gt_rr, gt_cc);
            disp(msg);
            msg = sprintf('Hex result Motion vector is: (%d, %d)\n',hex_r(i,j), hex_c(i,j));
            disp(msg);
            %figure
            %surf(gt_v)

            [hex_rr, hex_cc, hex_v] = HexMovDetectorDebug(p1,p2,seg_num,blur_flag,blur_index,likelyhood_thres, i, j, gt_v);

                

                
            
            %%%%% run HEXBS algorithm for this segment

        end
    end
end