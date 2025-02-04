% Amirhossein Chami 
clc 
clear 
close all
%%
m = 6;
K = 51;
M = 64;
N = 2^m-1;
Rate = K/N; %Rate
%% Encoder
enc = comm.RSEncoder('BitInput', true, 'MessageLength', K, 'CodewordLength', N);
%% Decoder
dec = comm.RSDecoder('BitInput', true, 'MessageLength', K, 'CodewordLength', N);
%% Error
error = comm.ErrorRate();
%% Data
data = randi([0 1], K*log2(M)*10, 1);
%% Encoded data
encoded_data = step(enc, data);
%% QAM modulator
mod_data = qammod(encoded_data, M, 'InputType', 'bit', 'UnitAveragePower', true, 'PlotConstellation', false);
%% AWGN Channel
k = 1;
Eb_No = zeros(1,14);
BER = zeros(1,14);
for EbNo = 0 : 1 : 13
    SNR_db =EbNo+10*log10(Rate)+10*log10(log2(M));
    awgnchan = comm.AWGNChannel("NoiseMethod", "Signal to noise ratio (SNR)", 'SNR', SNR_db);
    noisy_data = step(awgnchan, mod_data);
    %% QAM demodulator & docoder
    demod_data = qamdemod(noisy_data, M, 'OutputType', 'bit', 'UnitAveragePower', true);
    decoded_data = step(dec, demod_data);
    %% BER
    z = error(decoded_data, data);
    Eb_No(k) = EbNo; 
    BER(k) = z(1); %Bit Error Rate
    k = k+1;
    reset(error);
end
%% Plot : Simulation
semilogy(Eb_No, BER, 'r *-');
grid on
xlabel('Eb/No');
ylabel('Bit Error Rate');
title('Reed-solomon');
%% Plot : Theory 
BER_Theory = bercoding(Eb_No, 'RS', 'hard', N, K, 'qam', M);
hold on
semilogy(Eb_No, BER_Theory, 'b o-');
grid on
xlabel('Eb/No');
ylabel('Bit Error Rate');
legend({'BER : Simulation','BER : Theory'});