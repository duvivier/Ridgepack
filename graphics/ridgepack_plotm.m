function [h]=ridgepack_plotm(latitude,longitude,marker,linestyle,color,markersize)

% ridgepack_plotM - Plot points on a map axes 
%
% function [h]=ridgepack_plotm(latitude,longitude,marker,linestyle,color,markersize)
%
% Input:
% latitude   - latitude of point(s) to be plotted
% longitude  - longitude of point(s) to be plotted
% marker     - marker string such as '.' or 'o', or else 'none' (optional)
% linestyle  - line style string such as ':' or '--', or else 'none' (optional)
% color      - color string such as 'r' or 'b', or RBG vector (optional)
% markersize - markersize, in points (optional)

h=get(gcf,'CurrentAxes');

if ismap(h) 
 mstruct=gcm;
 if nargin<2
  error('Missing latitude and/or longitude')
 else
  [x,y] = mfwdtran(mstruct,latitude,longitude,h,'none');
 end
 if nargin<3
  h=plot(x,y);
 elseif nargin<4
  h=plot(x,y,'Marker',marker);
 elseif nargin<5
  h=plot(x,y,'Marker',marker,'LineStyle',linestyle);
 elseif nargin<6
  h=plot(x,y,'Color',color,'Marker',marker,'LineStyle',linestyle);
 elseif nargin==6
  h=plot(x,y,'Color',color,'Marker',marker,'LineStyle',linestyle,'MarkerSize',markersize);
 end
else
 disp('The current axes is not a map: Nothing plotted')
end

