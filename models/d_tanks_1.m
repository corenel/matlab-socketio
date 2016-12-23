% D_TANKS_1
%
% Control Lab: Design of a PI-plus-feedforward Controller
% for the Coupled-Tank system in Configuration #1
%
% D_TANKS_1 designs a feedforward-plus-PI controller for the Tank #1 level loop.
% D_TANKS_1 returns the corresponding gains: Kp_1, Ki_1
%
% Copyright (C) 2003 Quanser Consulting Inc.
% Quanser Consulting Inc.


% Configuration #1: Tank #1 Level Control
function [ Kp_1, Ki_1, Kff_1 ] = d_tanks_1( Kp, At1, Ao1, At2, Ao2, g, L0, PO_1, ts_1 )

% Quiescent Operating Level (cm)
L10 = L0;    
% Quiescent Operating Pump Voltage (V)
Vp0 = Ao1 / Kp * sqrt( 2 * g * L10 ); % = 9.26 V

% Initialization of the Laplace Representation of the Tank #1 system
% open-loop TF: G1 = L11/Vp1 
% DC gain [V/cm]
Kdc_1 = Kp * sqrt( 2 * L10 / g ) / Ao1; % = 3.24
% time constant [s]
tau_1 = At1 / Ao1 * sqrt( 2 * L10 / g ); % = 15.23
% open-loop TF: G1 = L11/Vp1
G1_num = [ Kdc_1 ];
G1_den = [ tau_1, 1 ];
% OL system
G1 = tf( G1_num, G1_den );

% POLE PLACEMENT: TANK #1 LOOP
%TANK1_POLES_LOC = 'REAL'; % zeta_1 >= 1
TANK1_POLES_LOC = 'COMPLEX'; % zeta_1 < 1
if strcmp( TANK1_POLES_LOC, 'COMPLEX' )
    % calculate the required controller gains, Kp_1 and Ki_1
    % meeting the desired specifications
    % i) spec #1: maximum Percent Overshoot (PO_1)
    if ( PO_1 > 0 )
        % PO_1 = 100 * exp( - pi * zeta_1 / sqrt(  1 - zeta_1^2 ) )
        zeta_1_min = abs( log( PO_1 / 100 ) ) / sqrt( pi^2 + log( PO_1 / 100)^2 );
        zeta_1 = zeta_1_min;
    else
        error( 'Error: Set Percentage Overshoot.' )
    end
    % ii) spec #2: ts_1:
    % 2% settling time: ts_1 = 4 / ( zeta_1 * wn_1 )
    wn_1 = 4 / ( zeta_1 * ts_1 );
    % iii) dominating pair of complex poles (satisfying desired bandwidth and damping)
    % calculate pt1_1 and pt1_2 from PO_1, ts_1
    beta_1 = sqrt( 1 - zeta_1^2 );
    pt1_1 = - zeta_1 * wn_1 + beta_1 * wn_1 * i;
    pt1_2 = - zeta_1 * wn_1 - beta_1 * wn_1 * i;
end

% Compute the PI controller gains through pole placement technique
% if char. eq. is: ( s - pt1_1 ) * ( s - pt1_2 ) = 0
% the PI gains are given by (see Maple worksheet):
Kp1_pp = -( pt1_2 * tau_1 + pt1_1 * tau_1 + 1 ) / Kdc_1;
Ki1_pp = pt1_1 * pt1_2 / Kdc_1 * tau_1;
% or:
Kp1_zw = ( 2 * zeta_1 * wn_1 * tau_1 - 1 ) / Kdc_1;
Ki1_zw = wn_1^2 / Kdc_1 * tau_1;

Kp_1 = Kp1_pp;
Ki_1 = Ki1_pp;

% voltage feedforward gain (V/cm^0.5)
Kff_1 = Ao1 * sqrt( 2 * g ) / Kp; % = 2.39

% end of function 'd_tanks_1( )'