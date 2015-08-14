function [ diff ] = MAD( seg, pixel_n, position, num, threshold)
%MAD Summary of this function goes here
%   Detailed explanation goes here
% position.segr
% position.segc
% position.dx
% position.dy
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%% THRESHOLD!!! for noise cancelling %%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% threshold, if the difference is too small, we take the two segment as the
% same. Here, the pixel range is 0-255, if we use the msqr, the maximum
% difference is 255^2 = 65025; and we normalized error, 
% the seg_size has nothing to do with the threshol
% therefore, we can set 0.01% error, thershold = 6, try it...;
% seems that threshold = 6 still have much noise, try threshold = 7.5;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




orig_row = (position.segr-1)*num+1;
orig_col = (position.segc-1)*num+1;

comp_row = orig_row + position.dx;
comp_col = orig_col + position.dy;

com_seg = pixel_n((comp_row:comp_row+num-1),(comp_col:comp_col+num-1));

real_seg = int16(seg);
real_com_seg = int16(com_seg);

msqr = true;
if (msqr == true)
    temp_matrix = abs(real_seg - real_com_seg);
    temp_matrix = temp_matrix.^2;
    % normalize the sum
    % value = sum(pix_diff^2)/Num_pix
    diff.value = sum(sum(temp_matrix))/(num*num);
    
else
    diff.value = sum(sum(abs(real_seg - real_com_seg)));
end

if (diff.value <= threshold)
    diff.value = 0;
end

diff.row = position.dx;
diff.col = position.dy;

end

