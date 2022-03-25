 
close all; clc;
S = dir('img\*.jpg');
indx = 1;
for k = 1:numel(S) 
    idx = strfind(S(k).name,'label')
    if (isempty(idx))
        NameExt =  strsplit(S(k).name,'.');
        NameLabel =  char(strcat('img\',NameExt(1),'_label.',NameExt(2)))
        NameFiles =  char(strcat('img\',S(k).name))
        if exist(NameLabel ,'file') 
             


            imgOri = imread(NameFiles);
            img = im2double(imgOri); 
            xImage = imread(NameLabel);
            xImage = 255 - xImage;
            mask  = im2double(xImage);  
            if size(mask, 3) == 1 && size(img, 3) > 1
                mask = repmat(mask, [1, 1, size(img, 3)]);
            end
            CorruptedImage = mask .* img;
            Q = mask(:, :, 1);
            Red = CorruptedImage(:, :, 1);
            Gre = CorruptedImage(:, :, 2);
            Blu = CorruptedImage(:, :, 3); 
            figure; montage(CorruptedImage, 'Size', [1, 3]); 
            

            % Get the image 
            im=rgb2gray(xImage); % convert to gray scale
            im=im>graythresh(im)*255; % covert to binary
            siz=size(im); % image dimensions
            % Label the disconnected foreground regions (using 8 conned neighbourhood)
            L=bwlabel(im,8);
            % Get the bounding box around each object
            bb=regionprops(L,'BoundingBox');
            % Crop the individual objects and store them in a cell
            n=max(L(:)); % number of objects
            ObjCell=cell(n,4);
            for i=1:n
                  % Get the bb of the i-th object and offest by 2 pixels in all
                  % directions
                  bb_i=ceil(bb(i).BoundingBox);
                  idx_x=[bb_i(1)-2 bb_i(1)+bb_i(3)+2];
                  idx_y=[bb_i(2)-2 bb_i(2)+bb_i(4)+2];
                  if idx_x(1)<1, idx_x(1)=1; end
                  if idx_y(1)<1, idx_y(1)=1; end
                  if idx_x(2)>siz(2), idx_x(2)=siz(2); end
                  if idx_y(2)>siz(1), idx_y(2)=siz(1); end
                  % Crop the object and write to ObjCell
                  im=L==i;

                  coord =bb_i;
                  subimage = imcrop(CorruptedImage, [coord(1), coord(2), coord(3), coord(4)]); % You can x, y, height and width for coord(k)
                  

                  ObjCell{i}=subimage; 
            end
            % Visualize the individual objects
            figure
            for i=1:n
                subplot(1,n,i)
                imshow(ObjCell{i})
                imwrite(ObjCell{i},char(strcat('train\',num2str(indx),'.jpg')))
                indx = indx+1;
            end
            clear im L bb n i bb_i idx_x idx_y siz
 
            
        end 
    end 
end 

