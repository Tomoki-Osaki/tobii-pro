// simple local model to fit the gaze data
data {
  int T;
  vector[T] y;
}
parameters {
  vector[T] mu;
  vector[T] delta;
  real<lower=0> s_w; // sd of level
  real<lower=0> s_v; // sd of observation
  real<lower=0> s_z; // sd of drift
}

//model {
//  for (t in 2:T) {
//    mu[t] ~ normal(mu[t-1], s_w);
//  }
//  y ~ normal(mu, s_v);
//}

model {
  for (t in 2:T) {
    mu[t] ~ normal(mu[t-1] + delta[t-1], s_w);
    delta[t] ~ normal(delta[t-1], s_z);
  }
  for (t in 1:T) {
    y[t] ~ normal(mu[t], s_v);
  }
}


