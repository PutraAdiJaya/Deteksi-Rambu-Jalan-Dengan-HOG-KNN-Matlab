function [ imROI,Bound ] = Roi( im ) 
   [imROI,Bound] =  CandidateGenerationWindow(im); 
end


function [windowCandidates,Bound ] = filter_Bounding(Bounding,Area,  Bound_Area)
NumObjects = numel(Area);
j = 1;
MinArea = 200;
MaxArea = 100000;
aspect_ratio = 1.5; 
buffer(NumObjects)=struct('x',[],'y',[],'w',[],'h',[]);   
for i=1:NumObjects
%      if ((Area(i).Area >= MinArea) && (Area(i).Area <= MaxArea)  && (Bounding(i).BoundingBox(3) <= aspect_ratio * Bounding(i).BoundingBox(4)))
         
        buffer(j).x = Bounding(i).BoundingBox(1);
        buffer(j).y = Bounding(i).BoundingBox(2);
        buffer(j).w = Bounding(i).BoundingBox(3);
        buffer(j).h = Bounding(i).BoundingBox(4);
        j = j + 1;
%     end
end
windowCandidates(1:j-1)=buffer(1:j-1);
Bound = Bound_Area;
end

function [windowCandidates, Bound] = CandidateGenerationWindow(im)
    [Bounding,Area, Bound]=bounding_boxes(im);
    n = numel(Area);
    if n>0
        [windowCandidates,Bound] = filter_Bounding(Bounding,Area,Bound );
    else
        windowCandidates = [];
    end
end

function [Bounding,Area, Bound_Area] = bounding_boxes(mask) 
    maskLabeled = bwlabel(mask, 8);  
    Bounding = regionprops(maskLabeled, 'BoundingBox');    
    Area = regionprops(maskLabeled,'Area');   
    Bound_Area  = regionprops(maskLabeled, 'BoundingBox', 'Area'); 
end
