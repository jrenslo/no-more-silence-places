library(tidyverse)
library(maps)
library(zipcode)
library(viridis)
library(choroplethrZip)

nms <- read_delim("zip_code_data.txt", delim = '\t', col_types = 'ccciccc', col_names = c('zip','address','unique_id','page_num','title','date_range','creator'))
data(zipcode)
z = nms %>% group_by(zip) %>% summarize(n_addy = n_distinct(address), n_project = n_distinct(unique_id), n_zips = n())
xm = z[z$n_addy > 1,]
xmz = zipcode %>% inner_join(xm, by=c("zip"))
xmz[is.na(xmz)] <- 0
dx = xmz %>% distinct()
dx$project_fct = cut(dx$n_project, breaks=c(0,1,2,3,4,5,121), labels=c('1','2','3','4','5', '>5'))
df_cnt_zip = data.frame(region = dx$zip, value=dx$n_addy, stringsAsFactors = F)

#zip_choropleth(df_cnt_zip, state_zoom='california', title='Test', num_colors = 1)


us <- map_data('state')

ca <- us[us$region == 'california',]
cadx = dx[dx$state == 'CA' & dx$n_zips > 1,]
p = ggplot(data=cadx, aes(x=longitude, y=latitude))
p = p + geom_point(aes(size = n_zips, color=project_fct), alpha=.75)
p = p + geom_polygon(data=ca, aes(x=long, y=lat, group=group), color='gray', fill=NA, alpha=.35) 
p = p + xlim(-126, -113) + ylim(30,45) + coord_map() + labs(color='Number of Unique Projects', size='Zipcode Mentions')
p = p + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
              panel.background = element_blank(), axis.line = element_blank(),
              axis.text = element_blank(), axis.ticks = element_blank(),axis.title = element_blank()) + scale_size(range=c(1,10), trans = 'sqrt')
p = p + scale_color_brewer(type=seq, palette = 'OrRd')
usdx = dx[dx$n_zips > 1,]
p = ggplot(data=usdx, aes(x=longitude, y=latitude))
p = p + geom_point(aes(size = n_zips, color=project_fct), alpha=.75)
p = p + geom_polygon(data=us, aes(x=long, y=lat, group=group), color='gray', fill=NA, alpha=.35) 
p = p + coord_map() + labs(color='Number of Unique Projects', size='Zipcode Mentions')
p = p + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
              panel.background = element_blank(), axis.line = element_blank(),
              axis.text = element_blank(), axis.ticks = element_blank(),axis.title = element_blank()) + scale_size(range=c(1,10), trans = 'sqrt')
p = p + scale_color_brewer(type=seq, palette = 'OrRd')

cntx = dx[dx$state == 'CA' & dx$n_zips > 1,]
usc = map_data('county')
ct = usc[usc$region == 'california' & usc$subregion %in% c('san francisco', 'alameda'),]


p = ggplot(data=cntx, aes(x=longitude, y=latitude))
p = p + geom_point(aes(size = log(n_zips), color=project_fct), alpha=.75)
p = p + geom_polygon(data=ct, aes(x=long, y=lat, group=group), color='gray', fill=NA, alpha=.35) 
p = p + xlim(-123, -121) + ylim(37,38) + coord_map(projection = 'cylindrical')

p