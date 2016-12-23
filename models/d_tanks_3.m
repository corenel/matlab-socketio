% D_TANKS_2
%
% Control Lab: Design of two PI-plus-feedforward Controllers
% for the Coupled-Tank system in Configuration #2.
%
% D_TANKS_2 designs an inner feedforward-plus-PI controller for the Tank 1 level loop,
% and an outer feedforward-plus-PI controller for the Tank 2 level loop.
% D_TANKS_2 returns the corresponding gains: Kp_1, Ki_1, Kp_2, Ki_2
%
% Copyright (C) 2010 Quanser Consulting Inc.
% Quanser Consulting Inc.

% Configuration #2: Tank 2 Level Control
function [ Kp_1, Kp_2, Ki_2, gamma, Kff_2  ] = d_tanks_3( Kp, At1, Ai1, Ao1, At2, Ai2, Ao2, g, L20, Q, R )
% gamma
gamma = Ai2 / ( Ai1 + Ai2 );
% Quiescent Operating Levels (cm)
Vp0 = 2^(1/2)*Ao2*(g*L20)^(1/2)/Kp;
L10 = Ao2^2*L20*(-1+gamma)^2/Ao1^2;
% load state-space model
TANKS_3_ABCD_eqns;
% design LQR control gain
K = lqr(A,B,Q,R);
% set vector gain to PI gains for each tank (only P for tank 1)
Kp_1 = K(1);
Kp_2 = K(2);
Ki_2 = K(3);
%
Kff_2  = Ao2^2*(1-gamma)^2/Ao1^2;
% end of function 'd_tanks_3( )