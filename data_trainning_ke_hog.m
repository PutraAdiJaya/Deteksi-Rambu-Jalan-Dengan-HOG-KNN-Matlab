S = dir('train\negatif\*.jpg'); 
HOG_TRAINNING = [];
LABEL = [];
for k = 1:numel(S)  
    NameFiles =  char(strcat('train\negatif\',S(k).name)); 
     
    imgOri = imread(NameFiles);  
    im = im2double(imgOri);
    img_roi = imresize(im, [200 200]);  
    HOG_im = HOG(img_roi);
    HOG_TRAINNING  = [HOG_TRAINNING HOG_im];   
    LABEL  = [LABEL 0];  
end

S = dir('train\positif\*.jpg'); 
for k = 1:numel(S)  
    NameFiles =  char(strcat('train\positif\',S(k).name));
     
     
    imgOri = imread(NameFiles);  
    im = im2double(imgOri);
    img_roi = imresize(im, [200 200]);  
    HOG_im = HOG(img_roi);
    HOG_TRAINNING  = [HOG_TRAINNING HOG_im];   
    LABEL  = [LABEL 1];   
end
LABEL = LABEL';
HOG_TRAINNING = HOG_TRAINNING';
save 'HOG_TRAIN' LABEL  HOG_TRAINNING