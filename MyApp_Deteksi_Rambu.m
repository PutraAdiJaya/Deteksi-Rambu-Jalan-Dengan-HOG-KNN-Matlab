function varargout = MyApp_Deteksi_Rambu(varargin)
% MYAPP_DETEKSI_RAMBU MATLAB code for MyApp_Deteksi_Rambu.fig
%      MYAPP_DETEKSI_RAMBU, by itself, creates a new MYAPP_DETEKSI_RAMBU or raises the existing
%      singleton*.
%
%      H = MYAPP_DETEKSI_RAMBU returns the handle to a new MYAPP_DETEKSI_RAMBU or the handle to
%      the existing singleton*.
%
%      MYAPP_DETEKSI_RAMBU('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MYAPP_DETEKSI_RAMBU.M with the given input arguments.
%
%      MYAPP_DETEKSI_RAMBU('Property','Value',...) creates a new MYAPP_DETEKSI_RAMBU or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MyApp_Deteksi_Rambu_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MyApp_Deteksi_Rambu_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MyApp_Deteksi_Rambu

% Last Modified by GUIDE v2.5 21-Dec-2020 02:44:45

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MyApp_Deteksi_Rambu_OpeningFcn, ...
                   'gui_OutputFcn',  @MyApp_Deteksi_Rambu_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before MyApp_Deteksi_Rambu is made visible.
function MyApp_Deteksi_Rambu_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MyApp_Deteksi_Rambu (see VARARGIN)

% Choose default command line output for MyApp_Deteksi_Rambu
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes MyApp_Deteksi_Rambu wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = MyApp_Deteksi_Rambu_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
 


% --- Executes on button press in btnLoad.
function btnLoad_Callback(hObject, eventdata, handles)
% hObject    handle to btnLoad (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


[file,path] = uigetfile('*.jpg');
if isequal(file,0)
   disp('Batal pilih file...');
else
    disp(['User selected ', fullfile(path,file)]);
    global imagespath;
    imagespath = fullfile(path,file);  
    
    myImage = imread(imagespath);
    set(handles.axImgOri,'Units','pixels');  
    axes(handles.axImgOri);
    imshow(myImage);
    set(handles.axImgOri,'Units','normalized');
end

% --- Executes on button press in btnMulai.
function btnMulai_Callback(hObject, eventdata, handles)
% hObject    handle to btnMulai (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



global imagespath;   
imgOri = imread(imagespath);  
 

        im = im2double(imgOri);

        [segmentedIm]= Segmentasi(im); 

        set(handles.axMorfologi_1,'Units','pixels');  
        axes(handles.axMorfologi_1);
        imshow(segmentedIm);
        set(handles.axMorfologi_1,'Units','normalized');


        [ MfImage1, MfImage2 ] = Morfologi( segmentedIm );

        set(handles.axMorfologi_2,'Units','pixels');  
        axes(handles.axMorfologi_2);
        imshow(MfImage1);
        set(handles.axMorfologi_2,'Units','normalized');

        set(handles.axMorfologi_3,'Units','pixels');  
        axes(handles.axMorfologi_3);
        imshow(MfImage2);
        set(handles.axMorfologi_3,'Units','normalized');


        set(handles.axRoi,'Units','pixels');  
        axes(handles.axRoi);
        imshow(imgOri) 

        HOG_ROI = [];
        [windowCandidates,Bound] =  Roi( MfImage2 );
        for l = 1: numel(windowCandidates)
            coord = windowCandidates(l);
            subimage = imcrop(imgOri,    [coord.x, coord.y, coord.h, coord.w] ); 
            imwrite(subimage, char(strcat('temp\',num2str(l),'-','.jpg')));

            img_roi = imresize(subimage, [200 200]); 
            HOG_im = HOG(img_roi);
            HOG_ROI  = [HOG_ROI HOG_im];  

            rectangle('Position', [coord.x, coord.y, coord.h, coord.w],...
                'EdgeColor','g','LineWidth',5 )
        end 


        set(handles.axRoi,'Units','normalized');   

        HOG_ROI = HOG_ROI'
        save 'temp' HOG_ROI 
        load HOG_TRAIN 

        k = 5;
        metric = 'euclidean';

        dim = size(HOG_ROI);

        mdl = myKNN(k,metric);
        mdl = mdl.fit(HOG_TRAINNING,LABEL); 
 
        
        imshow(imgOri) 
        FOUND_IMAGE = {};
        index = 1;
        for l = 1: dim(1)
            C_roi = HOG_ROI(l,:); 
            Ypred = mdl.predict(C_roi)  

            if Ypred==1
                coord = windowCandidates(l);  
                rectangle('Position', [coord.x, coord.y, coord.h, coord.w],...
                    'EdgeColor','r','LineWidth',5 ) 
                
                subimage = imcrop(imgOri,    [coord.x, coord.y, coord.h, coord.w] );  
                img_roi = imresize(subimage, [200 200]); 
                FOUND_IMAGE{index}  =   img_roi ;  
                index = index +1;
            end  

        end 
        dim = numel(FOUND_IMAGE) 
        handlesAxes(handles.axResult_0); 
        cla(handles.axResult_0);
        handlesAxes(handles.axResult_1);  
        cla(handles.axResult_1);
        handlesAxes(handles.axResult_2);  
        cla(handles.axResult_2);
        handlesAxes(handles.axResult_3);  
        cla(handles.axResult_3);
        handlesAxes(handles.axResult_4);  
        cla(handles.axResult_4);
        handlesAxes(handles.axResult_5);  
        cla(handles.axResult_5);
        handlesAxes(handles.axResult_6);  
        cla(handles.axResult_6);
        handlesAxes(handles.axResult_7);  
        cla(handles.axResult_7);
        
        
        for l = 1: dim 
            if  l==1
                handlesAxes(handles.axResult_0); 
            elseif  l==2
                handlesAxes(handles.axResult_1);  
            elseif  l==3
                handlesAxes(handles.axResult_2);  
            elseif  l==4
                handlesAxes(handles.axResult_3);  
            elseif  l==5
                handlesAxes(handles.axResult_4);  
            elseif  l==6
                handlesAxes(handles.axResult_5);  
            elseif  l==7
                handlesAxes(handles.axResult_6);  
            elseif  l==8
                handlesAxes(handles.axResult_7);  
            end
            imshow(FOUND_IMAGE{l})
        end
 
function handlesAxes(axNames)
    set(axNames,'Units','pixels');  
    axes(axNames); 
    set(axNames,'Units','normalized');  
 


% --- Executes during object creation, after setting all properties.
function btnLoad_CreateFcn(hObject, eventdata, handles)
% hObject    handle to btnLoad (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called




% global imagespath;
% for i=1:length(imagespath)
%     handles.ax = axes('Position',[0.2*i,0,0.2,0.2],'Visible','on','XLim',[0 i*0.1],'YLim',[0 i*0.1],'Parent', handles.uipanel2);
%     myImage = imread(imagespath{i}{1});
%     set(handles.ax,'Units','pixels');
%     resizePos = get(handles.ax,'Position');
%     myImage= imresize(myImage, [resizePos(3) resizePos(3)]);
%     axes(handles.ax);
%     imshow(myImage);
%     set(handles.ax,'Units','normalized');
% end
