 clc;clear;close all;
%% generate a model signal in physical space
step_t=0.001; 
first_step=0;
last_step=1;
t=first_step:step_t:last_step;         

%% generate signal
Noise=0;
Noise=(wgn(1001,1,23))';
y=  50*sin(2*pi*30*t) + 20*cos(2*pi*60*t)+Noise;

%% plotting graph
figure('name', 'Signal and its Spectrum')
subplot(2,1,1), plot(t,y); title('Signal  10*sin(2*pi*60*t) 1000 points')


%% MatLab Guide
% http://www.mathworks.com/help/matlab/ref/fft.html , ñì. òàêæå ñòð 63 Ñåðãèåíêî
fourier=fft(y );     
N_=length(fourier);
f_ = (1 / step_t)  *   (   0:    (N_/2)   )    /    N_; 
  
a=(fourier.*conj(fourier))/(N_*N_); % Spectrum density. Which density have every frequency 
a = a(1:N_ /2+1);   % get half due to parity                                       
% a(2:end-1) = 4*a(2:end-1);  % NORMALIZATION!!
subplot(2,1,2), plot(f_ ,a ); title('Spectrum from signal')

%% amplitude
amplitude_of_signal = abs(fourier)/N_; % normalization
amplitude_of_signal = amplitude_of_signal(1:N_ /2+1);      
amplitude_of_signal=amplitude_of_signal*2; % amplitude is split by two due to parity, half in negative part, half in positive, so we need only half multiply by two 

%subplot(4,1,3), plot(f_ ,amplitude_of_signal ); title('Àìïëèòóäà ñèãíàëà íåçàâèñèìûõ ÷àñòîò')
%%
% we better use loglog because if we have for instance Noise in our signal
% it can be easily seen in Logarithmic scale
% subplot(4,1,4),  loglog(f_,a);title('Ñïåêòðàëüíàÿ ìîùíîñòü ñèãíàëà â ëîãàðèôìè÷åñêîì ìàñøòàáå')

%% through autocorrelation function 
% we have 1000 points, so ACF should be around 100 points
% but still there are problems with normalization  !    : - (
Avarage_value_of_signal = mean(y);
V=0;
S=0;
N_ = length(   y    );
ACF_signal=zeros(1,100);
for j=1:99;
    S=0;
    A=0;
    for i=1:N_ - j
        A= (  y(i) - Avarage_value_of_signal   )*(   y(i+j)    -     Avarage_value_of_signal     );
        S=S+A;
    end
    ACF_signal(j) = S    /   (i);
end

figure('name', 'ACF and its Spectrum'); subplot(2,1,1)
plot(ACF_signal);
title('  ACF and Spectrum  ');  grid on;

%% Spectrun from ACF
% and again no clue about normalization! 
fourier=fft(ACF_signal );     
N_=length(fourier);
f_ = (1 / step_t)  *   (   0:    (N_/2)   )    /    N_; 
  
a=(fourier.*conj(fourier))/(N_*N_);  
a = a(1:N_ /2+1);                                     
%a(2:end-1) = 4*a(2:end-1); 
subplot(2,1,2), plot(f_ ,a ); title('Spectrum from ACF');

