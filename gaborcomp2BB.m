%PsychJavaTrouble;

import cog_comm_tools.*;

% Keys: Assign key names
KbName('UnifyKeyNames');
key_a=KbName('a');
key_b=KbName('b');
key_c=KbName('c');
key_d=KbName('d');
key_y=KbName('y');
key_n=KbName('n');
space=KbName('SPACE');
key_1=KbName('1!');
key_2=KbName('2@');
key_3=KbName('3#');
key_4=KbName('4$');
key_5=KbName('5%');
key_6=KbName('6^');
key_7=KbName('7&');
key_8=KbName('8*');
key_9=KbName('9(');
key_0=KbName('0)');
key_1numPad=KbName('1');
key_2numPad=KbName('2');
key_3numPad=KbName('3');
key_4numPad=KbName('4');
key_5numPad=KbName('5');
key_6numPad=KbName('6');
key_7numPad=KbName('7');
key_8numPad=KbName('8');
key_9numPad=KbName('9');
key_0numPad=KbName('0');

% setup screen and resolution
screen=max(Screen('Screens'));
oldResolution=Screen('Resolution', screen, 1024, 768);
%oldResolution=Screen('Resolution', screen, 1920, 1080);
[win, rect] = Screen('OpenWindow', screen);


[X,Y] = RectCenter(rect);
FeedbackPosition = [X,Y];
StimulusSize = [0,0,Y/2.6,Y/2.6];

smileimage = ['smile.png'];
frownimage = ['frown.png'];
smile = imread(smileimage);
frown = imread(frownimage);

%participantID = '1';
participantID=input('enter participant ID\n', 's');
trackingLog = fopen(['participants/' participantID '_eyetracking-Log.txt'],'w');


if mod(participantID,2) == 1
stimset = 1;
else
stimset = 2;
end
xlsfile = ['cb' num2str(stimset) '.xls'];
[stimdata, stimtext, stimalldata] = xlsread(xlsfile);
stimalldata(1,:)=[];

serialPort = '/dev/cu.usbserial-000013FA'; %this port can change
                                           %depending on what usb
                                           %port the box is plugged
                                           %into -- always check
                                           %that this is the port
                                           %by typing ls /dev/ | grep "cu.usbserial-" in Terminal

buttonBox = CedrusResponseBox('Open', serialPort);

% CB_APRIL_1 Gamepad('Unplug'); %CJB

%Get information on gamepad availability.
% CB_APRIL_1 gamepadIndex = Gamepad('GetNumGamepads'); %CJB
% CB_APRIL_1 gamepadName = Gamepad('GetGamepadNamesFromIndices', gamepadIndex); %CJB
% CB_APRIL_1 gamepadIndices = Gamepad('GetGamepadIndicesFromNames', gamepadName); ...
    %CJB

%Get information on gamepad configuration.
% CB_APRIL_1 numButtons = Gamepad('GetNumButtons', gamepadIndex); %CJB
% CB_APRIL_1 numAxes = Gamepad('GetNumAxes', gamepadIndex); %CJB
% CB_APRIL_1 numBalls = Gamepad('GetNumBalls', gamepadIndex); %CJB
% CB_APRIL_1 numHats = Gamepad('GetNumHats', gamepadIndex); %CJB



% format text (needs to go after 'win' is created)
%%%%%%  I DON'T THINK I NEED IT ANYMORE
%fontName = 'Arial';
%fontSize = 24;
%fontStyle = 1;
%Screen('TextFont', win, fontName);
%Screen('TextSize', win, fontSize);
%Screen('TextStyle', win ,fontStyle);

% Clear and hide mouse
initializeExperiment();


% Clear the screen after keypress
Screen(win,'FillRect', [255 255 255]);
Screen('Flip', win);

% setup screen and resolution
%screen=max(Screen('Screens'));
%oldResolution=Screen('Resolution', screen, 1024, 768);



fontFace = 'Arial';
fontSize = 30;
fontStyle = 1;

 Screen('TextFont',win, fontFace);
    Screen('TextSize',win, fontSize);
    Screen('TextStyle', win, fontStyle);    

 calibInstructions = 'We are now going to do a quick test to find out where your eyes are. Once the program has located them we will then display a series of nine red dots at different locations on the screen. Please look at each of these dots for as long as they are displayed.';
   displayInstructions(win,calibInstructions,.33,'mouse');

  %Screen('Close', win);



WaitSecs(0.5 );

 CedrusResponseBox('FlushEvents', buttonBox); % CB_APRIL_1 

waitbefore = 2;
waitCrosshair = 2;
window=win;
X=1024;
Y=768;

disp(buttonBox);

numberoftrials = 5;
tetio_init();
trackers = tetio_getTrackers();
tetio_connectTracker(trackers.ProductId);

WaitSecs(3);

for b = 1:numberoftrials

fontFace = 'Arial';
fontSize = 30;
fontStyle = 1;

disp(b)

 Screen('TextFont',win, fontFace);
    Screen('TextSize',win, fontSize);
    Screen('TextStyle', win, fontStyle);  

if b == 1
    tetio_startTracking();
instructions1 = ['You are now going to play a game in which you will be shown graphics that can be used to predict the weather. When you look at the cross in the center of the screen, an image will appear. You need to judge what you think the weather will be, given this image. If you think that it is going to rain then you should press the red button on the gamepad. If you think that it is going to be sunny then you should press the blue button on the gamepad.'];
%else

