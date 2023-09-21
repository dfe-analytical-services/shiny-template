# Current GSS colours for use in charts. These are taken from the current
# guidance here:
# https://analysisfunction.civilservice.gov.uk/policy-store/data-visualisation-colours-in-charts/
# Note the advice on trying to keep to a maximum of 4 series in a single plot
# (the two commented out hex codes are for the suggested colours for two
# additional series if absolutely necessary).
# 2023-09-21: update made to change hex codes to AF colours package
# guidance here: https://best-practice-and-impact.github.io/afcolours/

gss_colour_pallette <- afcolours::af_colours("categorical", colour_format = "hex", n = 6)
