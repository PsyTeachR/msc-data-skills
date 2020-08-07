makeData <- function(n, group_effect, stim_effect, ixn_effect) {
  tibble(
    group = rep(c("A", "B"), n),
    stim_group = rep(c("A", "B"), each = n)
  ) %>%
    mutate(
      dv = rnorm(n*2, 0, 1),
      group_ef = ifelse(group=="B", group_effect/2, -group_effect/2),
      stim_ef = ifelse(stim_group=="B", stim_effect/2, -stim_effect/2),
      ixn = ifelse(group==stim_group, ixn_effect/2, -ixn_effect/2),
      dv = dv + group_ef + stim_ef + ixn
    )
}

makeSummaryData <- function(data) {
  summary_data <- data %>%
    group_by(group, stim_group) %>%
    summarise(
      mean = mean(dv),
      min = mean(dv) - qnorm(0.975)*sd(dv)/sqrt(n()),
      max = mean(dv) + qnorm(0.975)*sd(dv)/sqrt(n())
    )
}