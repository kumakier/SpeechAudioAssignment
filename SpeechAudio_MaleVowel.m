clear all;
close all;
%---------------------------------------------------------------------
%1). reading the audio
% duration = 100; %ms
% seconds = 0.1s

sec = 0.1;
%Male
figure(1)
[x,fs] = audioread('had_m.wav');
size(x);
subplot(2,2,1)
mil = fs*sec;
seg = x(1:mil,:);
plot(seg)
title('Male Had Voice Original')
 xlabel('Samples'); ylabel('DB')
 
 %---------------------------------------------------------------------
%2). run FFT through original signals and then plot it
%Male
Y = (20*log10(abs(fft(seg))));
subplot(2,2,2)
plot(real(Y));
title('Male Had Voice Original through a fast fourier transform')
 xlabel('Hz'); ylabel('DB')

%---------------------------------------------------------------------
%3). LPC Model: Corre , Autoregressive
figure(2)
subplot(2,2,1)
a = lpc(seg,100);

plot(a); title('Male Had Voice Coffient'); xlabel('Samples'); ylabel('Amplitude')

%---------------------------------------------------------------------
%Redisdual
subplot(2,2,2)
predc = filter(a,1,seg);
plot(predc); title('Male Had Voice Residual'); xlabel('Samples'); ylabel('Amplitude')

%Filter response to A(LPC filter)

%Male LPC Response
figure(3)
freqz(a);
title('Male LPC Response');

%---------------------------------------------------------------------
%LPC Corr, Covariance Method..
c = arcov(seg,25);


%Cepstrum Male
figure(4)
cep = rceps(seg);
plot(cep);
title('Male Had Voice Original Cepstrum'); xlabel('Quefrency(Hz)'); ylabel('rceps(x[n])')

%---------------------------------------------------------------------
%4) Workng out the Format Frequencies & Fundamental

%4.1) Working out the Format Frequencies

%Poles
p = roots(a);
size(p);

%Angle
B = angle(p);

%Format Frequencies

f1 = B/(2*pi)*fs

%4.2) Fundamental Frequencies & Mean
%Fundanmental Freq Estimate using Cepstrum
figure(5)
dt = 1/fs;

t = 0:dt:length(x)*dt-dt;

trng = t(t>=1e-3 & t<=10e-3);
crng = cep(t>=1e-3 & t<=10e-3);

[~,I] = max(crng);

plot(trng*1e3,crng)
xlabel('ms')

hold on
plot(trng(I)*1e3,crng(I),'o')
hold off

fprintf('Complex cepstrum F0 estimate is %3.2f Hz.\n',1/trng(I))

%---------------------------------------------------------------------
%Working out the Fundamental Frequencies and Mean
%For Male


[f0,idxf] = pitch(seg,fs);

f0 = mean(f0);

%---------------------------------------------------------------------
%5) Step Impluse Train

figure (6)

Impulse_train_m = ImpulseTrain_m(fs,f0);

%Filter and then play the sound

so = filter(1,a,Impulse_train_m);
plot(so)

title('Male Had Voice Original Impluse Train'); xlabel('Time'); ylabel('Amplitude')
audiowrite('Male_Had_Seg200_100_order.wav',so,fs);
sound(so,fs);
%________________________________________________________
 
