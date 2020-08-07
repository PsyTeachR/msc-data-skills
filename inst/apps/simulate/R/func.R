plot_unif <- function(df) {
  if (is.null(df)) return(ggplot() + theme_bw())
  
  if (length(unique(df$n)) == 1 && unique(df$n) == 1) {
    # all N are 1
    df1 <- df %>%
      group_by(min, max) %>%
      mutate(Sample = paste0("runif(", n(), ", ", min, ", ", max, ")")) %>%
      ungroup()
    
    #ylim(min(df1$min)-0.5, max(df1$max)+0.5) +
  } else {
    df1 <- df %>%
      mutate(Sample = paste0(LETTERS[sample - min(sample) + 1], 
                             ": runif(", n, ", ", min, ", ", max, ")"))
  }
  
  ncolumns <- ceiling(length(unique(df1$Sample))/5)
  
  p <- ggplot(df1, aes(x, fill = Sample))
  
  # make each facet as a separate layer to get bins and boundaries correct
  for (s in unique(df1$Sample)) {
    dat <- filter(df1, Sample == s)
    bd <-  min(dat$min)
    bw <- (max(dat$max) - bd)/20
    p <- p + geom_histogram(data = dat, boundary = bd, 
                            binwidth = bw, color = "black", alpha = 0.2,
                            position = position_dodge(), show.legend = FALSE)
  }
  
  p + facet_wrap(~Sample, ncol = ncolumns, dir = "v", scales = "free_y") +
    theme_bw()
}

plot_norm <- function(df) {
  if (is.null(df)) return(ggplot() + theme_bw())
  
  if (length(unique(df$n)) == 1 && unique(df$n) == 1) {
    # all N are 1
    df1 <- df %>%
      group_by(mu, sd) %>%
      mutate(Sample = paste0("rnorm(", n(), ", ", mu, ", ", sd, ")")) %>%
      ungroup()
  } else {
    df1 <- df %>%
      mutate(Sample = paste0(LETTERS[sample - min(sample) + 1], 
                             ": rnorm(", n, ", ", mu, ", ", sd, ")"))
  }
  
  ncolumns <- ceiling(length(unique(df1$Sample))/5)

  ggplot(df1, aes(x, fill = Sample)) +
    geom_histogram(bins = 50, color = "black", alpha = 0.2,
                   position = position_dodge(), show.legend = FALSE) +
    facet_wrap(~Sample, ncol = ncolumns, dir = "v", scales = "free_y") +
    theme_bw()
}

plot_norm_density <- function(df) {
  if (is.null(df)) return(ggplot() + theme_bw())
  
  if (length(unique(df$n)) == 1 && unique(df$n) == 1) {
    # all N are 1
    p <- df %>%
      group_by(mu, sd) %>%
      mutate(Sample = paste0("rnorm(", n(), ", ", mu, ", ", sd, ")")) %>%
      ungroup() %>%
      ggplot(aes(x, color = Sample, fill = Sample)) +
      geom_density(alpha = 0.2) + 
      geom_jitter(aes(y = -0.2), width = 0, height = 0.19, 
                  alpha = 1, size = 4, show.legend = FALSE)
  } else {
    p <- df %>%
      mutate(Sample = paste0(LETTERS[sample - min(sample) + 1], 
                             ": rnorm(", n, ", ", mu, ", ", sd, ")")) %>%
      ggplot(aes(x, color = Sample, fill = Sample)) +
      geom_density(alpha = 0.2) + 
      geom_jitter(aes(y = -0.2, alpha = (1/(log(n, 10) + 1))), 
                  width = 0, height = 0.19, show.legend = FALSE)
  }
  
  xmin <- min(df$x) %>% floor()
  xmax <- max(df$x) %>% ceiling()
  
  # ceiling to nearest 0.25 y-value (min 0.5)
  plotymax <- layer_scales(p)$y$range$range[2]
  ymax <- max(0.5, ceiling(plotymax/0.25)*0.25)
  
  p + coord_cartesian(xlim = c(xmin, xmax), ylim = c(-0.5, ymax)) +
    theme_bw()
}


plot_binom <- function(df) {
  if (is.null(df)) return(ggplot() + theme_bw())
  
  if (length(unique(df$n)) == 1 && unique(df$n) == 1) {
    # all N are 1
    df1 <- df %>%
      group_by(size, prob) %>%
      mutate(Sample = paste0("rbinom(", n(), ", ", size, ", ", prob, ")")) %>%
      ungroup()
  } else {
    df1 <- df %>%
      mutate(Sample = paste0(LETTERS[sample - min(sample) + 1], 
                             ": rbinom(", n, ", ", size, ", ", prob, ")"))
  }
  
  ncolumns <- ceiling(length(unique(df1$Sample))/5)
  
  ggplot(df1, aes(x, fill = Sample)) +
    geom_histogram(binwidth = 1, color = "black", alpha = 0.2,
                   position = position_dodge(), show.legend = FALSE) +
    scale_x_continuous(
      breaks = 0:max(df1$size),
      limits = c(-0.5, max(df1$size) + 0.5)
    ) +
    xlab("Number of successes") + 
    facet_wrap(~Sample, ncol = ncolumns, dir = "v") +
    theme_bw()
}

plot_pois <- function(df) {
  if (is.null(df)) return(ggplot() + theme_bw())
  
  if (length(unique(df$n)) == 1 && unique(df$n) == 1) {
    # all N are 1
    df1 <- df %>%
      group_by(lambda) %>%
      mutate(Sample = paste0("rpois(", n(), ", ", lambda, ")")) %>%
      ungroup()
  } else {
    df1 <- df %>%
      mutate(Sample = paste0(LETTERS[sample - min(sample) + 1], 
                             ": rpois(", n, ", ", lambda, ")"))
  }
  
  ncolumns <- ceiling(length(unique(df1$Sample))/5)
  
  ggplot(df1, aes(x, fill = Sample)) +
    geom_histogram(binwidth = 1, color = "black", alpha = 0.2,
                   position = position_dodge(), show.legend = FALSE) +
    scale_x_continuous(
      breaks = 0:max(df1$x),
      limits = c(-0.5, max(df1$x) + 0.5)
    ) +
    facet_wrap(~Sample, ncol = ncolumns, dir = "v") +
    theme_bw()
}