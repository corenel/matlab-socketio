% SETUP_LAB_TANKS
%
% Control Lab of Water Level in Coupled Tanks: 
% Show histogram
% figure(2);
%
% Design of PI-Based level control loops 
% for three (3) increasingly complex configurations of the Quanser Coupled-Tank plant.
% 
% SETUP_LAB_TANKS sets the Coupled-Tank system's model parameters.
% SETUP_LAB_TANKS can also calculate and set the level controllers' gains. 
%
% Copyright (C) 2003 Quanser Consulting Inc.
% Quanser Consulting Inc.

clear all
clc
% ########## USER-DEFINED COUPLED-TANK CONFIGURATION ##########
% Configuration #: set to 1, 2, or 3
% TANK_CONFIGURATION = 1;
TANK_CONFIGURATION = 2;
% TANK_CONFIGURATION = 3;
% Amplifier Gain used: 
% VoltPAQ-X1 users: set to K_AMP to 3 and Gain switch on amplifier to 3
% VoltPAQ-X2 users: set to K_AMP 3
K_AMP = 3;
% Digital-to-Analog Maximum Voltage (V); for MultiQ cards set to 10
VMAX_DAC = 10;
% ########## USER-DEFINED COUPLED-TANK CONFIGURATION ##########


% ########## USER-DEFINED CONTROLLER DESIGN ##########
% Type of Controller: set it to 'AUTO', 'MANUAL'  
CONTROLLER_TYPE = 'AUTO';    % controller design: automatic mode
% CONTROLLER_TYPE = 'MANUAL';    % controller design: manual mode
% Coupled-Tank system configuration
if ( TANK_CONFIGURATION == 1 )
    % Quiescent operating level (cm)
    L10 = 15;
    % Controller design specifications
    PO_1 = 11; % Tank #1 Percent Overshoot (%)
    ts_1 = 5; % Tank #1 2% Settling Time (s)
    % Integral anti-windup maximum for the limiter integrator
    % tank #1 level loop (V)
    MAX_L1_WDUP = 3;
    % Control loop initial Settling Time in reaching L10 (s)
    TS = 15;
elseif ( TANK_CONFIGURATION == 2 )
    % Quiescent operating level (cm)
    L20 = 15;
    % Inner controller design specifications
    PO_1 = 11; % Tank #1 Percent Overshoot (%)
    ts_1 = 5; % Tank #1 2% Settling Time (s)
    % Outer controller design specifications
    PO_2 = 10; % Tank #2 Percent Overshoot (%)
    ts_2 = 20; % Tank #2 2% Settling Time (s)
    % Integral anti-windup maximum for the limiter integrator
    % Tank #1 level loop (V)
    MAX_L1_WDUP = 3;
    % Tank #2 level loop (cm)
    MAX_L2_WDUP = 3;
    % Safety Limit on tank #1 setpoint, Lr_1, (cm)
    LR_1_MAX = 25;
    % Control loop initial Settling Time in reaching L20 (s)
    TS = 35;
elseif TANK_CONFIGURATION == 3
    % Quiescent operating level (cm)
    L20 = 15;
    % Integral anti-windup maximum for the limiter integrator
    % Tank #1 level loop (V)
    MAX_L1_WDUP = 3;
    % Tank #2 level loop (cm)
    MAX_L2_WDUP = 3;
    % Safety Limit on tank #1 setpoint, Lr_1, (cm)
    LR_1_MAX = 25;
    % Control loop initial Settling Time in reaching L20 (s)
    TS = 35;
elseif TANK_CONFIGURATION == 4
    % Quiescent operating level (cm)
    L20 = 10;
    L40 = 14;
    % Integral anti-windup maximum for the limiter integrator
    % Tank #1 level loop (V)
    MAX_L1_WDUP = 3;
    MAX_L3_WDUP = 3;
    % Tank #2 level loop (cm)
    MAX_L2_WDUP = 3;
    MAX_L4_WDUP = 3;
    % Safety Limit on tank #1 setpoint, Lr_1, (cm)
    LR_1_MAX = 25;
    LR_3_MAX = 25;
    % Control loop initial Settling Time in reaching L20 (s)
    TS = 35;
else
    error( 'Error: Please set the tank configuration that you wish to implement.' )