%instructions1 = ['You are once again going to play a game in which you will be shown graphics that can be used to predict the weather. When you look at the cross in the center of the screen an image will appear. You need to judge what you think the weather will be, given this image. If you think that it is going to rain then you should press the red button on the gamepad. If you think that it is going to be sunny then you should press the blue button on the gamepad.'];


  displayInstructions(win,instructions1,.33,'mouse');


instructions2 = ['You will receive feedback on your accuracy following each response. High levels of performance are possible, but initially the task may seem difficult. If you are not sure at first then you should take your best guess.'];

  displayInstructions(win,instructions2,.33,'mouse');
end  
 
startTime = GetSecs();
  

% for i = 1:2

%for b = 1:5
%

stimorder = 1:length(stimalldata(:,2));
stimorder = stimorder(randperm(length(stimorder)))';  

for j = 1: size(stimalldata,1)

% for j = 1:4

i = stimorder(j)

gaborfile = stimalldata{i,1};
target = stimalldata{i,2};

% get file names for objects
    
object1 = 'sun';
object2 = 'rain';


    fixation=imread('graphics/fixation.tif'); % it is 60x60 pixels
    x1=(1024/2)-30;
    x2=x1+60;
    y1=(768/2)-30;
    y2=y1+60;
    destRec=[x1 y1 x2 y2];
    resolution=[1024 768];

    %resolution=[1920 1080];
    %fixationTexture=Screen('MakeTexture', win, fixation);
    %Screen('DrawTexture', win, fixationTexture, [], destRec);
    %Screen('Flip',win);
    
    %X = resolution(1);
    %Y = resolution(2);
    
    %[leftEyeAll, rightEyeAll, timeStampAll]=FixationPoint(buttonBox, fixation, win, resolution, 50, destRec);
    [leftEyeAll, rightEyeAll, timeStampAll, selectedItem]=TwoPassiveFixationPointsBB(buttonBox, Stim1,Stim2,Stim3, win, resolution, 1000);

% Pictures of the objects, taken from CB file

%if left == 1
      
    Stim1 = imread(['graphics/' object1 '.jpg']);
    Stim2 = imread(['graphics/' object2 '.jpg']);
    Stim3 = imread(['graphics/Gabors/' gaborfile]);

 
    resolution=[1024 768];
    %resolution=[1920 1080];
    %fixationTexture=Screen('MakeTexture', win, fixation);
    %Screen('DrawTexture', win, fixationTexture, [], destRec);
    %Screen('Flip',win);
    
    %X = resolution(1);
    %Y = resolution(2);
startlooking = GetSecs();    
[leftEyeAll, rightEyeAll, timeStampAll, selectedItem]=TwoPassiveFixationPointsBB(buttonBox, Stim1,Stim2,Stim3, win, resolution, 1000);


% CB keepGoing = 1;
% CB while keepGoing
% CB    buttonPress = CedrusResponseBox('WaitButtonPress', buttonBox);
% CB    if ~isempty(buttonPress)& (buttonPress.button==2 | buttonPress.button==8)
 % CB       keepGoing=0;
 % CB   end % end if
% CB end % end while

finishlooking = GetSecs();    
latency = finishlooking - startlooking;
    
    disp(selectedItem);

    if selectedItem == target

      PositiveImage = Screen('MakeTexture', window, smile);
      PositiveFrame = CenterRectOnPoint(StimulusSize,FeedbackPosition(1),FeedbackPosition(2));      
      Screen('DrawTexture', window, PositiveImage, [], PositiveFrame);
   
      Screen(window, 'Flip'); 

      WaitSecs(1);
      %flip to smiley face     
    
    else
      NegativeImage = Screen('MakeTexture', window, frown);
      NegativeFrame = CenterRectOnPoint(StimulusSize,FeedbackPosition(1),FeedbackPosition(2));
      
      Screen('DrawTexture', window, NegativeImage, [], NegativeFrame);
      Screen(window, 'Flip');
      %flip to frowney face
    WaitSecs(1);
    end

    nrows=size(leftEyeAll,1);
    for i=1:nrows
	    fprintf(trackingLog,['%s\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%s\t%d\t%d\t%d\n'], leftEyeAll(i,1), leftEyeAll(i,2),leftEyeAll(i,3),leftEyeAll(i,4),leftEyeAll(i,5),leftEyeAll(i,6),leftEyeAll(i,7),leftEyeAll(i,8),leftEyeAll(i,9),leftEyeAll(i,10),leftEyeAll(i,11),leftEyeAll(i,12),leftEyeAll(i,13),rightEyeAll(i,1),rightEyeAll(i,2),rightEyeAll(i,3),rightEyeAll(i,4),rightEyeAll(i,5),rightEyeAll(i,6),rightEyeAll(i,7),rightEyeAll(i,8),rightEyeAll(i,9),rightEyeAll(i,10),rightEyeAll(i,11),rightEyeAll(i,12),rightEyeAll(i,13),b,j,timeStampAll(i),gaborfile,target,selectedItem,latency);
    end

end
 tetio_stopTracking();


% if b < numberoftrials - 1
fontFace = 'Arial';
fontSize = 30;
fontStyle = 1;

 Screen('TextFont',win, fontFace);
    Screen('TextSize',win, fontSize);
    Screen('TextStyle', win, fontStyle);  

breakinstructions = 'You may now take a short break if you wish to. When you are ready to continue with the experiment please press any button on the mouse. After a 2 second delay the procedure will continue';

      displayInstructions(win,breakinstructions,.33,'mouse');
     Screen('Flip',window);
     WaitSecs(2); 
% end
end





clear all
%tetio_stopTracking;
%shutDownExperiment();
% calling function for the different groups



