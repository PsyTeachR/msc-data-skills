# setup theme ----

bgcolor <- "black"
textcolor <- "white"
my_theme <- theme(
  plot.background = element_rect(fill = bgcolor, colour = bgcolor),
  panel.background = element_rect(fill = NA),
  legend.background = element_rect(fill = NA),
  legend.position="none",
  panel.grid.major = element_blank(),
  panel.grid.minor = element_blank(),
  text = element_text(colour = textcolor, size=20),
  axis.text = element_text(colour = textcolor, size=15)
)

my_fill <- scale_fill_manual(values = c("#3D99CC", "#898710"))

plot_barplot <- function(data) {
  data %>%
    group_by(group, stim_group) %>%
    summarise(
      mean = mean(dv),
      se = sd(dv)/sqrt(n())
    ) %>%
    ggplot(aes(group, mean, fill=stim_group)) +
    geom_hline(yintercept=0, color=textcolor, size=1) +
    geom_col(color = "white", position="dodge", alpha = 0.75) +
    geom_errorbar(aes(ymin = mean-se, ymax=mean+se), 
                  width=0.1, 
                  position=position_dodge(0.9), 
                  color=textcolor) +
    ylab("DV") +
    xlab("Participant group") +
    my_theme + my_fill
}

plot_boxplot <- function(data) {
  data %>%
    ggplot(aes(group, dv, fill = stim_group)) +
    geom_hline(yintercept=0, color=textcolor, size=1) +
    geom_boxplot(color = textcolor, position = position_dodge(width=0.9), alpha = 0.75) +
    ylab("DV") +
    xlab("Participant group") +
    my_theme + my_fill
}

plot_violin <- function(data) {
  data %>%
    ggplot(aes(group, dv, fill = stim_group)) +
    geom_hline(yintercept=0, color=textcolor, size=1) +
    geom_violin(color=textcolor, trim=FALSE, alpha = 0.75) +
    geom_pointrange(
      data = makeSummaryData(data),
      aes(group, mean, ymin=min, ymax=max),
      shape = 20,
      color = textcolor, 
      position = position_dodge(width = 0.9)
    ) +
    ylab("DV") +
    xlab("Participant group") +
    my_theme + my_fill
}

plot_violinbox <- function(data) {
  data %>%
    ggplot(aes(group, dv, fill = stim_group)) +
    geom_hline(yintercept=0, color=textcolor, size=1) +
    geom_violin(color=textcolor, trim=FALSE, alpha = 0.75) +
    geom_boxplot(color = textcolor, width = 0.25, position = position_dodge(width=0.9)) +
    ylab("DV") +
    xlab("Participant group") +
    my_theme + my_fill
}

plot_splitviolin <- function(data) {
  data %>%
    ggplot(aes(group, dv, fill = stim_group)) +
    geom_hline(yintercept=0, color=textcolor, size=1) +
    geom_split_violin(color=textcolor, trim=FALSE, alpha = 0.75) +
    geom_pointrange(
      data = makeSummaryData(data),
      aes(group, mean, ymin=min, ymax=max),
      shape = 20,
      color = textcolor, 
      position = position_dodge(width = 0.2)
    ) +
    ylab("DV") +
    xlab("Participant group") +
    my_theme + my_fill
}

plot_raincloud <- function(data) {
  data %>%
    ggplot(aes(group, dv, fill = stim_group)) +
    geom_hline(yintercept=0, color=textcolor, size=1) +
    geom_flat_violin(position = position_nudge(x = .25, y = 0), 
                     color=textcolor, trim=FALSE, alpha = 0.75) +
    geom_point(aes(color = stim_group), 
               position = position_jitter(width = .2, height = 0), 
               size = .5, alpha = .75) +
    ylab("DV") +
    xlab("Participant group") +
    coord_flip() +
    scale_color_manual(values = c("#3D99CC", "#898710")) +
    my_theme + my_fill
}