end
% first-order low-pass filter specifications 
% Low-pass filter time constant for Tank #1 pressure sensor signal
tau_t1 = 1 / ( 2 * pi * 1.0 );
% Low-pass filter time constant for Tank #2 pressure sensor signal
tau_t2 = 1 / ( 2 * pi * 0.33 );
% Turn on/off the safety watchdog on tank #1 level: set to 1, or 0
L1_WD_EN = 1; % enable: watchdog on
%L1_WD_EN = 0; % disable: watchdog off
% Set tank #1 level safety limits for watchdog (cm)
L1_MAX = 30;
% Turn on/off the safety watchdog on tank #2 level: set to 1, or 0
L2_WD_EN = 1; % enable: watchdog on
%L2_WD_EN = 0; % disable: watchdog off
% Set tank #2 level safety limits for watchdog (cm)
L2_MAX = 25;
% ########## END OF USER-DEFINED CONTROLLER DESIGN ##########

% variables required in the Simulink diagrams
global VMAX_AMP IMAX_AMP
% Pressure Sensor Sensitivities (cm/V)
global K_L1 K_L2

% Set the model parameters accordingly to the user-defined configuration of the Coupled-Tank system.
% These parameters are used for model representation and controller design.
[ Kp, At1, Ao1, At2, Ao2, Ai1, Ai2, g ] = setup_tanks_parameters( TANK_CONFIGURATION );

