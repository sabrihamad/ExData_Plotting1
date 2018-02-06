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
    ##plot1
    par(mfrow=c(2,2))
    with(data,plot(Date,Global_active_power,type = "l",ylab="Global Active Power (kilowatts)",xlab=""))
    ##plot2
    with(data,plot(Date,Voltage,type = "l",ylab="Voltage",xlab="datetime"))
    ##plot3
    with(data,plot(Date,Sub_metering_1,type = "l",xlab = "",ylab = "Energy sub metering"))
    points(data$Date,data$Sub_metering_2,type='l',col="red")
    points(data$Date,data$Sub_metering_3,type='l',col="blue")
    legend("topright",lty=1,col=c("black","red","blue"),legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"))
    ##plot4
    with(data,plot(Date,Global_reactive_power,type = "l",xlab="datetime"))
    dev.copy(png,paste0(path,'/assignment1/plot4.png'))
    dev.off()
}

