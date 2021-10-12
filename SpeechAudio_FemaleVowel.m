clear all;
close all;

%---------------------------------------------------------------------
%1). reading the audio
% duration = 100; %ms
% seconds = 0.1s
sec = 0.1;

%Female
[F,Fs] = audioread('hud_f.wav');
size(F);
figure(1)
% subplot(2,2,1)
mil = Fs*sec;
segf = F(1000:1000+mil,:);
plot(segf)
title('Female Had Voice Original')
 xlabel('Samples'); ylabel('DB')
 
 %---------------------------------------------------------------------
%2). run FFT through original signals and then plot it
%Female

Yf = (20*log10(abs(fft(segf))));
subplot(2,2,2)
plot(real(Yf));
title('Female Had Voice Original through a fast fourier transform')
 xlabel('Hz'); ylabel('DB')


%---------------------------------------------------------------------
%3). LPC Model: Corre , Autoregressive
figure(2)
subplot(2,2,1)
a = lpc(segf,25);

plot(a); title('Female Had Voice Coffient'); xlabel('Samples'); ylabel('Amplitude')

%---------------------------------------------------------------------
%Redisdual
subplot(2,2,2)
predc = filter(a,1,segf);
plot(predc); title('Female Had Voice Residual'); xlabel('Samples'); ylabel('Amplitude')

%Filter response to A(LPC filter)

%Female LPC Response
figure(3)
freqz(1,a);
title('Female LPC Response');



%---------------------------------------------------------------------
%LPC Corr, Covariance Method...
c = arcov(segf,25);


figure(4)
%Cepstrum Female
cep = rceps(segf);
plot(cep);
title('Female Had Voice Original Cepstrum'); xlabel('Quefrency(Hz)'); ylabel('rceps(x[n])')


%---------------------------------------------------------------------
%4) Workng out the Format Frequencies & Fundamental

%4.1) Working out the Format Frequencies

%Poles

%Working out the poles
%Female
p = roots(a);
size(p);

%Angle
B = angle(p);

%Format Frequencies


f1 = B/(2*pi)*Fs


%4.2) Fundamental Frequencies & Mean
%Fundanmental Freq Estimate using Cepstrum

figure (5)
dt = 1/Fs;

t = 0:dt:length(F)*dt-dt;

trng = t(t>=1e-3 & t<=10e-3);
crng = cep(t>=1e-3 & t<=10e-3);

[~,I] = max(crng);

plot(trng*1e3,crng)
title('Female Had Voice Cepstrum Estimate of the Fundamental Freq'); xlabel('ms'); ylabel('rceps(x[n])')
hold on
plot(trng(I)*1e3,crng(I),'o')
hold off

fprintf('Complex cepstrum F0 estimate is %3.2f Hz.\n',1/trng(I))

%---------------------------------------------------------------------
%Working out the Fundamental Frequencies and Mean
%For Female


[f1,idxf] = pitch(segf,Fs);

f1 = mean(f1);

%---------------------------------------------------------------------
%5) Step Impluse Train
figure (6)


Impulse_train_f = ImpulseTrain_f(Fs,f1);

%Filter and then play the sound

sof = filter(1,a,Impulse_train_f);
plot(sof)

title('Female Had Voice Original Impluse Train'); xlabel('Time'); ylabel('Amplitude')
audiowrite('Female_Had_Seg100_25_order.wav',sof,Fs)
sound(sof,Fs)
%________________________________________________________