clear all;
close all;
clc;

antennaObject = design(invertedFcoplanar, 2.450*1e9);
freqRange = linspace(2.0, 3.0, 10) * 1e9;

figure;
show(antennaObject);

figure;
s = sparameters(antennaObject, freqRange, 50);
rfplot(s) %pattern

MyAnt = pcbStack(antennaObject);
MyAnt.BoardThickness = 1.035e-3;

Cu = metal('Copper');
Cu.Thickness = 35e-6;
MyAnt.Conductor = Cu;

Core = dielectric('FR4');
Core.EpsilonR = 4.5;
Core.LossTangent = 0.026;
Core.Thickness = 1.035e-3;
MyAnt.Layers{2} = Core;

MyAnt.BoardShape = antenna.Rectangle("Length",antennaObject.GroundPlaneLength,"Width",antennaObject.GroundPlaneLength+2*antennaObject.Height,"Center", [0 antennaObject.Height]);

figure;
show(MyAnt);

figure;
s = sparameters(MyAnt, freqRange, 50);
rfplot(s) %pattern

scale = 2.45/3;
antennaObject.RadiatorArmWidth = antennaObject.RadiatorArmWidth/scale;
antennaObject.FeederArmWidth = antennaObject.FeederArmWidth/scale;
antennaObject.ShortingArmWidth = antennaObject.ShortingArmWidth/scale;
antennaObject.LengthToOpenEnd = antennaObject.LengthToOpenEnd/scale;
antennaObject.LengthToShortEnd = antennaObject.LengthToShortEnd/scale;
antennaObject.Height            = antennaObject.Height/scale;
antennaObject.GroundPlaneLength = antennaObject.GroundPlaneLength/scale;
antennaObject.GroundPlaneWidth  = antennaObject.GroundPlaneWidth/scale;
figure;
show(MyAnt);

figure;
s = sparameters(MyAnt,freqRange,50);
rfplot(s)  % pattern

% impedance
figure;
impedance(MyAnt,freqRange);

pattern(MyAnt,2.45e9,Type="gain");

% help matlab
% apps antena design