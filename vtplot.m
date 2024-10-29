function fig = vtplot(C,U,V)
varargin={};
% VTPLOT Plot a velocity triangle.
%   F = VTPLOT(M) returns a figure F in which the velocity triangle
%   specified by the options in m-file M has been drawn.
%
%   For details of writing an m-file, see the README.md file distributed
%   with this file.
%
%   To export the figure as an image, consider tools such as 
%   <a href="matlab:web('https://www.mathworks.com/matlabcentral/fileexchange/23629-export_fig')">export_fig on the MathWorks File Exchange</a>.

%   Copyright (c) G. Ebberson, 2019

%% Input Parameters

% Custom settings files can overwrite anything from this section.

% Absolute velocity
%C = 0.8;

% Blade speed
%U = 1;

% Relative velocity to rotor
%V = 0.8;



% Shape to use as arrowhead for vectors, as a continuous matrix of columns.
% Defaults to equilateral triangle. Should be the unit shape, pointing 
% towards vectorDirection.
vectorShape = [-0.5,0.5,0;0,0,sin(pi/3)];

% Scale of arrowhead, roughly in coordinate axes units.
vectorScale = 0.025;

% Centre of rotation of the vector arrowhead in the CSYS of arrowShape.
vectorCentre = [0;sin(pi/3)/3];

% Direction arrowShape is pointing.
vectorDirection = [0,1];



% Line thickness.
lineWidth = 2.5;

% Label interpreter.
labelInterpreter = 'latex';

% Label fontsize.
labelFontSize = 10;



% Background colour. Accepts hex string, RGB triplet, or short or long
% name strings.
backColour = 'w';

% Foreground colour. Accepts hex string, RGB triplet, or short or long 
% name strings. Used for lines and arrowheads.
foreColour = 'k';

% Label colour. Accepts hex string, RGB triplet, or short or long name
% strings.
labelColour = 'k';

% Colour of the arrows which label alpha and beta. Accepts hex string, RGB
% triplet, or short or long name strings.
angleArrowColour = 'k';

% Colour of the arcs which represent alpha and beta. Accepts hex string,
% RGB triplet, or short or long name strings.
angleArcColour = 'k';



% Label formats for everything.
lab.C = '$$C=%.2f\\;\\mathrm{ms^{-1}}$$';
lab.V = '$$V=%.2f\\;\\mathrm{ms^{-1}}$$';
lab.U = '$$U=%.2f\\;\\mathrm{ms^{-1}}$$';
lab.Vth = '$$V_{\\theta}=%.2f\\;\\mathrm{ms^{-1}}$$';
lab.Cth = '$$C_{\\theta}=%.2f\\;\\mathrm{ms^{-1}}$$';
lab.Cax = '$$C_{ax}=%.2f\\;\\mathrm{ms^{-1}}$$';
lab.a = '$$\\alpha=%.2f^{\\circ}$$';
lab.b = '$$\\beta=%.2f^{\\circ}$$';



% Label horizontal spacing, as a fraction of U.
labelHorizontalSpacing = 0.02;

% Label vertical spacing, as a fraction of Cax.
labelVerticalSpacing = 0.055;



% Label vertical alignment.
labelVerticalAlignment = 'baseline';

% Whether to label Cth 'above' or 'below'.
labelCthLocation = 'below';

% Override the internal logic and label Cax on the 'left' or 'right'. Any
% other value uses internal logic.
labelCaxLocation = '';

% Whether to label Vth 'above' or 'below'.
labelVthLocation = 'below';



% Angle arc line style, accepts any MATLAB line specifier. Does not include
% colour, which is set by angleLineColour.
angleArcStyle = '-';

% Initial and increment of radius of angles. Each angle has a radius
% slightly larger than the last to avoid confusion, starting from
% angleInitialRadius and increasing by angleRadiusStep each time. Both are
% fractions of Cax.
angleArcInitialRadius = 0.1;
angleArcRadiusStep = 0.01;

% Angle sample rate, number of points per each arc.
angleArcSampleRate = 100;



% Arrow shape for labelling arrows, rather than vectors. Should point in
% labelDirection.
angleLabelShape = [0,0.4,0,-0.4;0.2,0,1,0];

