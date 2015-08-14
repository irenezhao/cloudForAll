function [gt_r,gt_c,num] = CloudDetectOneStep(gt_r,gt_c,CloudLabel)
[m,n] = size(gt_r);
cloud = CloudLabel(1:m*n);
cloud = reshape(cloud,n,m);
cloud= cloud';
count = zeros(m,n);
sumdetectcloud = 0;%the number of cloud segment which is waiting for revise and has no motion vector
num = 0;%the number of cloud segment which has been revised during this step
for i=2:(m-1)
    for j=2:(n-1)
        %the cloud segment have no motion vector and at least one cloud segment is around 
        if (cloud(i,j)==1)&&(gt_r(i,j)==0)&&(gt_c(i,j)==0)...
                &&((cloud(i-1,j-1)==1)||(cloud(i-1,j)==1)||(cloud(i-1,j+1)==0)...
                ||(cloud(i,j-1)==1)||(cloud(i,j+1)==1)...
                ||(cloud(i+1,j-1)==1)||(cloud(i+1,j)==1)||(cloud(i+1,j+1)==1))
            sumdetectcloud = sumdetectcloud + 1;
            if (gt_r(i-1,j-1)~=0)||(gt_c(i-1,j-1)~=0)
                count(i,j) = count(i,j) + 1;
            end
            if (gt_r(i-1,j)~=0)||(gt_c(i-1,j)~=0)
                count(i,j) = count(i,j) + 1;
            end
            if (gt_r(i-1,j+1)~=0)||(gt_c(i-1,j+1)~=0)
                count(i,j) = count(i,j) + 1;
            end
            if (gt_r(i,j-1)~=0)||(gt_c(i,j-1)~=0)
                count(i,j) = count(i,j) + 1;
            end
            if (gt_r(i,j+1)~=0)||(gt_c(i,j+1)~=0)
                count(i,j) = count(i,j) + 1;
            end
            if (gt_r(i+1,j-1)~=0)||(gt_c(i+1,j-1)~=0)
                count(i,j) = count(i,j) + 1;
            end
            if (gt_r(i+1,j)~=0)||(gt_c(i+1,j)~=0)
                count(i,j) = count(i,j) + 1;
            end
            if (gt_r(i+1,j+1)~=0)||(gt_c(i+1,j+1)~=0)
                count(i,j) = count(i,j) + 1;
            end
        end  
    end
end

if sumdetectcloud~=0
    std = max(max(count));
    for i=2:(m-1)
        for j=2:(n-1)
            if count(i,j)==std
                num = num + 1;
                gt_r(i,j) = gt_r(i-1,j-1)+gt_r(i-1,j)+gt_r(i-1,j+1)...
                           +gt_r(i,j-1)+gt_r(i,j+1)...
                           +gt_r(i+1,j-1)+gt_r(i+1,j)+gt_r(i+1,j+1);
                gt_r(i,j) = round(gt_r(i,j)/std);
                gt_c(i,j) = gt_c(i-1,j-1)+gt_c(i-1,j)+gt_c(i-1,j+1)...
                           +gt_c(i,j-1)+gt_c(i,j+1)...
                           +gt_c(i+1,j-1)+gt_c(i+1,j)+gt_c(i+1,j+1);
                gt_c(i,j) = round(gt_c(i,j)/std);
            end
        end
    end
end

