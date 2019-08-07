data {
  int<lower=0> N;                          // N samples
  int<lower=0> G;                          // G genes
  int<lower=0> T;                          // T tissues
  int<lower=0> D;                          // D diseases
  int<lower=1, upper=G> genes[N];          // Genes
  int<lower=1, upper=T> tissues[D];        // Diseases to Tissues
  int<lower=1, upper=D> diseases[N];       // Diseases
  vector[N] y;                             // Expression value y
}

parameters{
  vector[G] g;                             // Gene Intercept
  vector[G] gs;                            // Error in gene Intercept

  vector[T] tm;                            // Tissue effect mean
  real<lower=0.1, upper=20> ts;            // Tissue effect stdev
  vector[G] t[T];                          // Tissue specific mean

  vector[G] d[D];                          // Disease specific mean
  real<lower=0.1, upper=20> ds;            // Disease effect stdev

  real<lower=0.1> nu;                      // Degrees of freedom
  real<lower=0.1, upper=20> ys;            // Pan-tissue stdev
}

// Model the disease specific expression as a 
// deviation from the population mean distribution 
// across all PDXs.
transformed parameters {
  vector[N] y_hat;
  for (i in 1:N){
    y_hat[i] = g[genes[i]] + d[diseases[i]][genes[i]];
  }
}

model {
  g ~ normal(0, 10);
 
  tm ~ normal(0, 10);
  ts ~ cauchy(0, 4);

  // Sample a value for each tissue 
  // centered at the expected deviation 
  // across all tissues.
  for (i in 1:T){
    t[i] ~ normal(tm[i], ts); 
  }

  // Sample a value for each disease 
  // across the centered value for 
  // the diseases tissue class    
  ds ~ cauchy(0, 4);
  for (i in 1:D){
    d[i] ~ normal(t[tissues[i]], ds);
  }

  // Model the actuall expression value 
  // as a t-distribution
  nu ~ gamma(2, 0.1);
  ys ~ cauchy(0, 4);
  y ~ student_t(nu, y_hat, ys);
}
