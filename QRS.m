%% Inputs
% ecg : raw ecg vector signal 1d signal
% fs : sampling frequency e.g. 200Hz, 400Hz and etc
% gr : flag to plot or not plot (set it 1 to have a plot or set it zero not
% to see any plots

%% Outputs
% qrs_amp_raw : amplitude of R waves amplitudes
% qrs_i_raw : index of R waves
% delay : number of samples which the signal is delayed due to the
% filtering

%% Llamar función
clear all;close all;clc

load Michi500.mat
fs=500;
ecg=x';

gr=1;

[qrs_amp_raw,qrs_i_raw,delay]=pan_tompkin(ecg,fs,gr);