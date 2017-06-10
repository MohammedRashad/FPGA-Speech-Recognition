# FPGA-Speech-Recognition
Simple Speech Recognition System using MATLAB and VHDL on Altera DE0
 
# Introduction
 
This project is a trial to develop a simple functional speech recognition engine on low-end and educational FPGAs like Altera DE0. 
<br/> <br/>
The system was designed so as to **recognize the digit (1 or 0)** being spoken into the microphone of laptop then transferred into FPGA over UART. Both industry and academia have spent a considerable effort in this field for developing software and hardware to come up with a robust solution. However, it is because of large number of accents spoken around the world that this conundrum still remains an active area of research.
  <br/> <br/>
Speech Recognition finds numerous applications including healthcare, artificial intelligence, human computer interaction, Interactive Voice Response Systems, military, avionics etc. Another most important application resides in helping the physically challenged people to interact with the world in a better way.
 
 
# Theory

Speech recognition systems can be classified into several models by describing the types of utterances to be recognized. These classes shall take into consideration the ability to determine the instance when the speaker starts and finishes the utterance. In our project we aimed to implement Isolated Word Recognition System which usually used a hamming window over the word being spoken. <br/> <br/>
 
The Speech Recognition Engines are broadly classified into 2 types, namely Pattern Recognition and Acoustic Phonetic systems. While the former use the known/trained patterns to determine a match, the latter uses attributes of the human body to compare speech features (phonetics such as vowel sounds). The pattern recognition systems combine with current computing techniques and tend to have higher accuracy.
 <br/> <br/>
### basic structure of a speech recognition system goes as follows : 
- Speech Signal Recording.
- Spectral Analysis (FFT , Windowing , MFCC, Power Spectrum).
- Probability Estimation (Neural Networks, Hidden Markov Model, VQ).
- Signal Decoding and Decision Making.
 
 <br/>
Audio Signals are captured using microphones and it’s recorded in the time domain (i.e. varies with time). The problem with human voice signals that they are not stationary and the analysis of such signals in time domain is very complicated problem and computationally costly. 
  <br/> <br/>
Here comes the role of spectral analysis, by doing a set of transformations and processing algorithms on the incoming signal, it is converted into a usable form that further analysis can be done on it.
 <br/> <br/>
For this I'm are using : 
 
**DFT :**

The discrete Fourier transform (DFT) converts a finite sequence of equally-spaced samples of a function into an equivalent-length sequence of equally-spaced samples of the discrete-time Fourier transform (DTFT), which is a complex-valued function of frequency.
 
 
**Hamming Window :**

Whenever we do a finite Fourier transform, we are implicitly applying it to an infinitely repeating signal. So, if the start and end of the finite sample don't match then that will look just like a discontinuity in the signal, and show up as lots of high-frequency nonsense in the Fourier transform, which we don't want. 
 
And if the sample happens to be a beautiful sinusoid but an integer number of periods don't happen to fit exactly into the finite sample, your FT will show appreciable energy in all sorts of places nowhere near the real frequency. 
 
Windowing the data makes sure that the ends match up while keeping everything reasonably smooth; this greatly reduces the sort of "spectral leakage".
 
 
**Euclidean Distance :**
 
The Euclidean distance or Euclidean metric is the "ordinary" straight-line distance between two points in Euclidean space. With this distance, Euclidean space becomes a metric space. The associated norm is called the Euclidean norm. Older literature refers to the metric as Pythagorean metric.
 
 
**FFT :**
 
The FFT is a fast, O[N log(⁡N)] algorithm to compute the Discrete Fourier Transform (DFT), which naively is an O[N^2] computation.
 
The FFT operates by decomposing an N point time domain signal into N time domain signals each composed of a single point. The second step is to calculate the N frequency spectra corresponding to these N time domain signals. Lastly, the N spectra are synthesized into a single frequency spectrum.


# Implementation
 
The system was first intended to be developed in the FPGA only without external equipments but it was impossible to do so due to the limited capabilities of the board we are required to implement into, so we divided the project into 2 stages, the front-end (signal acquisition and analysis) and the back-end (pattern matching and estimation, decision making and UI).
 

**Frontend (MATLAB) : **
 
The front end is built into matlab due to the ease of doing DSP on it using builtin functions, we have 2 programs, one for training and obtaining a mean signal and the other for real time operation. steps done in matlab are : 
 
Data Acquisition using microphone.
Windowing & Fast Fourier Transform.
Plotting & Data Transmission.
 
Files in the Frontend : [train.m, recorder.m]
 
 
**Backend (Altera DE0) :**
 
Due to the lack of ADC in Altera DE0 we are transmitting the data from the computer’s microphone using USB to TTL module over the uart protocol, the received data of length (1000) samples are compared then with the saved vectors from the training with matlab, the euclidean distances are calculated and the vector with more probability to be the right one is given a bigger weight, weights are then compared then we are displaying the final results on 7-Segments and LEDs. 
 
The backend was modelled as a Moore Finite State Machine with 4 states (Receiving, Calculating Distance, Decision Making, Displaying Results).
 
Files in the Backend: 
[Voice_Recognition.vhd, uart_tx.vhd, uart_rx.vhd, uart_parity.vhd, uart.vhd]
 

# Design Choices and Work Arounds
 
**Euclidean Distance Calculation :**
 
Calculation of the euclidean distance for 1000 point length vector is very expensive to do in FPGA directly using for loops, so we did a little trick and we calculated the weights of vectors indirectly, by only counting the states where the distance equals zero, this approach is similar to using K-nearest neighbour in machine learning. 
 
**FFT Points Discarding :**
 
Due to the irrelevance of all the frequencies we only took 1000 points and discarded the whole signal, also while taking the FFT we discarded half the signals due to symmetry of the output. 
 
**Moore FSM :**

The design was made in moore machine for automatic recognition and to decrease the user interaction with the system, also for complexity reduction.
 
**UART Module :**
 
UART was used in the module for transmitting data due to the limitations of the FPGA Board, and due to the simplicity of implementation and availablitiy of conversion modules in the market.


 
# Conclusion : 
 
It was shown here that it is possible to implement a basic speech recognition system on Altera DE0 and it’s possible to overcome the limited capabilities of the hardware by many software workarounds.
 
The system is able to successfully recognize two digits (1 and 0) to a great accuracy for the same speaker. The system speaker dependent to a great extent due to the low number of testing samples, this can be improved by making a bigger dataset from various speakers, also by calculating and comparing the MFCCs with FFT the application will be more effective and with a very high accuracy.
 
The availability of more powerful hardware, will allow me to easily implement more robust algorithms like Hidden Markov Models and use more powerful ADC Chips to record sound more purely resulting in more accurate results. 
