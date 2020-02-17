%% EN2106

studentName = 'xxxxxxx'; 
studentEmail = 'xxxxxx@cardiff.ac.uk';   
studentID = 000000;        

%% Exploring motion-capture data of a tennis player making 5 racket swings.

clear
close all

%%  Loads in the data: (randomly altered depending on studentID)

try
    markerCoords = loadMarkerData(studentID);
    [nT, nM, nX] = size(markerCoords);
    close all
catch
    error(['Error reading data! \n- do you have both files:' ...
        '''EN2106_coursework_data.bin'' and ''loadMarkerData.p'' in the same folder as this script?'],1)
end

% dataset is originally from http://mocapdata.com/
%   This motion capture data is licensed by mocapdata.com, Eyes, JAPAN Co. Ltd. under the Creative Commons Attribution 2.1 Japan License.
%   To view a copy of this license, contact mocapdata.com, Eyes, JAPAN Co. Ltd. or visit http://creativecommons.org/licenses/by/2.1/jp/ .
%   http://mocapdata.com/
%   (C) Copyright Eyes, JAPAN Co. Ltd. 2008-2009.


%% Basic 3D plot of marker data
% Plots the locations of the markerCoords at time point 1

% For the variable 'markerCoords', a 3D-matrix of dimensions 3000x22x3:
% First dimension - time (3000 points), the sampling rate is 120 Hz 
% Second dimension - marker number 
%                    There are 22 markers, and their order is randomised
%                    based on the studentID
% Third dimension - Spatial coordinates - the three numbers are the x, y
%                   and z coordinates of each marker at each time point -
%                   in units of mm


iT = 1; % chooses just the first time-point 

figure(2) 
clf       

% plots each marker with a red x:
plot3(markerCoords(iT,:,1), markerCoords(iT,:,2), markerCoords(iT,:,3),'rx')

for iM = 1:nM % loops through all markers        
    
    % adds text to the 3D plot corresponding to marker number, 2cm to the
    % right (increased x) of each red x:
    text(markerCoords(iT,iM,1)+20,markerCoords(iT,iM,2),markerCoords(iT,iM,3), num2str(iM))
end

axis equal % tells MATLAB that the dimensions in x, y and z are all equivalent lengths in real space 
axis vis3d % makes the plot easier to view when rotating in 3D

% Join body parts together

sBody.iLegL = [22 1 6 2]; 
sBody.iLegR = [16 7 20 21];
sBody.iArmL = [14 13 9 19];
sBody.iArmR = [15 4 10 5 8 18 5]; 
sBody.iHead = [11 3 12 17 11]; 
sBody.iTorso = [2 21 15 19 2];

if exist('plotBody','file')
    iT = 1;
    figure(3) 
    clf
    plot3(markerCoords(iT,:,1),markerCoords(iT,:,2),markerCoords(iT,:,3),'rx','MarkerSize',10,'linewidth',3)
    hold on
    plotBody(iT,markerCoords,sBody) % plots the lines to join the markers
                                  
    axis equal
    axis vis3d

else
    error(['Error: the provided file ''%s'' was not found.' ...
           '\n       Make sure you put it in the same folder as this script.'],'plotBody.m');
end




%% Create visualisation

% Finds the min and max values of x, y and z in markerCoords to be able to
% set the limits for the axes of the 3D plot correctly:
xmin = min(min(markerCoords(:,:,1))); ymin = min(min(markerCoords(:,:,2))); zmin = min(min(markerCoords(:,:,3)));
xmax = max(max(markerCoords(:,:,1))); ymax = max(max(markerCoords(:,:,2))); zmax = max(max(markerCoords(:,:,3)));

figure(4) 

for iT = 1:15:750 

    clf
    plot3(markerCoords(iT,:,1),markerCoords(iT,:,2),markerCoords(iT,:,3),'rx')
    hold on
    plotBody(iT,markerCoords,sBody)
    axis([xmin xmax ymin ymax zmin zmax]) 
    view([-30 45]) % chooses a particular viewing angle for the 3D plot
    drawnow
end



% identify the index of the marker corresponding to the racket head and plot the racket position
iRacket = find(markerCoords(1,:,1)==max(markerCoords(1,:,1))); % <-- identifies the index of the right-most marker in time-frame 1, the racket head
racketPosition = squeeze(markerCoords(:,iRacket,:));
figure(5)
clf
plot(racketPosition)
legend('x','y','z')
xlabel('Time frame number')
ylabel('Position / mm')
title('Position of racket head over time')

%% Plot the speed and acceleration over time of the racket head

Deltat = 1/120; % the time between each image capture in seconds.
endTime = 3000*Deltat; % the time at the last image capture in seconds.
t = Deltat:Deltat:endTime; % time vector (in seconds) corresponding to 3000 time points, starting at the first time point.

xPosition = racketPosition(:,1); % x-coordinates of position in mm.
yPosition = racketPosition(:,2); % y-coordinates of position in mm.
zPosition = racketPosition(:,3); % z-coordinates of position in mm.

% velocity is calculated using the gradient function to find the difference
% between subsequent values of position and then dividing this by Deltat as
% v = dx/dt
xVelocity = gradient(xPosition)/Deltat;% x-component of velocity in mm/s
yVelocity = gradient(yPosition)/Deltat;% y-component of velocity in mm/s
zVelocity = gradient(zPosition)/Deltat;% z-component of velocity in mm/s

speed = sqrt((xVelocity).^2 + (yVelocity).^2 + (zVelocity).^2); % vector addition of velocity components to get scalar value in mm/s
acceleration = gradient(speed)/Deltat; % scalar value of acceleration of racket head in mm/s/s

figure(6)
subplot(211)
plot(t,speed/1000, 'LineWidth',2) % plot of racket head speed vs time, dividing by 1000 to convert to m/s.
grid on
title('Racket Head Speed vs Time')
xlabel('Time (secs)')
ylabel('Racket Head Speed (m/s)')


subplot(212)
plot(t,acceleration/1000,'LineWidth',2) % plot of racket head acceleration vs time, dividing by 1000 to convert to m/s/s.
grid on
title('Racket Head Acceleration vs Time')
xlabel('Time (secs)')
ylabel('Racket Head Acceleration (m/s/s)')
ylim([-200 200]) % setting the limits of y-axis to produce a plot that looks more like the example.


%%  Finding peak racket speed

mms2kmh = 3.6/1000; % conversion factor to convert mm/s to km/h
indexmax = find(max(speed) == speed); % index to find the maximum speed.
maxSpeed_kmh = speed(indexmax)*mms2kmh; % maximum speed of racket head, converted to km/h.


disp(['Max racket speed: ' num2str(maxSpeed_kmh) ' km/h'])


%% Plotting all 5 strokes on top of each other for comparison

tPeaks = [4.33 7.72 11.21 14.41 17.77]; % time of each ball strike in seconds

t_s = linspace(-1,1,241); % time vector representing the time period of 1 second before and after ball strike
    
s_1 = speed(round((tPeaks(1)-1)/Deltat):round((tPeaks(1)+1)/Deltat)); % speed of racket head over time period t_s (in mm/s).
s_2 = speed(round((tPeaks(2)-1)/Deltat):round((tPeaks(2)+1)/Deltat)); % round function used to round tPeaks to nearest integer as MATLAB indexing requires integer values.
s_3 = speed(round((tPeaks(3)-1)/Deltat):round((tPeaks(3)+1)/Deltat));
s_4 = speed(round((tPeaks(4)-1)/Deltat):round((tPeaks(4)+1)/Deltat));
s_5 = speed(round((tPeaks(5)-1)/Deltat):round((tPeaks(5)+1)/Deltat));

figure(7)
plot(t_s,s_1/1000,'LineWidth',3) % plot of 1st strike, divided by 1000 to covert to m/s.
grid on
title('Racket Speed vs Time for 5 ball strikes')
xlabel('Time (secs)')
ylabel('Racket Speed (m/s)')

hold on % hold function used to plot the remaining strikes on top of the first.

plot(t_s,s_2/1000,'LineWidth',3)% plot of 2nd strike, divided by 1000 to covert to m/s.
plot(t_s,s_3/1000,'LineWidth',3)% plot of 3rd strike, divided by 1000 to covert to m/s.
plot(t_s,s_4/1000,'LineWidth',3)% plot of 4th strike, divided by 1000 to covert to m/s.
plot(t_s,s_5/1000,'LineWidth',3)% plot of 5th strike, divided by 1000 to covert to m/s.
legend('Strike 1','Strike 2', 'Strike 3', 'Strike 4','Strike 5') 

%% Visualisation of the 3D trajectory of the racket head over time

figure(8)
clf
plot3(xPosition,yPosition,zPosition,'-x') % 3d plot of the racket head position (in mm).

xlabel('x (mm)')
ylabel('y (mm)')
zlabel('z (mm)')
title('3D Position of Racket Head over time')

hold on

% for loop used to plot a red x at the point of racket strikes 1 to 5.
for i = 1:5 
    t(i) = round(tPeaks(i)/Deltat,0); % round function used to round result to integer nearest to the time at which ball is struck.
    plot3(xPosition(t(i)),yPosition(t(i)),zPosition(t(i)),'rx','MarkerSize',20,'LineWidth',2)
end

% text function used to assign a label to each strike
text(xPosition(t(1)),yPosition(t(1)),zPosition(t(1)),'1','FontSize',16) 
text(xPosition(t(2)),yPosition(t(2)),zPosition(t(2)),'2','FontSize',16)
text(xPosition(t(3)),yPosition(t(3)),zPosition(t(3)),'3','FontSize',16)
text(xPosition(t(4)),yPosition(t(4)),zPosition(t(4)),'4','FontSize',16)
text(xPosition(t(5)),yPosition(t(5)),zPosition(t(5)),'5','FontSize',16)

az = 50; 
el = 36;
view(az,el) % view function used to assign azimuth and elevation values which would make the red markers easier to see. 

figh = figure(8);
plot(1:10,1:10)
pos = get(figh,'position');
set(figh,'position',[pos(1:2)/4 pos(3:4)*1.8]) % set function used to change the size of the figure window 8 so that it is clear when coverted to pdf.