

## Annual Historical Disturbances

```{r all disturbances, echo=FALSE, message=FALSE, warning=FALSE, out.width="100%"}
bps_transitions <- read_csv("data/bps_transitions.csv",
                            show_col_types = FALSE)

bpsdist <- data %>%
  filter(MAP_UNIT_S == params$MAP_UNIT_S) %>%
  select(-c(1:10, 13:19)) %>%
  group_by(BPS_MODEL) %>%
  summarize(ACRES = sum(ACRES))



bpsdist <-  left_join(bpsdist, bps_transitions, 
                      by = c("BPS_MODEL" = "Model_Code")) %>%
  mutate(annual_dist_acres = annual_probability*ACRES,
         show_col_types = FALSE) 


# The data frame is then filtered to exclude certain values in the "TransitionGroupID" column. 
# The excluded values are: "All Fire", "All Transitions", "Alternative Succession", 
# "Non Fire Disturbances", "Non Replacement Fire", "Optional 1", "Optional 2".
bpsdist <- bpsdist %>%
  filter(!TransitionGroupID %in% c("All Fire",
                                   "All Transitions",
                                   "Alternative Succession",
                                   "Non Fire Disturbances",
                                   "Non Replacement Fire",
                                   "Optional 1",
                                   "Optional 2")) 

# The data frame is then grouped by the "BpS_Name" and "TransitionGroupID" columns. 
# The annual_dist_acres column is then summarized with the sum of all values for each group. 
bpsdist <- bpsdist %>%
  group_by(BpS_Name, TransitionGroupID) %>%
  summarise(annual_dist_acres = sum(annual_dist_acres)) 

# The annual_dist_acres column is then converted to a numeric format, 
# with trailing zeros removed and rounded to 0 decimal places.

###bpsdist <- bpsdist %>% 
###mutate(annual_dist_acres = as.numeric(format(round(annual_dist_acres, 0), scientific = FALSE)))

# A new data frame "sdbps_aoi_disturbances" is created, 
# with a highlight function applied to the original data frame.
sdbps_aoi_disturbances <- highlight_key(bpsdist)

# A ggplot chart is created using the "sdbps_aoi_disturbances" data frame. 
# The chart plots the TransitionGroupID column on the X-axis, 
# and the annual_dist_acres column on the Y-axis. 
# The chart has a title, labels for the X and Y axes, 
# and the Y-axis has a continuous scale with comma formatted labels.
bpsChart <- 
  ggplot(sdbps_aoi_disturbances, aes(x = TransitionGroupID, y = annual_dist_acres)) +
  geom_point(size = 3) +
  labs(
    title = "Annual historical disturbances",
    x = "",
    y = "Acres") +
  coord_flip() +
  scale_y_continuous(labels = comma)+
  theme_bw()

# The chart is displayed.
#bpsChart

# A chart with a dropdown list is created with tooltips disabled.
bscols(widths = c(3, 10),
       filter_select("BP", 
                     "Select ecosystem", 
                     sdbps_aoi_disturbances, 
                     ~ BpS_Name,
                     multiple = FALSE),
       ggplotly(bpsChart,
                tooltip = FALSE,
                width = 815)
)
```

