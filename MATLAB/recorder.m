% Record your voice for 1 seconds.
recObj = audiorecorder;
disp('Start of Recording..');
recordblocking(recObj, 1);
disp('End of Recording..');

% Store data in double-precision array.
y = getaudiodata(recObj);
Fs = 8000;
Nsamps = length(y);
t = (1/Fs)*(1:Nsamps);          %Prepare time data for plot
y = y .* hamming(length(y));

%Do Fourier Transform
y_fft = abs(fft(y));            %Retain Magnitude
y_fft = y_fft(1:Nsamps/2);      %Discard Half of Points
f = Fs*(0:Nsamps/2-1)/Nsamps;   %Prepare freq data for plot
y_fft= int8(y_fft);

%Plot Voice in Time Domain
subplot(2,1,1)
plot(t, y)
xlim([0 1])
xlabel('Time (s)')
ylabel('Amplitude')
title('Human Voice')

%Plot Voice File in Frequency Domain
subplot(2,1,2)
plot(f, y_fft)
xlim([0 1000])
xlabel('Frequency (Hz)')
ylabel('Amplitude')
title('Frequency Response of Human Voice')

s = serial('/dev/ttyUSB0' ,'BaudRate', 9600);

for i = 1:1000 
    fopen(s);
    fwrite(s,y_fft(i));
    fclose(s);
    disp(i)
end