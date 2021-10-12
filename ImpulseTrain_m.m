function impulse_train_m = ImpulseTrain_m(fs, f0)

ts = 1/fs;
t1 = 1/f0;
num = floor(t1/ts);
impulse_train_m = [ones(1,1),zeros(1, num-1)];
impulse_train_m = repmat(impulse_train_m, 1, floor(1/t1));