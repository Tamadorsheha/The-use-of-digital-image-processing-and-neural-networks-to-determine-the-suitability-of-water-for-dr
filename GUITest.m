function varargout = GUITest(varargin)
% GUITEST M-file for GUITest.fig
%      GUITEST, by itself, creates a new GUITEST or raises the existing
%      singleton*.
%
%      H = GUITEST returns the handle to a new GUITEST or the handle to
%      the existing singleton*.
%
%      GUITEST('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUITEST.M with the given input arguments.
%
%      GUITEST('Property','Value',...) creates a new GUITEST or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUITest_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUITest_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUITest

% Last Modified by GUIDE v2.5 28-Jul-2018 15:31:45

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUITest_OpeningFcn, ...
                   'gui_OutputFcn',  @GUITest_OutputFcn, ...
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


% --- Executes just before GUITest is made visible.
function GUITest_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUITest (see VARARGIN)


   % Clear the image plot
    InitImageFig(handles)
    
% Choose default command line output for GUITest
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUITest wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUITest_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function InitImageFig(handles)
    img=ones(1170,550,3);
    
    axes(handles.image_original);
    imagesc(img);
    
    function InitImageFig_2(handles)
    img_2=ones(1170,550,3);
    
    axes(handles.image_original_2);
    imagesc(img_2);
    

    
    function ShowImageFile(filename,pathname,handles)
    if ~isequal(filename, 0)
        fn=strcat(pathname,filename);
        img_ori=imread(fn);

        axes(handles.image_original);
        imagesc(img_ori);
        set(handles.image_original,'UserData',img_ori);

 
    end
    

    

% --- Executes during object creation, after setting all properties.
function result_CreateFcn(hObject, eventdata, handles)
% hObject    handle to result (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in procese_man.
function procese_man_Callback(hObject, eventdata, handles)
% hObject    handle to procese_man (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Image=get(handles.image_original,'Userdata');  


A=imcrop(imresize(rgb2gray(Image),[500 600]),[95.5 26.5 433 438]);

h=fspecial('laplacian');
lap=imfilter(A,h,'replicate');
lap1=imadjust(mat2gray(A-lap))-0.2;
%figure
%imshow(lap1);
        axes(handles.axes8);
        %imagesc(lap1);
        imshow(lap1);
        set(handles.axes8,'UserData',lap1);

a=im2double(lap1);

T=0.5*(min(a(:))+max(a(:)));
d=0.01;
done=0;
while ~done
g=a>=T;
t=0.5*(mean(a(g))+mean(a(~g)));
done=abs(T-t)<d;
T=t;
end
bw=1-im2bw(a,T);
%figure
%imshow(bw);

se1=strel('disk',1);
b=imerode(bw,se1);
%figure
%imshow(b);
se=strel('disk',1);
o=imopen(b,se);
%figure
%imshow(o);
%imshow(lap1);
        axes(handles.axes9);
        %imagesc(o);
        imshow(o);
        set(handles.axes9,'UserData',o);
Image = imfill(o,'holes');
[L,ob] = bwlabel(Image);
%figure
%imshow(Image );
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
se2=strel('disk',1);
rode=imerode(Image,se);
pre=Image-rode;
%figure
%imshow(pre+lap1);

        axes(handles.axes10);
       % imagesc(pre+lap1);
       imshow(pre+lap1);
        set(handles.axes10,'UserData',pre+lap1);

[pixli j]=find(Image==1);
area=length(pixli);

[ii jj]=find(pre==1);
boundaryval=length(ii);

c=round((boundaryval.^2)/(4*pi*area));

lc=round(sqrt( (  ii(1)-ii(length(ii))  ).^2 + (  jj(length(ii)-jj(1) )  ).^2));
lp=round(sqrt( ( ii(length(ii)- ii(1))  ).^2 + (  jj(length(ii)-jj(1) )  ).^2));
if((abs(lc-lp)<20) || (boundaryval<=23000) ) 
circle=0;
end
if((abs(lc-lp)>20) && (boundaryval<=1500) )
 circle=1;
end

feature=[area,boundaryval,lc,lp,circle];
display(feature);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
out=feature;
%the neural network consist of three layers 'two hidden layers and output layer'
net=newff(minmax(feature),[1,20,15,1],{'tansig','tansig','tansig','purelin'},'trainlm');
%determine parameters
net.trainParam.show=3;
net.trainParam.lr=0.001;
net.trainParam.epochs=100;
[net,tr]=train(net,feature,out);
outn=sim(net,feature);
final=abs(outn/100)

nntraintool('close');
con=[117.7520,117.7520, 117.7520, 117.7520, 117.7520;
    188.9340,188.9340,188.9340,188.9340,188.9340;
    125.5400 ,125.5400 , 125.5400 , 125.5400 , 125.5400];
 
def1=abs(con(1,:)-final);
def2=abs(con(2,:)-final);
def3=abs(con(3,:)-final);
 
confinal=[def1;def2;def3];
[f1 p1]=min(confinal(:,1));
[f2 p2]=min(confinal(:,2));
[f3 p3]=min(confinal(:,3));
[f4 p4]=min(confinal(:,4));
[f5 p5]=min(confinal(:,5));

p=[p1 p2 p3 p4 p5];
am=find(p~=1);
if(length(am)>=1)

    disp('clean');
    z='clean';
else
    disp('dirty');
    z='dirty';
end
 set(handles.result,'string',z);
 set(handles.t,'string',num2str(ob));


function result_Callback(hObject, eventdata, handles)
% hObject    handle to result (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of result as text
%        str2double(get(hObject,'String')) returns contents of result as a double


% --- Executes on button press in load_man.
function load_man_Callback(hObject, eventdata, handles)
% hObject    handle to load_man (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename,pathname] = uigetfile({'*.tif';'*.tiff';'*.jpg';'*.jpeg'});
ShowImageFile(filename,pathname,handles);





function result_woman_Callback(hObject, eventdata, handles)
% hObject    handle to result_woman (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of result_woman as text
%        str2double(get(hObject,'String')) returns contents of result_woman as a double


% --- Executes during object creation, after setting all properties.
function result_woman_CreateFcn(hObject, eventdata, handles)
% hObject    handle to result_woman (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in load_woman.
function load_woman_Callback(hObject, eventdata, handles)
% hObject    handle to load_woman (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename,pathname] = uigetfile({'*.tif';'*.tiff';'*.jpg';'*.jpeg'});
ShowImageFile_2(filename,pathname,handles);



function t_Callback(hObject, eventdata, handles)
% hObject    handle to t (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of t as text
%        str2double(get(hObject,'String')) returns contents of t as a double


% --- Executes during object creation, after setting all properties.
function t_CreateFcn(hObject, eventdata, handles)
% hObject    handle to t (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
