function [hex_r,hex_c] = CloudMotionRevise(hex_r,hex_c,CloudLabel)
    num=true;
    while(num~=0)
        [hex_r,hex_c,num] = CloudDetectOneStep(hex_r,hex_c,CloudLabel);
    end
end