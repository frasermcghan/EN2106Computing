function plotBody(iT,markerCoords,sBody)
% function plotBody(iT,markerCoords,sBody)
%
%
% This function plots the body of the subject who was motion-captured by
% joining together the markers specified by the 'struct' sBody. You can
% specify the particular time index to plot with iT and markerCoords is the
% raw 3D matrix read-in from the file.

hold on
lstyle = {'linewidth',2,'color','b','linestyle','-'};
plot3(markerCoords(iT,sBody.iLegL,1),markerCoords(iT,sBody.iLegL,2),markerCoords(iT,sBody.iLegL,3),lstyle{:});
plot3(markerCoords(iT,sBody.iLegR,1),markerCoords(iT,sBody.iLegR,2),markerCoords(iT,sBody.iLegR,3),lstyle{:});
plot3(markerCoords(iT,sBody.iArmL,1),markerCoords(iT,sBody.iArmL,2),markerCoords(iT,sBody.iArmL,3),lstyle{:});
plot3(markerCoords(iT,sBody.iArmR,1),markerCoords(iT,sBody.iArmR,2),markerCoords(iT,sBody.iArmR,3),lstyle{:});
plot3(markerCoords(iT,sBody.iHead,1),markerCoords(iT,sBody.iHead,2),markerCoords(iT,sBody.iHead,3),lstyle{:});
plot3(markerCoords(iT,sBody.iTorso,1),markerCoords(iT,sBody.iTorso,2),markerCoords(iT,sBody.iTorso,3),lstyle{:});


