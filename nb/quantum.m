clear;
clc;

PauliX = [0 1; 1 0];
PauliY = [0 -i; i 0];
PauliZ = [1 0; 0 -1];

% Hadamard
H = [1 1; 1 -1] ./ sqrt(2);
% Phase shift
S = [1 0; 0 i];

%% Single qubit Pauli measurement
% A = U^{H}ZU
% ' means complex conjugate transpose
% U is unitary

% PauliX
U = H;
str(U' * PauliZ * U)

% PauliY
U = H*S';
U' * PauliZ * U