% Tip of labelShape, in the CSYS of labelShape.
angleLabelTip = [0;1];

% Direction labelShape is pointing.
angleLabelDirection = [0,1];

% Scale of the arrowhead for labels. Roughly in the coordinate axis units.
angleLabelScale = 0.01;

%% Internal Parameters

vMaj = 1; % Major version number.
vMin = 0; % Minor version number.
vPat = 0; % Patch version number.
nameStr = sprintf('%s %d.%d.%d',mfilename,vMaj,vMin,vPat);
unknownOptionStr = 'Unknown value ''%s'' for option %s.';
allowedFileExts = {'.m','.p'};

%% Input Handling

if ~isempty(varargin)
    if exist(varargin{1},'file') == 2
        [filepath,filename,fileext] = fileparts(varargin{1});
        if any(strcmp(fileext,allowedFileExts))
            run(fullfile(filepath,[filename,fileext]));
        else
            error('vtplot:badExtension',['The input file has extension '...
                '%s, but only %sor %s are allowed.'],fileext,...
                sprintf('%s, ',allowedFileExts{1:end-1}),...
                allowedFileExts{end});
        end
    else
        error('vtplot:fileDoesNotExist',['The input file ''%s'' does '...
            'not exist.'],varargin{1});
    end
end

%% Derived Parameters

% Assumes V on the left. Lowercase is the angle in rad.
[c,u,v] = sides2ang(C,U,V);

Cth = C * cos(v); % Tangential component of C
Cax = C * sin(v); % Axial component of C
alpha = pi/2 - v; % Absolute flow angle
beta = pi/2 - c;  % Relative flow angle
angleRadius = angleArcInitialRadius; % Radius to draw angle at.
Vth = U - Cth;

% Sanity check.
%assert(alpha+beta == u,'vtplot:abNotEqualToU',['Alpha and Beta do not '...
%    'sum to U.']);

%% Plotting Parameters

point1 = [0,0];         % Bottom left
point2 = [U-Cth,Cax]; % Top middle
point3 = [U,0];         % Bottom right
point4 = [U-Cth,0];  % Bottom middle

%% Plotting

% Setup and condition figure.

ax = gca;
hold on;
axis equal;
ax.XColor = 'none';
ax.YColor = 'none';
fig.Color = backColour;
ax.Color = backColour;
fig.MenuBar = 'none';

% Draw the actual triangle.
midV = addVector(ax,point2,point1);
midC = addVector(ax,point2,point3);
midCax = addVector(ax,point2,point4);
midCth = addVector(ax,point4,point3);
midVth = addVector(ax,point4,point1);
horSpace = U * labelHorizontalSpacing;
verSpace = Cax * labelVerticalSpacing;

mida = addAngle(ax,point4,point2,point3);
midb = addAngle(ax,point1,point2,point4);

% Add labelling for C and V.
text(ax,midC(1)+horSpace,midC(2),sprintf(lab.C,C),...
    'Interpreter',labelInterpreter,'FontSize',labelFontSize,...
    'Color',labelColour,'VerticalAlignment',labelVerticalAlignment,...
    'HorizontalAlignment','left');
text(ax,midV(1)-horSpace,midV(2),sprintf(lab.V,V),...
    'Interpreter',labelInterpreter,'FontSize',labelFontSize,...
    'Color',labelColour,'VerticalAlignment',labelVerticalAlignment,...
    'HorizontalAlignment','right');

% Plot and label U.
if ~isempty(lab.U)
    midU = addVector(ax,point1-[0,2*verSpace],point3-[0,2*verSpace]);
    addLine(ax,point1-[0,1.5*verSpace],point1-[0,2.5*verSpace]);
    addLine(ax,point3-[0,1.5*verSpace],point3-[0,2.5*verSpace]);
    text(midU(1),midU(2)-verSpace,sprintf(lab.U,U),...
        'Interpreter',labelInterpreter,'FontSize',labelFontSize,...
        'Color',labelColour,'VerticalAlignment',labelVerticalAlignment,...
        'HorizontalAlignment','center');
