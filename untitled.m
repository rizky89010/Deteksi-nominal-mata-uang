function varargout = crop(varargin)
% CROP MATLAB code for crop.fig
%      CROP, by itself, creates a new CROP or raises the existing
%      singleton*.
%
%      H = CROP returns the handle to a new CROP or the handle to
%      the existing singleton*.
%
%      CROP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CROP.M with the given input arguments.
%
%      CROP('Property','Value',...) creates a new CROP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before crop_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to crop_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help crop

% Last Modified by GUIDE v2.5 01-May-2020 20:22:37

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @crop_OpeningFcn, ...
                   'gui_OutputFcn',  @crop_OutputFcn, ...
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


% --- Executes just before crop is made visible.
function crop_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to crop (see VARARGIN)

% Choose default command line output for crop
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes crop wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = crop_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
open=guidata(gcbo);
[namafile,direktori]=uigetfile({'*.jpg;*.bmp;*.tif;*.png;*.jpeg'},'OpenImage');
I=imread(namafile);
set(open.figure1,'CurrentAxes',open.axes1);
set(imagesc(I));colormap('gray');
set(open.axes1,'Userdata',I);
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
clear all;
open=guidata(gcbo);
I=get(open.axes1,'Userdata');
K = imcrop(I, [10 -20 140 150]);
set(open.figure1,'CurrentAxes',open.axes2);
set(imagesc(K));
set(open.axes2,'Userdata',K);
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
clear all;
open=guidata(gcbo);
I=get(open.axes1,'Userdata');

gray = rgb2gray(I);% mengubah gambar yang dimasukkan menjadi grayscale
tr = imbinarize(gray,graythresh(gray));% mengkonversi citra grayscale menjadi biner
tr = imcomplement(tr);% melakukan komplemen citra agar objek bernilai satu dan background bernilai nol
tr = bwareaopen(tr,100);

% filling holes untuk mengisi objek yang berlubang
tr = imfill(tr,'holes');
str = strel('disk',5);
tr = imclose(tr,str);
% menghilangkan objek yang menempel pada border (tepian citra)
tr = imclearborder(tr);



[A,B] = bwlabel(tr);% pelabelan terhadap masing2 objek
% menghitung luas dan centroid objek
stats = regionprops(A,'All');
centroid = stats.Centroid;
luas = stats.Area;
disp(luas);

% mengkonversi citra rgb menjadi YCbCr
YCbCr = rgb2ycbcr(I);
% mengekstrak komponen Cb (Chrominance-blue)
Cb = YCbCr(:,:,2);
kata = 'Dengan Luas'; 

% menampilkan gambar pada GUI yang telah dibuat
set(open.figure1,'CurrentAxes',open.axes2);
set(imagesc(I));
set(open.axes2,'Userdata',I);
text(centroid(1)+130,centroid(2)+230,num2str(luas),'Color','w','FontSize',15,'FontWeight','bold')
hold on
boundaries = bwboundaries(tr,'noholes');
boundary = boundaries{1};
%kondisi untuk memberikan nominal pada uang yg dideteksi
if luas<18000 nilai = 'ini adalah uang 100' ;
elseif luas<23000 nilai = 'ini adalah uang 200' ;
elseif luas<39000 nilai = 'ini adalah uang 1000' ;
elseif luas<62000 nilai = 'ini adalah uang 500';

end
%Setting label pada hasil dan setting garis pada boundary
plot(boundary(:,2), boundary(:,1), 'b', 'LineWidth', 2);
text(centroid(1)-190,centroid(2)+180,num2str(nilai),'Color','w','FontSize',15,'FontWeight','bold');
text(centroid(1)-190,centroid(2)+230,num2str(kata),'Color','w','FontSize',15,'FontWeight','bold');
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
