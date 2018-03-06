library(maps)
library(ggplot2)

load(file = 'data/top25_grouped_drg.Rda')

state_map <- map_data('state')
state.abb <- append(state.abb, c("DC"))
state.name <- append(state.name, c("District of Columbia"))
top_25$region <- map_chr(top_25$provider_state, function(x) { tolower(state.name[grep(x, state.abb)]) })

df_map <- inner_join(top_25, state_map, by = "region")

states <- ggplot(data = state_map, mapping = aes(x = long, y = lat, group = group)) + 
  coord_fixed(1.3) + 
  geom_polygon(color = "black", fill = "gray")

states

ditch_the_axes <- theme(
  axis.text = element_blank(),
  axis.line = element_blank(),
  axis.ticks = element_blank(),
  panel.border = element_blank(),
  panel.grid = element_blank(),
  axis.title = element_blank()
)

testing <- states + 
  geom_polygon(data = df_map, aes(fill = m), color = "white") +
  geom_polygon(color = "black", fill = NA) +
  theme_bw() +
  ditch_the_axes

testing