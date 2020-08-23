*Discounting equations:

$MACRO  discfact(i,t)           1/(1+i)**t

$MACRO  sumdiscfact(T,i,n)      sum(n$(ord(n)<=T),discfact(i,(ord(n)-1)))

$MACRO  intdiscfact(i,t,tt)      sum(tt$(ord(tt)>=ord(t)),1/(1+i)**(ord(tt)-ord(t)))

$MACRO  discounting(Time,i,n,t,tt)  intdiscfact(i,t,tt)/sumdiscfact(Time,i,n)


* Solar position equations used for CSP implementation (Parameters described in power sub-model):
* the parameter table "Dayofyear" in the power sub-model.
* long and lat are specificed in power sub-model for each region;

$MACRO   earthpos(Dayofyear)            ((Dayofyear-1)*360/365)


$MACRO   EOT(Dayofyear)                  (229.2*(0.000075+0.001868*COS(earthpos(Dayofyear)*pi/180)-0.032077*SIN(earthpos(Dayofyear)*pi/180)-0.014615*COS(2*(earthpos(Dayofyear)*pi/180))-0.04089*SIN(2*(earthpos(Dayofyear)*pi/180))))

$MACRO   solhr(hr,Dayofyear,long,tzone)       (((1$(frac(hr/24)=0)+frac(hr/24))*24*60-(long-tzone)*4+EOT(Dayofyear)))/60
$MACRO   hourangle(solhour)                   (solhour-12)*360/24

$MACRO   soldecl(Dayofyear)              (0.3963723-22.9132745*COS(earthpos(Dayofyear)*pi/180)+4.0254304*SIN(earthpos(Dayofyear)*pi/180)-0.387205*COS(2*earthpos(Dayofyear)*pi/180)+0.05196728*SIN(2*earthpos(Dayofyear)*pi/180)-0.1545267*COS(3*earthpos(Dayofyear)*pi/180)+0.0847977*SIN(3*earthpos(Dayofyear)*pi/180))
$MACRO   solalt(hrangle,solardeclination,lat)   (arcsin(COS(lat*pi/180)*COS(hrangle*pi/180)*COS(solardeclination*pi/180)+SIN(lat*pi/180)*SIN(solardeclination*pi/180))*180/pi)
$MACRO   solazim(hrangle,solardeclination,lat,solaralt)  (180/pi*arccos((SIN(solardeclination*pi/180)*COS(lat*pi/180)-COS(solardeclination*pi/180)*SIN(lat*pi/180)*COS(hrangle*pi/180))/COS(solaralt*pi/180)))
$MACRO   Gamma(solarazimuth,surfaceazimuth)  (ABS(solarazimuth-surfaceazimuth))


$MACRO   Incidence(solaralt,gammaa,orientation)    (180/pi*arccos(COS(solaralt*pi/180)*COS(gammaa*pi/180)*SIN(orientation*pi/180)+SIN(solaralt*pi/180)*COS(orientation*pi/180)))
*orientation is the tilt angle of the surface, 0 for horizontal surfaces and 90 degrees for vertical surfaces.

*tt$(ord(tt)>ord(t)),
*t and tt are the same set
