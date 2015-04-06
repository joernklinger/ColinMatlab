function [leftEyeAll, rightEyeAll, timeStampAll, selectedItem] = TwoFixationPointsBB(buttonBox, fixation1, fixation2, gabor, win, resolution, sampleNum)

%  [leftEyeAll, rightEyeAll, timeStampAll]=FixationPoint(buttonBox, fixation, win, resolution, 50, destRec);

% FIXATIONPOINT displays an image as a fixaxtion point until the eye
% fixates it as indicated by a specific number of consecutive eye traking
% samples corresponding to its location on the screen.
%
%   INPUT:
%         path = the path to the image to use
%         win = the pointer to the display window
%         resolution = screen resolution (e.g. resolution=[1024 768];)
%         sampleNum = number of consecutive eye tracking samples to take
%         destRec = destination coordinates [x1 y1 x2 y2] in pixels
%
%   OUTPUT:
%         leftEyeAll: EyeArray corresponding to the left eye.
%         rightEyeAll:EyeArray corresponding to the right eye.
%         timeStampAll : timestamp of the readings
%
%   NOTE: if destReac is not provided it will show the image centered on
%         the screen
%
%   Written by: Luis Chacartegui and Colin Bannard
%   Updated: Sep, 2013

    
% eyetracking gaze data
x = resolution(1);
y = resolution(2);

 buttonPress = CedrusResponseBox('GetButtons', buttonBox);
      while ~isempty(buttonPress)
        CedrusResponseBox('FlushEvents',buttonBox);     
        buttonPress = [];
      end;

% CB_APRIL_1 Gamepad('Unplug'); %CJB

%Get information on gamepad availability.
% CB_APRIL_1  gamepadIndex = Gamepad('GetNumGamepads'); %CJB
% CB_APRIL_1  gamepadName = Gamepad('GetGamepadNamesFromIndices', gamepadIndex); %CJB
% CB_APRIL_1  gamepadIndices = Gamepad('GetGamepadIndicesFromNames', gamepadName); ...
    

%Get information on gamepad configuration.
% CB_APRIL_1  numButtons = Gamepad('GetNumButtons', gamepadIndex); %CJB
% CB_APRIL_1  numAxes = Gamepad('GetNumAxes', gamepadIndex); %CJB
% CB_APRIL_1  numBalls = Gamepad('GetNumBalls', gamepadIndex); %CJB
% CB_APRIL_1  numHats = Gamepad('GetNumHats', gamepadIndex); %CJB


    centerRec=[(x/2)-(size(gabor,2)/2) (y/2)-(size(gabor,1)/2) (x/2)+(size(gabor,2)/2) (y/2)+(size(gabor,1)/2)];
    destRec1=[(x/8)-(size(fixation1,2)/2) (y/2)-(size(fixation1,1)/2) (x/8)+(size(fixation1,2)/2) (y/2)+(size(fixation1,1)/2)];
    destRec2=[(7*(x/8))-(size(fixation2,2)/2) (y/2)-(size(fixation2,1)/2) (7*(x/8))+(size(fixation2,2)/2) (y/2)+(size(fixation2,1)/2)];

% Generate matrix with x=numSamples of 'ones' to compare to historyInRange
      sampleMatrix=ones(1,sampleNum);

% gets proportions from pixels

Proportions1 = [destRec1(1)/x, destRec1(2)/y, destRec1(3)/x, destRec1(4)/y];

X1Start=Proportions1(1)-0.05;
Y1Start=Proportions1(2)-0.05;
X1Finish=Proportions1(3)+0.05;
Y1Finish=Proportions1(4)+0.05;

Proportions2 = [destRec2(1)/x, destRec2(2)/y, destRec2(3)/x, destRec2(4)/y];

X2Start=Proportions2(1)-0.05;
Y2Start=Proportions2(2)-0.05;
X2Finish=Proportions2(3)+0.05;
Y2Finish=Proportions2(4)+0.05;

% Initialize containers
leftEyeAll = [];
rightEyeAll = [];
timeStampAll = [];
inRange=[];
historyInRange=[];

% dislay fixation image

%LeftStimFrame2 = CenterRectOnPoint(StimulusSize1,LeftPosition2(1),LeftPosition2(2));
%RightStimFrame2 = CenterRectOnPoint(StimulusSize1,RightPosition2(1),RightPosition2(2));    

fixation1Texture=Screen('MakeTexture', win, fixation1);
fixation2Texture=Screen('MakeTexture', win, fixation2);
gaborTexture=Screen('MakeTexture', win, gabor);
Screen('DrawTexture', win, fixation1Texture, [], destRec1);
Screen('DrawTexture', win, fixation2Texture, [], destRec2);
Screen('DrawTexture', win, gaborTexture, [], centerRec);
Screen('Flip',win);
counter = 0;
collecting=1;
while collecting
counter = counter+1;    
    [lefteye, righteye, timestamp, trigSignal] = tetio_readGazeData;
