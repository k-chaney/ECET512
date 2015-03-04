function dbm = pathLossModel(ref_dist, ref_power, beta, shadow_variance, d)

shadow = normrnd(0,shadow_variance);

dbm = power2dbm(ref_power)-10*beta*log10(d/ref_dist)+shadow;

end
