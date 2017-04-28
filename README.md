# Gothenburg-South-Ocean-Mooring
MATLAB to NetCDF converter for University of Gothenburg Department of Marine Sciences ocean moorings.
Import your data and change the variables 'dataName', and 'dataNameStr' to the new data name.  
The script assumes a string of microcat sensors with each sensor recording temperature, salinity, pressure, depth, and time.
If there is an ADCP sensor, the sensor must be at the top of instrument list (filename.ins).  The ADCP loop records time, u velocity, v velocity, and height.
If the sub directories change, the paths must be edited to the data's new location.
If there is any additional metadata to be added, it must be added at the end of the file in the style of:
netcdf.putAtt(ncid,varid,'Metadata name','Metadata');
