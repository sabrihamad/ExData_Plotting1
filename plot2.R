##use bash to grep entries with needed dates to create a subset and save them to assignment1.txt
createSubFile<-function(path){
    rawfilepath=paste0(path,"/household_power_consumption.txt")
    destfile=paste0(path,"/assignment1.txt")
    cmd=paste0("cat <(head -n1 ",rawfilepath,")"," <(grep -w '2/2/2007\\|1/2/2007' ",rawfilepath,") ",paste0(">",destfile))
    system(paste("/bin/bash -c", shQuote(cmd)))
    destfile
}
##read the subset file

readFile<-function(destfile){
    read.table(destfile,sep=";",header=TRUE,na.strings="?")
}

main<-function(path){
    destfile<-createSubFile(path)
    data<-readFile(destfile)
    paste(data$Date,data$Time)->data$Date
    data$Time<-NULL
    strptime(data$Date,"%d/%m/%Y %H:%M:%S")->data$Date
    with(data,plot(Date,Global_active_power,type = "l",ylab="Global Active Power (kilowatts)",xlab=""))
    dev.copy(png,paste0(path,'/assignment1/plot2.png'))
    dev.off()
}

