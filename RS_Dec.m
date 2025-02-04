function [decoded, error_pos, error_mag, g, S] = RS_Dec(encoded, m, prim_poly, n, k)
    max_errors = floor((n - k) / 2);
    orig_vals = encoded.x;

    errors = zeros(1, n);
    g = [];
    S = [];

    alpha = gf(2, m, prim_poly);

    Synd = polyval(encoded, alpha .^ (1:n - k));
    Syndromes = trim(Synd);

    if isempty(Syndromes.x)
        decoded = orig_vals(1:k);
        error_pos = [];
        error_mag = [];
        g = [];
        S = Synd;
        return;
    end

    r0 = [1, zeros(1, 2 * max_errors)]; r0 = gf(r0, m, prim_poly); r0 = trim(r0);
    size_r0 = length(r0);
    r1 = Syndromes;
    f0 = gf([zeros(1, size_r0 - 1) 1], m, prim_poly);
    f1 = gf(zeros(1, size_r0), m, prim_poly);
    g0 = f1; g1 = f0;

    while true
        [quotient, remainder] = deconv(r0, r1);
        quotient = pad(quotient, length(g1));

        c = conv(quotient, g1);
        c = trim(c);
        c = pad(c, length(g0));

        g = g0 - c;

        if all(remainder(1:end - max_errors) == 0)
            break;
        end

        r0 = trim(r1); r1 = trim(remainder);
        g0 = g1; g1 = g;
    end

    g = trim(g);

    evalPoly = polyval(g, alpha .^ (n - 1 : - 1 : 0));
    error_pos = gf(find(evalPoly == 0), m);

    if isempty(error_pos)
        decoded = orig_vals(1:k);
        error_mag = [];
        return;
    end

    size_error = length(error_pos);
    Syndrome_Vals = Syndromes.x;
    b(:, 1) = Syndrome_Vals(1:size_error);
    for idx = 1 : size_error
        e = alpha .^ (idx * (n - error_pos.x));
        err = e.x;
        er(idx, :) = err;
    end

    % Solve the linear system
    error_mag = (gf(er, m, prim_poly) \ gf(b, m, prim_poly))';
    
    % Put the error magnitude on the error vector
    errors(error_pos.x) = error_mag.x;
    errors_gf = gf(errors, m, prim_poly);

    decoded_gf = encoded(1:k) + errors_gf(1:k);
    decoded = decoded_gf.x;

end

% Remove leading zeros from Galois array
function gt = trim(g)
    gx = g.x;
    gt = gf(gx(find(gx, 1) : end), g.m, g.prim_poly);
end

% Add leading zeros
function xpad = pad(x, k)
    len = length(x);
    if len < k
        xpad = [zeros(1, k - len) x];
    end
end