end

% Label Cth.
if strcmp(labelCthLocation,'above')
    CthSpace = verSpace;
elseif strcmp(labelCthLocation,'below')
    CthSpace = -verSpace;
else
    warning('vtplot:unknownCthLocation',unknownOptionStr,...
        labelCthLocation,'labelCthLocation');
    CthSpace = -verSpace;
end
text(ax,midCth(1),midCth(2)+CthSpace,sprintf(lab.Cth,Cth),...
    'Interpreter',labelInterpreter,'FontSize',labelFontSize,...
    'Color',labelColour,'VerticalAlignment',labelVerticalAlignment,...
    'HorizontalAlignment','center');

% Label Cax.
if strcmp(labelCaxLocation,'left') ...
        || (~strcmp(labelCaxLocation,'right') && V > C)
    textAlgn = 'right';
    CaxSpace = -horSpace;
else
    textAlgn = 'left';
    CaxSpace = horSpace;
end
text(ax,midCax(1)+CaxSpace,midCax(2),sprintf(lab.Cax,Cax),...
    'Interpreter',labelInterpreter,'FontSize',labelFontSize,...
    'Color',labelColour,'VerticalAlignment',labelVerticalAlignment,...
    'HorizontalAlignment',textAlgn);

% Label Vth.
if strcmp(labelVthLocation,'above')
    VthSpace = verSpace;
elseif strcmp(labelVthLocation,'below')
    VthSpace = -verSpace;
else
    warning('vtplot:unknownVthLocation',unknownOptionStr,...
        labelVthLocation,'labelVthLocation');
    VthSpace = -verSpace;
end
text(ax,midVth(1),midVth(2)+VthSpace,sprintf(lab.Vth,Vth),...
    'Interpreter',labelInterpreter,'FontSize',labelFontSize,...
    'Color',labelColour,'VerticalAlignment',labelVerticalAlignment,...
    'HorizontalAlignment','center');

% Label alpha.
a = (180/pi) * alpha;
addArrowLabel(ax,mida,mida+[horSpace,verSpace],sprintf(lab.a,a));

% Label beta.
b = (180/pi) * beta;
addArrowLabel(ax,midb,midb+[-horSpace,verSpace],sprintf(lab.b,b));

% Post-conditioning.
axis('tight');

% Draw the title. Disabled as I couldn't avoid overlap.
% title(ax,sprintf(lab.title,filename),'Interpreter',labelInterpreter);

