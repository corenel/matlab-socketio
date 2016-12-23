% D_TANKS_2
%
% Control Lab: Design of two PI-plus-feedforward Controllers
% for the Coupled-Tank system in Configuration #2.
%
% D_TANKS_2 designs an inner feedforward-plus-PI controller for the Tank 1 level loop,
% and an outer feedforward-plus-PI controller for the Tank 2 level loop.
% D_TANKS_2 returns the corresponding gains: Kp_1, Ki_1, Kp_2, Ki_2
%
% Copyright (C) 2003 Quanser Consulting Inc.
% Quanser Consulting Inc.

% Configuration #2: Tank 2 Level Control
function [ Kp_1, Ki_1, Kff_1, Kp_2, Ki_2, Kff_2 ] = d_tanks_2( Kp, At1, Ao1, At2, Ao2, g, L0, PO_1, ts_1, PO_2, ts_2 )

% Quiescent Operating Levels (cm)
L20 = L0;
L10 = ( Ao2 / Ao1 )^2 * L20; % == L20

% Tank #1 Level feedforward-plus-PI Loop
% POLE PLACEMENT: TANK #1 LOOP
% Compute the PI controller gains through pole placement technique
[ Kp_1, Ki_1, Kff_1 ] = d_tanks_1( Kp, At1, Ao1, At2, Ao2, g, L10, PO_1, ts_1 );

% Tank #2 Level Loop
% Initialization of the Laplace Representation of the Tank #2 system
% open-loop TF: G2 = L21/L11 
% open-loop DC gain [cm/cm]
Kdc_2 = Ao1 / Ao2 * sqrt( L20 / L10 ); % = 1
% open-loop time constant [s]
tau_2 = At2 / Ao2 * sqrt( 2 * L20 / g ); % = 15.23 
% open-loop TF: G2 = L21/L11
G2_num = [ Kdc_2 ];
G2_den = [ tau_2, 1 ];
% OL system
G2 = tf( G2_num, G2_den );

% POLE PLACEMENT: TANK #2 LOOP
%TANK2_POLES_LOC = 'REAL'; % zeta_2 >= 1
TANK2_POLES_LOC = 'COMPLEX'; % zeta_2 < 1
if strcmp( TANK2_POLES_LOC, 'COMPLEX' )
    % calculate pt2_1 and pt2_2 from PO_2, ts_2
    % i) spec #1: maximum Percent Overshoot (PO_2)
    if ( PO_2 > 0 )
        zeta_2_min = abs( log( PO_2 / 100 ) ) / sqrt( pi^2 + log( PO_2 / 100)^2 );
        zeta_2 = zeta_2_min;
    else
        error( 'Error: Set Percentage Overshoot.' )
    end
    % ii) spec #2: ts_2:
    % 2% settling time: ts_2 = 4 / ( zeta_2 * wn_2 )
    wn_2 = 4 / ( zeta_2 * ts_2 );
    % iii) dominating pair of complex poles (satisfying desired bandwidth and damping)
    % calculate pt2_1 and pt2_2 from PO_2, ts_2
    beta_2 = sqrt( 1 - zeta_2^2 );
    pt2_1 = - zeta_2 * wn_2 + beta_2 * wn_2 * i;
    pt2_2 = - zeta_2 * wn_2 - beta_2 * wn_2 * i;
end

% Compute the PI controller gains through pole placement technique
% if char. eq. is: ( s - pt2_1 ) * ( s - pt2_2 ) = 0
% the PI gains are given by (see Maple worksheet):
Kp2_pp = -( pt2_2 * tau_2 + pt2_1 * tau_2 + 1 ) / Kdc_2;
Ki2_pp = pt2_1 * pt2_2 / Kdc_2 * tau_2;
% or:
Kp2_zw = ( 2 * zeta_2 * wn_2 * tau_2 - 1 ) / Kdc_2;
Ki2_zw = wn_2^2 * tau_2 / Kdc_2;

Kp_2 = Kp2_pp;
Ki_2 = Ki2_pp;

% level feedforward gain (cm/cm)
Kff_2 = Ao2^2 / Ao1^2; % = 1

% end of function 'd_tanks_2( )'