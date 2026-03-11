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

myAnt = pcStack(antennaObject);
myAnt.BoardThickness = 1.035e-3;

Cu = metal('Copper');
Cu.Thickness = 35e-6;
myAnt.Conductor = Cu;

Core = dielectric('FR4');
Core.EpsilonR = 4.5;
Core.LossTangent = 0.026;
Core.Thickness = 1e-3;
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
antennaObject. = antennaObject./scale;
antennaObject. = antennaObject./scale;
antennaObject. = antennaObject./scale;

figure;
show(myAnt);

figure;
s = sparameters(myAnt,freqRange,50);
rfplot(s)  % pattern

% impedance
figure;
impedance(myAnt,freqRange);

pattern(myAnt,2.45e9,Type="gain");

% help matlab
% apps antena design