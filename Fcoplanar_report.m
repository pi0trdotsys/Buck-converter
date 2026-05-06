clear all;
close all;
clc;

%% ========================================================
%% 1. PARAMETRY PROJEKTOWE
%% ========================================================
f0        = 2.45e9;          % częstotliwość środkowa [Hz]
fMin      = 2.40e9;          % dolna granica pasma ISM [Hz]
fMax      = 2.484e9;         % górna granica pasma ISM [Hz]
Z0        = 50;              % impedancja odniesienia [Ohm]
fDesign   = 3.0e9;           % częstotliwość projektu przed skalowaniem
freqRange = linspace(2.0, 3.0, 50) * 1e9;  % zakres symulacji [Hz]

%% ========================================================
%% 2. PROJEKT WSTĘPNY (model w powietrzu)
%% ========================================================
antennaObject = design(invertedFcoplanar, fDesign);

% Współczynnik skalowania do f0
scale = fDesign / f0;

% Skalowanie wszystkich wymiarów geometrycznych
antennaObject.RadiatorArmWidth  = antennaObject.RadiatorArmWidth  / scale;
antennaObject.FeederArmWidth    = antennaObject.FeederArmWidth    / scale;
antennaObject.ShortingArmWidth  = antennaObject.ShortingArmWidth  / scale;
antennaObject.LengthToOpenEnd   = antennaObject.LengthToOpenEnd   / scale;
antennaObject.LengthToShortEnd  = antennaObject.LengthToShortEnd  / scale;
antennaObject.Height            = antennaObject.Height            / scale;
antennaObject.GroundPlaneLength = antennaObject.GroundPlaneLength / scale;
antennaObject.GroundPlaneWidth  = antennaObject.GroundPlaneWidth  / scale;

% Wydruk wymiarów — przyda się do tabeli w raporcie
fprintf('\n--- Wymiary anteny po skalowaniu ---\n');
fprintf('RadiatorArmWidth  = %.2f mm\n', antennaObject.RadiatorArmWidth  * 1e3);
fprintf('FeederArmWidth    = %.2f mm\n', antennaObject.FeederArmWidth    * 1e3);
fprintf('ShortingArmWidth  = %.2f mm\n', antennaObject.ShortingArmWidth  * 1e3);
fprintf('LengthToOpenEnd   = %.2f mm\n', antennaObject.LengthToOpenEnd   * 1e3);
fprintf('LengthToShortEnd  = %.2f mm\n', antennaObject.LengthToShortEnd  * 1e3);
fprintf('Height            = %.2f mm\n', antennaObject.Height            * 1e3);
fprintf('GroundPlaneLength = %.2f mm\n', antennaObject.GroundPlaneLength * 1e3);
fprintf('GroundPlaneWidth  = %.2f mm\n', antennaObject.GroundPlaneWidth  * 1e3);

figure;
show(antennaObject);
title('Geometria anteny IFA – model w powietrzu');

%% ========================================================
%% 3. MODEL PCB (FR4 + miedź)
%% ========================================================
MyAnt = pcbStack(antennaObject);
MyAnt.BoardThickness = 1.6e-3;        % standardowa grubość FR4 [m]

% Warstwa przewodząca — miedź
Cu             = metal('Copper');
Cu.Thickness   = 35e-6;               % standardowa folia PCB [m]
MyAnt.Conductor = Cu;

% Substrat — FR4
Core              = dielectric('FR4');
Core.EpsilonR     = 4.5;              % przenikalność względna
Core.LossTangent  = 0.026;            % stratność @ 2.45 GHz
Core.Thickness    = 1.6e-3;           % grubość substratu [m]
MyAnt.Layers{2}   = Core;

% Kształt płytki PCB
MyAnt.BoardShape = antenna.Rectangle( ...
    "Length", antennaObject.GroundPlaneLength, ...
    "Width",  antennaObject.GroundPlaneWidth + 2*antennaObject.Height, ...
    "Center", [0, antennaObject.Height]);

figure;
show(MyAnt);
title('Geometria anteny IFA – model PCB (FR4 + Cu 35µm)');

%% ========================================================
%% 4. SYMULACJA S11
%% ========================================================
fprintf('\nSymulacja S11 — model PCB... (może potrwać kilka minut)\n');
s = sparameters(MyAnt, freqRange, Z0);

figure;
rfplot(s);
title('Współczynnik odbicia S_{11} – antena IFA na FR4');
xlabel('Częstotliwość [GHz]');
ylabel('S_{11} [dB]');
xline(2.40e9/1e9,  '--r', 'f_{min} = 2.40 GHz', LabelVerticalAlignment='bottom');
xline(2.484e9/1e9, '--r', 'f_{max} = 2.484 GHz', LabelVerticalAlignment='bottom');
xline(2.45e9/1e9,  '--b', 'f_0 = 2.45 GHz',      LabelVerticalAlignment='bottom');
yline(-10, '--k', 'S_{11} = -10 dB');
grid on;

% Odczyt parametrów pasma
s11_dB   = 20*log10(abs(rfparam(s, 1, 1)));
[minVal, minIdx] = min(s11_dB);
freqAxis = s.Frequencies;
fr_sim   = freqAxis(minIdx);

% Pasmo dla S11 < -10 dB
bw_idx   = find(s11_dB < -10);
if ~isempty(bw_idx)
    BW = freqAxis(bw_idx(end)) - freqAxis(bw_idx(1));
else
    BW = 0;
end

fprintf('\n--- Wyniki symulacji S11 ---\n');
fprintf('Częstotliwość rezonansowa : %.3f GHz\n', fr_sim/1e9);
fprintf('Minimum S11               : %.1f dB\n',  minVal);
fprintf('Pasmo (S11 < -10 dB)      : %.1f MHz\n', BW/1e6);

%% ========================================================
%% 5. IMPEDANCJA WEJŚCIOWA
%% ========================================================
figure;
impedance(MyAnt, freqRange);
title('Impedancja wejściowa Z_{in} – antena IFA na FR4');
xline(2.45e9/1e9, '--b', 'f_0 = 2.45 GHz');
grid on;

%% ========================================================
%% 6. DIAGRAM PROMIENIOWANIA I ZYSK
%% ========================================================
figure;
pattern(MyAnt, f0, Type="gain");
title('Diagram promieniowania – zysk antenowy @ 2.45 GHz [dBi]');

figure;
patternElevation(MyAnt, f0);
title('Diagram promieniowania – przekrój elewacyjny @ 2.45 GHz');

figure;
patternAzimuth(MyAnt, f0);
title('Diagram promieniowania – przekrój azymutalny @ 2.45 GHz');

%% ========================================================
%% 7. SPRAWNOŚĆ PROMIENIOWANIA
%% ========================================================
eta = efficiency(MyAnt, f0);
fprintf('\n--- Sprawność promieniowania ---\n');
fprintf('Sprawność @ 2.45 GHz : %.1f %%\n', eta*100);