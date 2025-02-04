function encoded = RS_Enc(msg, m, prim_poly, n, k)
    alpha = gf(2, m, prim_poly);
    g_x = genpoly(k, n, alpha);

    msg_padded = gf([msg zeros(1, n - k)], m, prim_poly);
    [~, remainder] = deconv(msg_padded, g_x);

    encoded = msg_padded - remainder;
end

function g = genpoly(k, n, alpha)
    g = 1;
    for k = mod(1 : n - k, n)
        g = conv(g, [1 alpha .^ (k)]);
    end
end