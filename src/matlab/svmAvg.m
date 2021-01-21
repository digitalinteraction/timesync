function svmAvg(infile, outfile)

    % Read data
    fprintf('Reading (.svm.wav)...\n');
    [data,Fs] = audioread(infile);
    
    fprintf('Scaling...\n');
    data = data * 8;
    
    fprintf('ABS...\n');
    data = abs(data);
    
    fprintf('movavg...\n');
    data = tsmovavg(data,'s',4*Fs,1);
    
    fprintf('scaling...\n');
    data = data / 8;
    
    fprintf('writing (.avg.wav)...\n');
    audiowrite(outfile, data, Fs);

    fprintf('done...\n');
    
end