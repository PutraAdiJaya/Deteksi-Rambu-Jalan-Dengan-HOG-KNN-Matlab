function [ MfImage1, MfImage2  ] = Morfologi( BwImage ) 

    % 
    seD = strel('diamond',2);
    BwImage = imerode(BwImage,seD);
    MfImage1 = BwImage;
% %     MfImage = imerode(BWfinal,seD); 
%      
    seD = strel('diamond',10);
    BwImage = imdilate(BwImage,seD); 

    se = strel('disk',2);
    maskOpen = imopen(BwImage,se); 
    
    se2 = strel('disk',4);
    maskClose = imclose(maskOpen,se2);
    BWdfill = imfill(maskClose, 'holes');   
    BwImage = imclearborder(BWdfill, 4);
    
    seD = strel('diamond',10);
    BwImage = imdilate(BwImage,seD); 
    
    MfImage2 = BwImage; 
%     labeledImage = bwlabel(MfImage);
%     props = regionprops(labeledImage, 'Centroid', 'Area');
%     allCentroids = [props.Centroid];
%     xCentroids = allCentroids(1:2:end) 
%     keepers = xCentroids < 500;
%     indexes = find(keepers); 
%     MfImage = ismember(labeledImage, indexes);
end

