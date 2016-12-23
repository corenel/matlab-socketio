% SETUP_TANKS_PARAMETERS
%
% SETUP_TANKS_PARAMETERS initializes 
% the model parameters of the Quanser's Coupled-Tank plant.
%
% Coupled Tanks' system nomenclature:
% Kp        Pump Flow Constant                      (cm^3/s/V)
% At1       Tank 1 Inside Cross-Section Area        (cm^2)
% Ao1       Tank 1 Outlet Area                      (cm^2)
% At2       Tank 2 Inside Cross-Section Area        (cm^2)
% Ao2       Tank 2 Outlet Area                      (cm^2)
% g         Gravity Constant                        (cm/s^2)
% K_L1      Tank 1 Water Level Sensor Sensitivity   (cm/V)
% K_L2      Tank 2 Water Level Sensor Sensitivity   (cm/V)
% L1_MAX    Tank 1 Height (Maximum Water Level)     (cm)
% L2_MAX    Tank 2 Height (Maximum Water Level)     (cm)
% VMAX_AMP  Amplifier Maximum Output Voltage              (V)
% IMAX_AMP  Amplifier Maximum Output Current              (A)
% Vp_MAX    Pump Maximum Voltage                    (V)
% Ai1       Tank 1 Inlet Area                       (cm^2)
% Ai2       Tank 2 Inlet Area                       (cm^2)
% Dout1     "Out 1" Orifice Diameter                (cm)
% Dout2     "Out 2" Orifice Diameter                (cm)
% Dso       Small Outflow Orifice Diameter          (cm)
% Dmo       Medium Outflow Orifice Diameter         (cm)
% Dlo       Large Outflow Orifice Diameter          (cm)
%
% Copyright (C) 2003 Quanser Consulting Inc.
% Quanser Consulting Inc.


%% returns the model parameters accordingly to the user-defined COUPLED TANKS system configuration
function [ Kp, At1, Ao1, At2, Ao2, Ai1, Ai2, g ] = setup_tanks_parameters( TANK_CONFIGURATION )
% Amplifier Maximum Output Voltage (V) and Current (A)
global VMAX_AMP IMAX_AMP
% safety water level limits (cm)
global L1_MAX L2_MAX
% Pressure Sensor Sensitivities (cm/V)
global K_L1 K_L2

% Pump Flow Constant (cm^3/s/V)
Kp = 3.3;
% Pump Maximum Continuous Voltage(V)
Vp_MAX = 12;

% "Out 1" Orifice Diameter (cm)
Dout1 = 0.635; % = 1/4 in
% "Out 2" Orifice Diameter (cm)
Dout2 = 0.47625; % = 3/16 in

% Tank 1 Height (i.e. Maximum Water Level) (cm)
L1_MAX = 30;
% Tank 1 Inside Diameter (cm)
Dt1 = 4.445; % = 1.75 inch
% Tank 2 Height (i.e. Maximum Water Level) (cm)
L2_MAX = 30;
% Tank 2 Inside Diameter (cm)
Dt2 = 4.445; % = 1.75 inch

% Small Outflow Orifice Diameter (cm)
Dso = 0.31750; % = 1/8 in
% Medium Outflow Orifice Diameter (cm)
Dmo = 0.47625;  % = 3/16 in
% Large Outflow Orifice Diameter (cm)
Dlo = 0.55563; % = 7/32 in

% Tank 1 Inlet and Outlet Diameters (cm)
% Tank 2 Inlet and Outlet Diameters (cm)
if ( TANK_CONFIGURATION == 1 ) || ( TANK_CONFIGURATION == 2 )
    Di1 = Dout1;
    Do1 = Dmo;
    Di2 = 0;
    Do2 = Dmo;
elseif (TANK_CONFIGURATION == 3) ||  (TANK_CONFIGURATION == 4) 
    Di1 = Dout2;
    Do1 = Dmo;
    Di2 = Dout1;
    Do2 = Dmo;
else
    error( 'Error: Please set the tank configuration that you wish to implement.' )
end

% Tank 1 Water Level Sensor Sensitivity (cm/V)
K_L1 = 25 / 4.15; % 25 / 4.1 = 6.1
% Tank 2 Water Level Sensor Sensitivity (cm/V)
K_L2 = 25 / 4.15; % 25 / 4.1 = 6.1

% Calculate the system's areas
% Tank 1 Inside Cross-Section Area (cm^2)
At1 = pi * Dt1^2 / 4;
% Tank 2 Inside Cross-Section Area (cm^2)
At2 = pi * Dt2^2 / 4;
% Tank 1 Outlet Area (cm^2)
Ao1 = pi * Do1^2 / 4;
% Tank 2 Outlet Area (cm^2)
Ao2 = pi * Do2^2 / 4;
% Tank 1 Inlet Area (cm^2)
Ai1 = pi * Di1^2 / 4;
% Tank 2 Inlet Area (cm^2)
Ai2 = pi * Di2^2 / 4;

% Gravitational Constant on Earth (cm/s^2)
g = 981;

% Amplifier Maximum Output Voltage (V) and Current (A)
VMAX_AMP = 22;
% Amplifier Maximum Output Voltage (V) and Current (A)
IMAX_AMP = 4;

% end of 'setup_tanks_parameters( )'
