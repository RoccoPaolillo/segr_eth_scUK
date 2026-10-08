

# df_groupexp %>% group_by(year, subgroup) %>% summarise(test = sum(exposure))

df_groupexp <- df_groupexp %>%
  mutate(
    
    # simplify focal subgroup
    subgroup_simple = subgroup %>%
      str_remove("^asian_") %>%
      str_remove("^black_") %>%
      str_remove("^white_") %>%
      str_remove("^mixed_"),
    
    macro_eth = subgroup %>%
      str_remove("^asian_") %>%
      str_remove("^black_") %>%
      str_remove("^white_") %>%
      str_remove("^mixed_") %>%
      str_remove("_sc[1-7]$") %>%
      str_to_title(),
    
    macro_sc = subgroup %>%
      str_extract("sc[1-7]$") %>%
      str_to_title(),
    
    # identify ethnicity of reference group
    ethnic_group_ref = reference_group %>%
      str_remove("_sc[1-7]$") %>%
      str_remove("^asian_") %>%
      str_remove("^black_") %>%
      str_remove("^white_") %>%
      str_remove("^mixed_") %>%
      str_to_title(),
    
    sc_group_ref = reference_group %>%
      str_extract("sc[1-7]$") %>%
      str_to_title()
    
  ) %>%
  group_by(
    year,
    subgroup_simple,
    macro_eth,
    macro_sc,
    reference_group,
    ethnic_group_ref,
    sc_group_ref
  ) %>%
  summarise(
    exposure_reference_group = sum(exposure, na.rm = TRUE),
    .groups = "drop"
  )

write_xlsx(df_groupexp,"index_table/df_groupexp.xlsx")

df_groupexpeth <- df_groupexp %>%
  group_by(
    year,
    subgroup_simple,
    macro_eth,
    macro_sc, 
    ethnic_group_ref 
  ) %>%
  summarise(
    exposure_reference_ethnic = sum(exposure_reference_group, na.rm = TRUE),
    .groups = "drop"
  )
write_xlsx(df_groupexpeth,"index_table/df_groupexpeth.xlsx")

df_groupexpsc <- df_groupexp %>%
  group_by(
    year,
    subgroup_simple,
    macro_eth,
    macro_sc, 
    sc_group_ref 
  ) %>%
  summarise(
    exposure_reference_sc = sum(exposure_reference_group, na.rm = TRUE),
    .groups = "drop"
  )
write_xlsx(df_groupexpsc,"index_table/df_groupexpsc.xlsx")

# Moran's I local

borough_sf <- shapefile_df %>%
  group_by(borough, year) %>%
  summarise(
    frac_total_asian = first(frac_total_asian),
    .groups = "drop"
  )

borough_sf_2001 <- borough_sf %>%
  filter(year == 2001)

nb <- poly2nb(borough_sf_2001)
lw <- nb2listw(nb)

localI <- localmoran(
  borough_sf_2001$frac_total_asian,
  lw
)

borough_sf_2001$localI <- localI[, "Ii"]
borough_sf_2001$localI_p <- localI[, "Pr(z != E(Ii))"]

ggplot(borough_sf_2001) +
  geom_sf(aes(fill = localI)) +
  theme_void()

mean_asian <- mean(borough_sf_2001$frac_total_asian, na.rm = TRUE)

lag_asian <- lag.listw(
  lw,
  borough_sf_2001$frac_total_asian
)

borough_sf_2001$lag_asian <- lag_asian
borough_sf_2001 %>%
  filter(borough == "harrow") %>%
  select(frac_total_asian, lag_asian, localI, localI_p)
