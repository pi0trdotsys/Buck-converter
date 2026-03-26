clear all;
close all;
clc;

%% 1. Projekt anteny i podgląd bazowy
antennaObject = design(invertedFcoplanar, 2.450e9);
freqRange = linspace(2.0, 3.0, 10) * 1e9;

figure;
show(antennaObject);
title('Antena – geometria bazowa');

figure;
s = sparameters(antennaObject, freqRange, 50);
rfplot(s);
title('S-parametry – model uproszczony');

%% 2. Stos PCB z materiałami
MyAnt = pcbStack(antennaObject);
MyAnt.BoardThickness = 1.035e-3;

Cu = metal('Copper');
Cu.Thickness = 35e-6;
MyAnt.Conductor = Cu;

Core = dielectric('FR4');
Core.EpsilonR    = 4.5;
Core.LossTangent = 0.026;
Core.Thickness   = 1.035e-3;
MyAnt.Layers{2}  = Core;

MyAnt.BoardShape = antenna.Rectangle( ...
    "Length", antennaObject.GroundPlaneLength, ...
    "Width",  antennaObject.GroundPlaneWidth + 2*antennaObject.Height, ...
    "Center", [0, antennaObject.Height]);

figure;
show(MyAnt);
title('PCB – geometria z materiałami');

figure;
s = sparameters(MyAnt, freqRange, 50);
rfplot(s);
title('S-parametry – PCB z materiałami');

%% 3. Skalowanie geometrii do 2.45 GHz
scale = 2.45 / 3;

antennaObject.RadiatorArmWidth  = antennaObject.RadiatorArmWidth  / scale;
antennaObject.FeederArmWidth    = antennaObject.FeederArmWidth    / scale;
antennaObject.ShortingArmWidth  = antennaObject.ShortingArmWidth  / scale;
antennaObject.LengthToOpenEnd   = antennaObject.LengthToOpenEnd   / scale;
antennaObject.LengthToShortEnd  = antennaObject.LengthToShortEnd  / scale;

% Pozostałe właściwości geometryczne invertedFcoplanar do przeskalowania:
antennaObject.GroundPlaneLength = antennaObject.GroundPlaneLength / scale;
antennaObject.GroundPlaneWidth  = antennaObject.GroundPlaneWidth  / scale;
antennaObject.Height            = antennaObject.Height            / scale;

% Odświeżenie stosu PCB po zmianie geometrii anteny
MyAnt = pcbStack(antennaObject);
MyAnt.BoardThickness = 1.035e-3;
MyAnt.Conductor      = Cu;
MyAnt.Layers{2}      = Core;
MyAnt.BoardShape = antenna.Rectangle( ...
    "Length", antennaObject.GroundPlaneLength, ...
    "Width",  antennaObject.GroundPlaneWidth + 2*antennaObject.Height, ...
    "Center", [0, antennaObject.Height]);

figure;
show(MyAnt);
title('PCB – po skalowaniu');

figure;
s = sparameters(MyAnt, freqRange, 50);
rfplot(s);
title('S-parametry – po skalowaniu');

%% 4. Impedancja i diagram promieniowania
figure;
impedance(MyAnt, freqRange);
title('Impedancja wejściowa');

figure;
pattern(MyAnt, 2.45e9, Type="gain");
title('Diagram promieniowania – zysk @ 2.45 GHz');