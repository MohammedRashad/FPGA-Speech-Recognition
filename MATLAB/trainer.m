x = uint8(zeros(4000,10));

for i = 1:10 
    % Record your voice for 1 seconds.
    recObj = audiorecorder;

    disp('--------------------');
    fprintf('Sample No. %d\n' , i);
    disp('--------------------');

    disp('Start of Recording..');
    recordblocking(recObj, 1);
    disp('End of Recording..');

    % Store data in double-precision array.
    y  =   getaudiodata(recObj)  ;
    Fs = 8000;
    Nsamps = length(y);
    t = (1/Fs)*(1:Nsamps);          %Prepare time data for plot
    y  = y  .* hamming(length(y ));

    %Do Fourier Transform
    y = abs(fft(y));            %Retain Magnitude
    y = y(1:Nsamps/2);      %Discard Half of Points
    f = Fs*(0:Nsamps/2-1)/Nsamps;   %Prepare freq data for plot
    y= uint8(y);  

    x(:,i) = y;

    %Plot Voice File in Frequency Domain
    subplot(2,5,i)
    plot(f, y)
    xlim([0 1000])
    xlabel('Frequency (Hz)')
    ylabel('Amplitude')
    title(sprintf('No. %d' , i));
    pause(2);

end

mean_x = ceil(mean(x , 2));

% Plot Voice File in Frequency Domain
figure
plot(f, mean_x')
xlim([0 1000])
xlabel('Frequency (Hz)')
ylabel('Amplitude')

csvwrite('one.dat',mean_x(1:1000));