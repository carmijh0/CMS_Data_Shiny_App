library(maps)
library(ggplot2)

load(file = 'data/dfin_2015.Rda')

#---------------------------------------------------------------------------------------

map_data <- separate(data = dfin_2015, col = drg_definition, into = c("drg", "definition"), sep = " - ")

map <- map_data %>%
  group_by(provider_state, drg) %>% 
  summarize(mean_total_discharges = mean(as.numeric(total_discharges)),
            mean_total_charges = mean(as.numeric(average_covered_charges)),
            mean_total_payments = mean(as.numeric(average_total_payments)),
            mean_medicare_payments = sum(as.numeric(average_medicare_payments)))

state_map <- map_data('state')
state.abb <- append(state.abb, c("DC"))
state.name <- append(state.name, c("District of Columbia"))
map$region <- map_chr(map$provider_state, function(x) { tolower(state.name[grep(x, state.abb)]) })

# df_map <- inner_join(top_25, state_map, by = "region")
# 
# states <- ggplot(data = state_map, mapping = aes(x = long, y = lat, group = group)) + 
#   coord_fixed(1.3) + 
#   geom_polygon(color = "black", fill = "gray")
# 
# states
# 
# ditch_the_axes <- theme(
#   axis.text = element_blank(),
#   axis.line = element_blank(),
#   axis.ticks = element_blank(),
#   panel.border = element_blank(),
#   panel.grid = element_blank(),
#   axis.title = element_blank()
# )
# 
# testing <- states + 
#   geom_polygon(data = df_map, aes(fill = m), color = "white") +
#   geom_polygon(color = "black", fill = NA) +
#   theme_bw() +
#   ditch_the_axes
# 
# testing

# df_map <- df_map %>% 
#   group_by(region) %>%
#   mutate(m = mean(as.integer(average_covered_charges)))
#   ggplot(aes(x = long, y = lat, group = group, fill = m)) + 
#   geom_polygon() + 
#   geom_path(color = 'white') + 
#   scale_fill_continuous(low = "lightblue", 
#                         high = "dodgerblue4",
#                         name = '$') + 
#   theme_map() + 
#   coord_map('albers', lat0=30, lat1=40) + 
#   ggtitle("Mean Covered Charges for all Procedures") + 
#   theme(plot.title = element_text(hjust = 0.5))
