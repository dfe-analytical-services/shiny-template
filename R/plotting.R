createAvgRevTimeSeries <- function(dfRevenueBalance,inputArea){

ggplot(dfRevenueBalance, aes(x=year,y=average_revenue_balance,color=area_name)) + 
  geom_line(size = 1.2) +       
  theme_classic() +
  theme(
    text = element_text(size = 24),
    axis.title.x = element_text(margin = margin(t = 12)),
    axis.title.y = element_text(margin = margin(r = 16)),
    axis.line = element_line( size = 1.0),
  ) +
  scale_y_continuous(
    labels = scales::number_format(accuracy = 1, big = ',', prefix='£')) +
  xlab("Academic year end") +
  ylab("Average revenue balance") +
  scale_color_manual(
    "Area",
    breaks = unique(c("England",inputArea)),
    values = c("#f47738", "#1d70b8")
  )     
}