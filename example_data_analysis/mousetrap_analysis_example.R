library(tidyverse)
library(mousetrap)

raw <- read_csv("./example_data_analysis/2022-01-13_CandyCandle-tt-experimental.csv")

mtd <- mt_import_mousetrap(raw, mt_id_label = "log_sequence", verbose = TRUE)

mtd_align <- mt_align_start(mtd, verbose = TRUE)

mtd_sym <- mt_remap_symmetric(mtd_align)

mtd_sym <- mt_time_normalize(mtd_sym, nsteps = 1000)

mt_animate(mtd_sym, xres = 1280, framerate = 24, loop = TRUE,
  timestamps = NULL, seconds = 4, speed = 0.5,
  use = "tn_trajectories",
  im_path = "C:/Program Files/ImageMagick-7.1.0-Q16-HDRI/convert.exe")

mtd_sym$data$type_c <-
  paste(mtd_sym$data$trial_type, mtd_sym$data$trial_subtype)

mt_plot_aggregate(mtd_sym, use = "tn_trajectories", color = "type_c")



mtd_sym$data %>%
  dplyr::filter(type_c == "phono critical" | type_c == "motor critical") %>%
  group_by(type_c) %>%
  summarise(mean_resp_time = mean(response_time), n = n(), .groups = "keep")


mtd_sym$data %>%
  dplyr::filter(type_c == "phono critical" | type_c == "motor critical") %>%
  ggplot(aes(type_c, response_time)) +
  geom_point() +
  stat_summary(fun.data = "mean_cl_boot", colour = "red", size = 1)
