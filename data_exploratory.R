library(icesTAF)
library(ggplot2)
library(dplyr)

# Set the theme for plots----------
theme_set(
  theme_bw(base_size = 10) +
    theme(plot.title = element_text(hjust = 0.5, face = "bold", size = 12))
)

# Grid for all relationships-----------
p <- ggplot(data, aes(x = Ecological.Characteristic, y = Pressure, fill = Overlap)) +
  geom_tile() +
  facet_wrap(~Sector) +
  scale_fill_brewer(palette = "Spectral", direction = -1) +
  theme(
    axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1),
    legend.position = "top"
  ) +
  xlab("Ecological Component")
ggsave("overlap_eco_press.png", width = 30, height = 30, units = "cm", dpi = 150)

p <- ggplot(data, aes(x = Ecological.Characteristic, y = Pressure, fill = DoI)) +
  geom_tile() +
  facet_wrap(~Sector) +
  scale_fill_brewer(palette = "Spectral", direction = -1) +
  theme(
    axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1),
    legend.position = "top"
  ) +
  xlab("Ecological Component")
ggsave("doi_eco_press.png", width = 30, height = 30, units = "cm", dpi = 150)

p <- ggplot(data, aes(x = Ecological.Characteristic, y = Pressure, fill = Frequency)) +
  geom_tile() +
  facet_wrap(~Sector) +
  scale_fill_brewer(palette = "Spectral", direction = -1) +
  theme(
    axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1),
    legend.position = "top"
  ) +
  xlab("Ecological Component")
ggsave("frequency_eco_press.png", width = 30, height = 30, units = "cm", dpi = 150)

p <- ggplot(data, aes(x = Ecological.Characteristic, y = Pressure, fill = ImpactRisk)) +
  geom_tile() +
  facet_wrap(~Sector) +
  scale_fill_distiller(palette = "Spectral", direction = -1) +
  theme(
    axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1),
    legend.position = "top"
  ) +
  xlab("Ecological Component")
ggsave("ImpactRisk_eco_press.png", width = 30, height = 30, units = "cm", dpi = 150)



# Grid - Separated Plots--------------

mkdir("separate")

# remove  backslash from names for safe file names
data <- data |> mutate(Sector = gsub("/", " ", Sector))
data <- data |> mutate(Pressure = gsub("/", " ", Pressure))

for (s in unique(data$Sector)) {
  p <- ggplot(data |> filter(Sector == sprintf(s, "%s")), aes(x = Ecological.Characteristic, y = Pressure, fill = Overlap)) +
    geom_tile() +
    facet_wrap(~Sector) +
    theme_bw() +
    scale_fill_brewer(palette = "Spectral", direction = -1) +
    theme(
      axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1),
      legend.position = "top"
    )
  ggsave(paste0("separate/overlap_eco_press_", sprintf(s, "%s"), ".png"), width = 15, height = 15, units = "cm", dpi = 300)
}

for (s in unique(data$Pressure)) {
  p <- ggplot(data |> filter(Pressure == sprintf(s, "%s")), aes(x = Ecological.Characteristic, y = Sector, fill = DoI)) +
    geom_tile() +
    facet_wrap(~Pressure) +
    theme_bw() +
    scale_fill_brewer(palette = "Spectral", direction = -1) +
    theme(
      axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1),
      legend.position = "top"
    )
  ggsave(paste0("separate/doi_eco_press_", sprintf(s, "%s"), ".png"), width = 15, height = 15, units = "cm", dpi = 300)
}

for (s in unique(data$Sector)) {
  p <- ggplot(data |> filter(Sector == sprintf(s, "%s")), aes(x = Ecological.Characteristic, y = Pressure, fill = Frequency)) +
    geom_tile() +
    facet_wrap(~Sector) +
    theme_bw() +
    scale_fill_brewer(palette = "Spectral", direction = -1) +
    theme(
      axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1),
      legend.position = "top"
    )
  ggsave(paste0("separate/freq_eco_press_", sprintf(s, "%s"), ".png"), width = 15, height = 15, units = "cm", dpi = 300)
}
