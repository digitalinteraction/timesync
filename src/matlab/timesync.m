% Read data
%[dataB,Fs] = audioread('Data/1B.wav');
%[dataT,Fs] = audioread('Data/1T.wav');

% Use X/Y/Z channels (remove 'aux'), scale to +/- 8G
%dataB = dataB(:,1:3) * 8;
%dataT = dataT(:,1:3) * 8;

% BP-Filtered abs(SVM-1)
%fprintf('Calculating bandpass-filtered SVM...\n');
%svmB2 = SVM(dataB, Fs, 0.5, 20);
%svmT2 = SVM(dataT, Fs, 0.5, 20);

% Abs
%svmB3 = abs(svmB2);
%svmT3 = abs(svmT2);

% Low-pass filter
%[B,A] = butter(4, 0.25 / (Fs / 2), 'low'); 
%svmB4 = filter(B, A, svmB3);
%svmT4 = filter(B, A, svmT3);

%hold on
%plot(svmB4 .* 0.1 + 0.1);
%plot(svmT4 .* 0.1 + 0.3);
%hold off


wavSVM('Data/4B.wav', 'Data/4B.svm.wav');
wavSVM('Data/4T.wav', 'Data/4T.svm.wav');

svmAvg('Data/4B.svm.wav', 'Data/4B.avg.wav');
svmAvg('Data/4T.svm.wav', 'Data/4T.avg.wav');