[X,Y] =   GetMouse();
mousepoints(counter,1) = X/x; 
mousepoints(counter,2) = Y/y; 

disp(X);
disp(Y);

    % check that the sample is valid (not empty and participant is looking
    % inside the area of the image)
      for i=1:size(mousepoints,1)
%     for i=1:size(lefteye,1)
      %  if lefteye(i,1)~=0 && lefteye(i,7)> X1Start && lefteye(i,7) < X1Finish && lefteye(i,8)> Y1Start && lefteye(i,8)< Y1Finish
      if mousepoints(i,1) > X1Start && mousepoints(i,1) < X1Finish && mousepoints(i,2) > Y1Start && mousepoints(i,2) < Y1Finish

            inRange=1;
            selectedItem = 1; 
%clear all;

%        elseif lefteye(i,1)~=0 && lefteye(i,7)> X2Start && lefteye(i,7) < X2Finish && lefteye(i,8)> Y2Start && lefteye(i,8)< Y2Finish
       elseif mousepoints(i,1) > X2Start && mousepoints(i,1) < X2Finish && mousepoints(i,2) > Y2Start && mousepoints(i,2) < Y2Finish
            inRange=1;
selectedItem = 2; 
%clear all;
   %     elseif ~(lefteye(i,1)~=0 && lefteye(i,7)> X1Start && lefteye(i,7) < X1Finish && lefteye(i,8)> Y1Start && lefteye(i,8)< Y1Finish)
   elseif mousepoints(i,1) > X1Start && mousepoints(i,1) < X1Finish && mousepoints(i,2) > Y1Start &&  mousepoints(i,2) < Y1Finish


            inRange=0;
%clear all;
       % elseif ~(lefteye(i,1)~=0 && lefteye(i,7)> X2Start && lefteye(i,7) < X2Finish && lefteye(i,8)> Y2Start && lefteye(i,8)< Y2Finish)
        elseif mousepoints(i,1) > X2Start && mousepoints(i,1) < X2Finish && mousepoints(i,2) > Y2Start && mousepoints(i,2) < Y2Finish
        inRange=0;
 %       clear all;
        end
    end
    
    % accumulate
    % numGazeData = size(lefteye, 2);
    %leftEyeAll = vertcat(leftEyeAll, lefteye(:, 1:numGazeData));
    % % rightEyeAll = vertcat(rightEyeAll, righteye(:, 1:numGazeData));
    % timeStampAll = vertcat(timeStampAll, timestamp(:,1));
    historyInRange=[historyInRange inRange];
    
    % break when we have x=sampleNum consecutive valid samples
   % if length(historyInRange)>sampleNum && isequal(historyInRange(end-(sampleNum-1):end), sampleMatrix)


% CB_APRIL_1      buttonStateleft = Gamepad('GetButton', gamepadIndex, 1); %CJB
% CB_APRIL_1     buttonStatebottom = Gamepad('GetButton', gamepadIndex, 2); %CJB
% CB_APRIL_1     buttonStateright = Gamepad('GetButton', gamepadIndex, 3); %CJB
% CB_APRIL_1     buttonStatetop = Gamepad('GetButton', gamepadIndex, 4); %CJB

% CB_APRIL_1     if buttonStateleft == 1 || buttonStateright == 1  || buttonStatebottom == 1 || buttonStatetop == 1 

% CB_APRIL_1       if buttonStateleft == 1
% CB_APRIL_1          selectedItem = 1;
% CB_APRIL_1          collecting=0;
% CB_APRIL_1       elseif buttonStateright == 1
% CB_APRIL_1          selectedItem = 2;
% CB_APRIL_1          collecting=0;
% CB_APRIL_1       end
      
  % CB_APRIL_1  end

      buttonPress = CedrusResponseBox('WaitButtonPress', buttonBox);
    if ~isempty(buttonPress) & (buttonPress.button==2 | buttonPress.button==8)
    if strcmp(buttonPress.buttonID, '7.Left') %the green button

                  selecteditem = 1;
              elseif strcmp(buttonPress.buttonID, '1.Left') %the
                                                             %red
                    selecteditem = 2;                                         %button
		collecting=0;
             end
	end
% CB_APRIL_1      if(counter > sampleNum)  
% CB_APRIL_1	collecting=0;
% CB_APRIL_1 disp(mousepoints);
%clear all;
% CB_APRIL_1    end
    
end

end



