function [segmentedIm]=Segmentasi(im)  
        pixelCandidates = Filter_Warna(im, 'ycbcr');
        maskFound = im(:,:,1) .* 0;
        maskFound(pixelCandidates) = 1;        
        segmentedIm = maskFound; 
end


function [pixelCandidates] = Filter_Warna(im, space) 
im=double(im); 
switch space 
    case 'ycbcr'
        im=rgb2ycbcr(im);
        y=im(:,:,1);
        cb=im(:,:,2);
        cr=im(:,:,3); 
        pixelCandidates_yellow =  ((y>0.40)& (y<0.7)) &   ((cb>0.1)&(cb<0.3)) & ((cr>0.40)& (cr<0.7))    ;
        pixelCandidates_white = ((y>0.25)& (y<0.6)) &   ((cb>0.25)&(cb<0.6)) & ((cr>0.65)& (cr<0.9))    ;
        pixelCandidates=pixelCandidates_white | pixelCandidates_yellow; 
         
    case 'hsv'
        im=rgb2hsv(im);
        H=im(:,:,1);
        S=im(:,:,2); 
        V=im(:,:,3);
        pixelCandidates_white = ((H>0.9)&(H<=1)) & ((S>0.7)|(S<0.8))    & ((V>0.7)|(V<0.8)) ;
        pixelCandidates_yellow = ((H>0.1 & H<0.2)) & ((S>0.9 & S<=1.0))   & ((V>0.9)|(V<=1.0)) ;
        pixelCandidates=pixelCandidates_yellow |    pixelCandidates_white; 
    otherwise
        error('Incorrect color space defined');
        return
end
end