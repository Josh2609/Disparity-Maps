function varargout = DisparityGUI(varargin)
% DISPARITYGUI MATLAB code for DisparityGUI.fig
%      DISPARITYGUI, by itself, creates a new DISPARITYGUI or raises the existing
%      singleton*.
%
%      H = DISPARITYGUI returns the handle to a new DISPARITYGUI or the handle to
%      the existing singleton*.
%
%      DISPARITYGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DISPARITYGUI.M with the given input arguments.
%
%      DISPARITYGUI('Property','Value',...) creates a new DISPARITYGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before DisparityGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to DisparityGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help DisparityGUI

% Last Modified by GUIDE v2.5 28-Mar-2018 18:45:45

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @DisparityGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @DisparityGUI_OutputFcn, ...
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


% --- Executes just before DisparityGUI is made visible.
function DisparityGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to DisparityGUI (see VARARGIN)

% Choose default command line output for DisparityGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes DisparityGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);

global suppX suppY searchX searchY
suppX = 2;
suppY = 2;
searchX = 10;
searchY = 10;


% --- Outputs from this function are returned to the command line.
function varargout = DisparityGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;




% --- Executes on button press in option1.
function option1_Callback(hObject, eventdata, handles)
% hObject    handle to option1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of option1


% --- Executes on button press in option2.
function option2_Callback(hObject, eventdata, handles)
% hObject    handle to option2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of option2


% --- Executes on button press in option3.
function option3_Callback(hObject, eventdata, handles)
% hObject    handle to option3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of option3


% --- Executes on button press in option4.
function option4_Callback(hObject, eventdata, handles)
% hObject    handle to option4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of option4


% --- Executes on button press in StartButton.
function StartButton_Callback(hObject, eventdata, handles)
% hObject    handle to StartButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global left_file_path right_file_path suppX suppY searchX searchY
disp("suppX: " + suppX + " | suppY: " + suppY); 
[dm] = DisparityCalc(left_file_path, right_file_path, suppX, suppY, searchX, searchY);
axes(handles.axes3);
imagesc(dm);
colormap(gray);
colorbar
hold on;



% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over LoadImage1.
function LoadImage1_Callback(hObject, eventdata, handles)
% hObject    handle to LoadImage1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[file,path] = uigetfile('*.bmp;*.jpg;*.png');
global left_file_path
left_file_path = [path file];
left_image = imread(left_file_path);
axes(handles.axes1);
imshow(left_image);


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over LoadImage1.
function LoadImage2_Callback(hObject, eventdata, handles)
% hObject    handle to LoadImage1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[file,path] = uigetfile('*.bmp;*.jpg;*.png');
global right_file_path
right_file_path = [path file];
right_image = imread(right_file_path);
axes(handles.axes2);
imshow(right_image);



function searchY_Callback(hObject, eventdata, handles)
% hObject    handle to searchY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of searchY as text
%        str2double(get(hObject,'String')) returns contents of searchY as a double
global searchY
searchY = str2double(get(hObject,'String'));
% if searchY > 3
%     searchY = ((searchY- 1)/2);
% end


% --- Executes during object creation, after setting all properties.
function searchY_CreateFcn(hObject, eventdata, handles)
% hObject    handle to searchY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function searchX_Callback(hObject, eventdata, handles)
% hObject    handle to searchX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of searchX as text
%        str2double(get(hObject,'String')) returns contents of searchX as a double
global searchX
searchX = str2double(get(hObject,'String'));
% if searchX > 3
%     searchX = ((searchX- 1)/2);
% end


% --- Executes during object creation, after setting all properties.
function searchX_CreateFcn(hObject, eventdata, handles)
% hObject    handle to searchX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function suppX_Callback(hObject, eventdata, handles)
% hObject    handle to suppX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of suppX as text
%        str2double(get(hObject,'String')) returns contents of suppX as a double
global suppX
suppX = str2double(get(hObject,'String'));
% if suppX > 3
%     suppX = ((suppX- 1)/2);
% end


% --- Executes during object creation, after setting all properties.
function suppX_CreateFcn(hObject, eventdata, handles)
% hObject    handle to suppX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function suppY_Callback(hObject, eventdata, handles)
% hObject    handle to suppY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of suppY as text
%        str2double(get(hObject,'String')) returns contents of suppY as a double
global suppY
suppY = str2double(get(hObject,'String'));
% if suppY > 3
%     suppY = ((suppY- 1)/2);
% end


% --- Executes during object creation, after setting all properties.
function suppY_CreateFcn(hObject, eventdata, handles)
% hObject    handle to suppY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