%% Nested Functions

    function [A1,A2,A3] = sides2ang(a1,a2,a3)
        % Uses the cosine rule to find the angle A in rad.
        
        A1 = acos((a2^2 + a3^2 - a1^2)/(2*a2*a3));
        A2 = acos((a1^2 + a3^2 - a2^2)/(2*a1*a3));
        A3 = acos((a1^2 + a2^2 - a3^2)/(2*a1*a2));
        
        % Quick sanity check.
        %assert(A1+A2+A3 == pi,'vtplot:sides2ang:angsNotPi',...
         %   'Angles do not sum to pi.');
    end

    function [x,y] = generateArc(p1,p2,p3,rad,sam)
        % Returns the coordinates of an arc segment in p1-p2-p3, radius rad
        % and sample rate sam. Assumes p1 and p3 have -ve y.
        
        % Find the angle between the two vectors.
        v1 = p1 - p2;
        v2 = p3 - p2;
        ang = acos(dot(v1,v2)/(norm(v1)*norm(v2)));
        
        % Generate a semicircle.
        theta = linspace(-pi,0,pi*sam/ang);
        x0 = rad * cos(theta) + p2(1);
        y0 = rad * sin(theta) + p2(2);
        
        % Find the angle from +x to each v.
        arg1 = min(angle(v1(1) + v1(2)*1i),angle(v2(1) + v2(2)*1i));
        arg2 = max(angle(v1(1) + v1(2)*1i),angle(v2(1) + v2(2)*1i));
        
        
        % Find the points.
        x = x0(theta>=arg1 & theta<=arg2);
        y = y0(theta>=arg1 & theta<=arg2);
        
    end

    function addLine(ax,p1,p2)
        % Add a line to the plot, from p1 to p2.
        
        plot(ax,[p1(1),p2(1)],[p1(2),p2(2)],'-',...
            'LineWidth',lineWidth,'Color',foreColour);
        
    end

    function midpoint = addVector(ax,p1,p2)
        % Draws a line with an optional arrow at its midpoint. The arrow
        % points from p1 to p2.
        
        % Draw the line.
        addLine(ax,p1,p2);
        
        % Find the midpoint.
        midpoint = (p1 + p2)/2;
        vec = p2 - p1;
        dir = vectorDirection;
        
        % Calculate the rotation matrix.
        rotationAng = atan2(dir(1)*vec(2)-dir(2)*vec(1),...
            dir(1)*vec(1)+dir(2)*vec(2));
        rotMat = [cos(rotationAng),-sin(rotationAng);...
            sin(rotationAng),cos(rotationAng)];
        
        % Draw the arrow.
        arrow = rotMat * (vectorShape - vectorCentre) * vectorScale ...
            + midpoint';
        % Must use longhand definitions to allow hex colours.
        patch(ax,'XData',arrow(1,:),'YData',arrow(2,:),...
            'FaceColor',foreColour,'LineStyle','none');
        
    end

    function midpoint = addAngle(ax,p1,p2,p3)
        % Draws the angle p1-p2-p3. Midpoint is the centre of the sector.
        
        r = angleRadius * Cax;
        [x,y] = generateArc(p1,p2,p3,r,angleArcSampleRate);
        plot(ax,x,y,angleArcStyle,...
            'LineWidth',lineWidth,'Color',angleArcColour);
        
        % Ready for next time.
        angleRadius = angleRadius + angleArcRadiusStep;
        
        % Midpoint for labelling.
        med = [median(x),median(y)];
        centLine = p2 - med;
        midpoint = med + centLine/3;
        
    end

    function addArrowLabel(ax,p1,p2,str)
        % Adds a label at p2 with an arrow whose head is at p1 in ax. The
        % label text is str and lrStr is the text alignment.
        
        % Only draw if there is actually a label to write.
        if isempty(str)
            return;
        end
        
        plot([p1(1),p2(1)],[p1(2),p2(2)],'-','Color',angleArrowColour)
        
        % Find the midpoint.
        vec = p1 - p2;
        dir = angleLabelDirection;
        
        % Calculate the rotation matrix.
        rotationAng = atan2(dir(1)*vec(2)-dir(2)*vec(1),...
            dir(1)*vec(1)+dir(2)*vec(2));
        rotMat = [cos(rotationAng),-sin(rotationAng);...
            sin(rotationAng),cos(rotationAng)];
        
        % Draw the arrow.
        arrow = rotMat * (angleLabelShape - angleLabelTip) ...
            * angleLabelScale + p1';
        % Must use longhand definitions to allow hex colours.
        patch(ax,'XData',arrow(1,:),'YData',arrow(2,:),...
            'FaceColor',angleArrowColour,'LineStyle','none');
        
        % Work out alignment.
        if p1(1) > p2(1)
            vAl = 'middle';
            hAl = 'right';
            pad = [-labelFontSize*U/2000,0];
        elseif p1(1) < p2(1)
            vAl = 'middle';
            hAl = 'left';
            pad = [labelFontSize*U/2000,0];
        elseif p1(1) == p2(1)
            hAl = 'center';
            if p1(2) > p2(2)
                vAl = 'top';
                pad = [0,-labelFontSize*Cax/2000];
            elseif p1(2) < p2(2)
                vAl = 'bottom';
                pad = [0,labelFontSize*Cax/2000];
            end
        else
            warning('vtplot:addArrowLabel:badAlignment',...
                'Could not align text.');
            hAl = 'center';
            vAl = 'center';
            pad = [0,0];
        end
        
        % Add text.
        text(ax,p2(1)+pad(1),p2(2)+pad(2),str,'HorizontalAlignment',hAl,...
            'VerticalAlignment',vAl,'Interpreter',labelInterpreter,...
            'FontSize',labelFontSize,'Color',labelColour);
    end

end

