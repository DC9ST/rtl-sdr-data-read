% ------------------------------------------------------------------------------------------
% Simple Matlab script, that reads an RTL-SDR IQ signal from a file,
% that has been captured by the "rtl_sdr" command from librtlsdr
% 
% shows the IQ signal with absolute value and angle, as well as a spectrogram
%
% by DC9ST, 2016
% ------------------------------------------------------------------------------------------

clear;
clc;
close all;


% filename 
filename1 = 'example_dvb.dat';

% read data from file
fileID1 = fopen(filename1);
a = fread(fileID1);
fclose(fileID1); 

% extract I/Q data
num_samples1 = length(a)/2; % determine number of samples
a1 = a(1:num_samples1*2);
inphase1 = a1(1:2:end) -128;
quadrature1 = a1(2:2:end) -128;

% plot signal in time domain results
num_plot_samples = length(inphase1);

subplot(3,1,1); plot(1:num_plot_samples, inphase1(1:num_plot_samples), 1:num_plot_samples, quadrature1(1:num_plot_samples));
title('RX: I and Q');

subplot(3,1,2); plot(1:num_plot_samples, abs(inphase1+1i*quadrature1));
title('abs');

subplot(3,1,3); plot(1:num_plot_samples, unwrap(angle(inphase1+1i*quadrature1)));
title('unwrapped phase');


%% calculate and show spectrogram
figure;
complex_signal = detrend(inphase1+1i*quadrature1);
[S,F,T,P] = spectrogram(complex_signal, 512, 0, 512, num_plot_samples );
spectrum = fftshift(fliplr(10*log10(abs(P))'));
surf(F,T, spectrum, 'edgecolor', 'none');
axis tight;
view(0,90);