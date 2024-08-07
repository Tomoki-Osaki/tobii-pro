setwd("C:/Users/Tomoki/OneDrive/Documents/tobiipro")
library(rstan)
rstan_options(auto_write = T)
options(mc.cores = parallel::detectCores())
library(ggplot2)
library(bayesplot)
library(tidyr)

df_ratio <- read.csv("aoi_ratios.csv")
df_all <- read.csv("all_gaze.csv")
cols <- colnames(df_all)
plot(df_all["Gaze.point.X"])
gaze_point_x <- df_all["Gaze.point.X"]
gaze_point_x <- drop_na(gaze_point_x) 

gaze_point_y <- df_all["Gaze.point.Y"]
gaze_point_y <- drop_na(gaze_point_y) 

gaze_x_plot <- ggplot(data=gaze_point_x, aes(x = 1:nrow(gaze_point_x), y = Gaze.point.X)) +
  geom_line() +
  geom_point() 

gaze_y_plot <- ggplot(data=gaze_point_y, aes(x = 1:nrow(gaze_point_y), y = Gaze.point.Y)) +
  geom_line() +
  geom_point() 

aoi_plot <- ggplot(data=df_ratio, aes(x = 1:nrow(df_ratio), y=aoi_ratio)) +
  geom_line() +
  geom_point() +
  ylim(0, 1)


data_list <- list(
  y = gaze_point_x$Gaze.point.X,
  T = nrow(gaze_point_x)
)

data_list <- list(
  y = gaze_point_y$Gaze.point.Y,
  T = nrow(gaze_point_y)
)

data_list <- list(
  y = df_ratio$aoi_ratio,
  T = nrow(df)
)

model <- stan(
  file = "stanmodel.stan",
  data = data_list,
  seed = 1,
  iter = 4000,
  warmup = 1000
)

sample <- rstan::extract(model)

res_mu <- c()
for (i in 1:ncol(sample$mu)) {
  ave <- mean(sample$mu[, i])
  res_mu <- c(res_mu, ave)
}
res_mu <- data.frame(
  value = res_mu
)

res_drift <- c()
for (i in 1:ncol(sample$delta)) {
  ave <- mean(sample$delta[, i])
  res_drift <- c(res_drift, ave)
}
res_drift <- data.frame(
  value = res_drift
)

res_df <- data.frame(
  original = gaze_point_y$Gaze.point.Y,
  res_mu = res_mu$value,
  res_drift = res_drift$value
)

res_plot <- ggplot(data = res_df) +
  geom_line(aes(x = 1:nrow(res_df), y = res_mu), linewidth = 0.8) +
  geom_line(aes(x = 1:nrow(res_df), y = original), color = "red", alpha = .3) +
  geom_point(aes(x = 1:nrow(res_df), y = original), color = "red", alpha = .3) 


drift_plot <- ggplot(data = res_df, aes(x = 1:nrow(res_df), y = res_drift)) +
  geom_line(linewidth = 1) 

mu_plot <- ggplot(data = res_df, aes(x = 1:nrow(res_df), y = res_mu)) +
  geom_line() +
  geom_point()

ori_plot <- ggplot(data = res_df, aes(x = 1:nrow(res_df), y = original)) +
  geom_line() +
  geom_point() 




