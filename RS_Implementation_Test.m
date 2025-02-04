% Amirhossein Chami
clc;
clear; 
close all;

% Parameters
m = 8;                      % Bits per symbol (GF(2^m))
prim_poly = 301;            % Primitive polynomial for GF(2^m)
k = 223;                      % Message length
n = 255;                     % Codeword length
t = floor((n - k)/2);       % Error correction capability (t=2)
max_errors = n - k;         % Maximum errors to test (4)
num_trials = 1000;          % Number of trials per error count

results = struct();
for e = 0:max_errors
    results(e+1).e = e;
    results(e+1).success = 0;       % Correctly decoded
    results(e+1).detected = 0;      % Errors detected
    results(e+1).miscorrected = 0;  % Detected but wrong correction
    results(e+1).undetected = 0;    % Errors present but not detected
end

for e = 0:max_errors
    fprintf('Testing %d errors (%d trials)...\n', e, num_trials);
    for trial = 1:num_trials
        msg = randi([0, 2^m-1], 1, k);
        
        encoded = RS_Enc(msg, m, prim_poly, n, k);
        
        if e > 0
            err_pos = randperm(n, e);
            encoded_noisy = encoded;
            for i = 1:e
                error_val = gf(randi([1, 2^m-1]), m, prim_poly);
                encoded_noisy(err_pos(i)) = encoded_noisy(err_pos(i)) + error_val;
            end
        else
            encoded_noisy = encoded;
        end
        
        [decoded, err_pos_dec, ~, ~, ~] = RS_Dec(encoded_noisy, m, prim_poly, n, k);
        
        is_correct = isequal(decoded, msg);
        errors_detected = ~isempty(err_pos_dec);
        
        results(e+1).success = results(e+1).success + is_correct;
        results(e+1).detected = results(e+1).detected + errors_detected;
        
        if e > 0
            if errors_detected && ~is_correct
                results(e+1).miscorrected = results(e+1).miscorrected + 1;
            elseif ~errors_detected && ~is_correct
                results(e+1).undetected = results(e+1).undetected + 1;
            end
        end
    end
end

% Display performance analysis
fprintf('\nReed-Solomon Code Performance (n=%d, k=%d, t=%d)\n', n, k, t);
fprintf('======================================================\n');
fprintf('Errors | Success   | Detected   | Miscorrected | Undetected\n');
fprintf('------------------------------------------------------------\n');
for e = 0:max_errors
    fprintf('%5d  | %7.2f%%  | %8.2f%%  | %10.2f%%  | %8.2f%%\n', e,...
        results(e+1).success/num_trials*100,...
        results(e+1).detected/num_trials*100,...
        results(e+1).miscorrected/num_trials*100,...
        results(e+1).undetected/num_trials*100);
end
fprintf('======================================================\n');