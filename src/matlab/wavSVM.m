function wavSVM(infile, outfile)

    % Read data
    fprintf('Reading (.wav)...\n');
    [data,Fs] = audioread(infile);

    % Use X/Y/Z channels (remove 'aux'), scale to +/- 8G
    fprintf('Scaling...\n');
    data = data(:,1:3) * 8;

    % SVM-1
    fprintf('Calculating SVM...\n');
    data = sqrt(sum(data(:, end-2:end) .^ 2, 2)) - 1;

    fprintf('Scaling...\n');
    data = data / 8;

    fprintf('Writing (.svm.wav)...\n');
    audiowrite(outfile, data, Fs);

    fprintf('Done...\n');

end