if strcmp ( CONTROLLER_TYPE, 'AUTO' )
    % Automatically calculate the level controller gains
    if ( TANK_CONFIGURATION == 1 )
        [ Kp_1, Ki_1, Kff_1 ] = d_tanks_1( Kp, At1, Ao1, At2, Ao2, g, L10, PO_1, ts_1 );
        % Display the calculated gains
        disp( ' ' )
        disp( [ 'Coupled-Tank System in Configuration #1.' ] )
        disp( 'Tank 1 level loop - Calculated PI controller gains: ' )
        disp( [ 'Kp_1 = ' num2str( Kp_1 ) ' V/cm' ] )
        disp( [ 'Ki_1 = ' num2str( Ki_1 ) ' V/s/cm' ] )
        disp( [ 'Kff_1 = ' num2str( Kff_1 ) ' V/cm^0.5' ] )
    elseif ( TANK_CONFIGURATION == 2 )
        [ Kp_1, Ki_1, Kff_1, Kp_2, Ki_2, Kff_2 ] = d_tanks_2( Kp, At1, Ao1, At2, Ao2, g, L20, PO_1, ts_1, PO_2, ts_2 );
        % Display the calculated gains
        disp( ' ' )
        disp( [ 'Coupled-Tank System in Configuration #2.' ] )
        disp( 'Tank 1 level loop - Calculated PI controller gains: ' )
        disp( [ 'Kp_1 = ' num2str( Kp_1 ) ' V/cm' ] )
        disp( [ 'Ki_1 = ' num2str( Ki_1 ) ' V/s/cm' ] )
        disp( [ 'Kff_1 = ' num2str( Kff_1 ) ' V/cm^0.5' ] )
        disp( 'Tank 2 level loop - Calculated PI controller gains: ' )
        disp( [ 'Kp_2 = ' num2str( Kp_2 ) ' cm/cm' ] )
        disp( [ 'Ki_2 = ' num2str( Ki_2 ) ' 1/s' ] )
        disp( [ 'Kff_2 = ' num2str( Kff_2 ) ' cm/cm' ] )
    elseif ( TANK_CONFIGURATION == 3 )
        
        Q = diag( [ 50 10 1000 ] );
        R = 1;
        [ Kp_1, Kp_2, Ki_2, gamma, Kff_2 ] = d_tanks_3( Kp, At1, Ai1, Ao1, At2, Ai2, Ao2, g, L20, Q, R );
        % [ Kp_1, Kp_2, Ki_2, gamma ] = d_tanks_3_pp( Kp, At1, Ai1, Ao1, At2, Ai2, Ao2, g, L20, PO_1, ts_1, PO_2, ts_2 );
        
        % Display the calculated gains
        disp( ' ' )
        disp( [ 'Coupled-Tank System in Configuration #3.' ] )
        disp( 'Tank 1 level loop - Calculated P controller gain: ' )
        disp( [ 'Kp_1 = ' num2str( Kp_1 ) ' V/cm' ] )
        disp( 'Tank 2 level loop - Calculated PI controller gains: ' )
        disp( [ 'Kp_2 = ' num2str( Kp_2 ) ' cm/cm' ] )
        disp( [ 'Ki_2 = ' num2str( Ki_2 ) ' 1/s' ] )
    elseif ( TANK_CONFIGURATION == 4 )
                
        At3=At1;
        Ai3=Ai1;
        Ao3=Ao1;
        At4=At2;
        Ai4=Ai2;
        Ao4=Ao2;
        
        
        Q = diag( [ 50 10 10000 50 10 10000] );
        R = eye(2);
        [ Kp_1_Vp1, Kp_2_Vp1, Ki_2_Vp1, Kp_3_Vp1, Kp_4_Vp1, Ki_4_Vp1,Kp_1_Vp2, Kp_2_Vp2, Ki_2_Vp2, Kp_3_Vp2, Kp_4_Vp2, Ki_4_Vp2, gamma1, gamma2, Kff_2 , Kff_4 ] = d_tanks_4( Kp, At1, Ai1, Ao1, At2, Ai2, Ao2, At3, Ai3, Ao3, At4, Ai4, Ao4, g, L20, L40, Q, R );
        % [ Kp_1, Kp_2, Ki_2, gamma ] = d_tanks_3_pp( Kp, At1, Ai1, Ao1, At2, Ai2, Ao2, g, L20, PO_1, ts_1, PO_2, ts_2 );
        
        % Display the calculated gains
        disp( ' ' )
        disp( [ 'Coupled-Tank System in Configuration #4.' ] )
        disp( 'Tank 1 level loop - Calculated P controller gain for control input of pump 1: ' )
        disp( [ 'Kp_1_Vp1 = ' num2str( Kp_1_Vp1 ) ' V/cm' ] )
        disp( 'Tank 2 level loop - Calculated PI controller gains for control input of pump 1: ' )
        disp( [ 'Kp_2_Vp1 = ' num2str( Kp_2_Vp1 ) ' cm/cm' ] )
        disp( [ 'Ki_2_Vp1 = ' num2str( Ki_2_Vp1 ) ' 1/s' ] )
        disp( 'Tank 3 level loop - Calculated P controller gain for control input of pump 1: ' )
        disp( [ 'Kp_3_Vp1 = ' num2str( Kp_3_Vp1 ) ' V/cm' ] )
        disp( 'Tank 2 level loop - Calculated PI controller gains for control input of pump 1: ' )
        disp( [ 'Kp_4_Vp1 = ' num2str( Kp_4_Vp1 ) ' cm/cm' ] )
        disp( [ 'Ki_4_Vp1 = ' num2str( Ki_4_Vp1 ) ' 1/s' ] )
        
        disp( 'Tank 1 level loop - Calculated P controller gain for control input of pump 2: ' )
        disp( [ 'Kp_1_Vp2 = ' num2str( Kp_1_Vp2 ) ' V/cm' ] )
        disp( 'Tank 2 level loop - Calculated PI controller gains for control input of pump 2: ' )
        disp( [ 'Kp_2_Vp2 = ' num2str( Kp_2_Vp2 ) ' cm/cm' ] )
        disp( [ 'Ki_2_Vp2 = ' num2str( Ki_2_Vp2 ) ' 1/s' ] )
        disp( 'Tank 3 level loop - Calculated P controller gain for control input of pump 2: ' )
        disp( [ 'Kp_3_Vp2 = ' num2str( Kp_3_Vp2 ) ' V/cm' ] )
        disp( 'Tank 2 level loop - Calculated PI controller gains for control input of pump 2: ' )
        disp( [ 'Kp_4_Vp2 = ' num2str( Kp_4_Vp2 ) ' cm/cm' ] )
        disp( [ 'Ki_4_Vp2 = ' num2str( Ki_4_Vp2 ) ' 1/s' ] )
    else
        error( 'Error: Please set the tank configuration that you wish to implement.' )
    end
elseif strcmp ( CONTROLLER_TYPE, 'MANUAL' )
    Kp_1 = 0; Ki_1 = 0;
    Kp_2 = 0; Ki_2 = 0;
    disp( ' ' )
    disp( 'STATUS: manual mode' ) 
    disp( 'The model parameters of your Coupled-Tank system have been set.' )
    disp( 'You can now design a controller for your system.' )
    disp( ' ' )
else
    error( 'Error: Please set the type of controller that you wish to implement.' )
end