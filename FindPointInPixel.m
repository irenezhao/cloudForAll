function [p_p] = FindPointInPixel(theta,rou,p,camera1,sun1)
c1p = p-camera1;
c1p = c1p(1:2);
c1p = c1p';
p_p=sun1'+[cos(theta),-sin(theta);sin(theta),cos(theta)]*rou\c1p;