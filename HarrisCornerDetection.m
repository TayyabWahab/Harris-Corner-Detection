clear all
close all
clc

%Read Image
img = imread('Stitch1.jpeg'); 
img = rgb2gray(img);
h = fspecial('gaussian',[3 3],2);    %Intializing a 3x3 Gaussian Filter 
temp = filter2(h,img)                %Apply Gaussian Filter to smoothen the Images and remove noise

fx = [-1 0 1;-1 0 1;-1 0 1];         %Horizontal Sobel Filter
Ix = filter2(fx,temp);               %Apply Sobel filter to get horizontal edges

fy = [1 1 1;0 0 0;-1 -1 -1];        %Vertical Sobel Filter
Iy = filter2(fy,temp);               %Apply Sobel filter to get vertical edges
Ix2 = Ix.^2;
Iy2 = Iy.^2;
Ixy = Ix.*Iy;                       %Combine Horizontal and Vertical Edges

figure
imshow(Ixy)

h= fspecial('gaussian',[9 9],2); %Intializing a 9x9 Gaussian Filter 

%Apply Gaussian Filter on the edges to remove noise and smooth edges
Ix2 = filter2(h,Ix2);
Iy2 = filter2(h,Iy2);
Ixy = filter2(h,Ixy);

%Get Attributes of Image
height = size(img,1);
width = size(img,2);
result = zeros(height,width); 
R = zeros(height,width);
Rmax = 0; 

%Corners Extraction 
for i = 1:height
for j = 1:width
M = [Ix2(i,j) Ixy(i,j);Ixy(i,j) Iy2(i,j)]; 
R(i,j) = det(M)-0.01*(trace(M))^2;      %Finding Trace and determinant for corner extracton
if R(i,j) > Rmax                        %Removing other edges and retaining corner only
Rmax = R(i,j);
end;
end;
end;
cnt = 0;

%Apply non-Maxia Suppression
for i = 2:height-1
for j = 2:width-1
if R(i,j) > 0.003*Rmax && R(i,j) > R(i-1,j-1) && R(i,j) > R(i-1,j) && R(i,j) > R(i-1,j+1) && R(i,j) > R(i,j-1) && R(i,j) > R(i,j+1) && R(i,j) > R(i+1,j-1) && R(i,j) > R(i+1,j) && R(i,j) > R(i+1,j+1)
result(i,j) = 1;        %If the point is a maxima, preserve it otherwise not
cnt = cnt+1;
end;
end;
end;

[posc, posr] = find(result == 1);       %Only save the extracted points
imshow(img);
hold on;
plot(posr,posc,'r.');