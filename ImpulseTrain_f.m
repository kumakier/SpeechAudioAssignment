function impulse_train_f = ImpulseTrain_f(Fs, f1)

ts = 1/Fs;
t1 = 1/f1;
num = floor(t1/ts);
impulse_train_f = [ones(1,1),zeros(1, num-1)];
impulse_train_f = repmat(impulse_train_f, 1, floor(1/t1));

