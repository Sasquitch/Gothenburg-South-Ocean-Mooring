# Gothenburg-South-Ocean-Mooring
MATLAB to NetCDF converter for University of Gothenburg Department of Marine Sciences ocean moorings. 
The script assumes a string of microcat sensors with each sensor recording temperature, salinity, pressure, depth, and time.

File for converting the mooring data files from Columbia university to MATLAB.

To run the file begin by importing the desired data into MATLAB underneath the 'Home' tab -> 'Import Data'.
Then, change the variables 'dataName', and 'dataNameStr' on the beginning of the script  tothe new data file name.  

When the script is run, it will gather any desired information and add it to a NetCDF file generated in the same folder as the script.

To add any information to the NetCDF file, it can be added in the %Global Attributes section of the script using the format:

netcdf.putAtt(ncid,varid,'Data Name',data);

Example using bioluminescence data located in the d1 folder: netcdf.putAtt(ncid,varid,'Bioluminescence',d1.Bioluminescnece);

If any errors occur on run, information the script is looking for is not located in the data package or not in the path it is pointing towards. If the data the script is searching for is not in the data package, one solution is to comment the section of data throwing the error.

If the data is located in the data file and the MATLAB script is not in the path the script is directed towards, the path must be changed. This can be altered using the format: folder1.folder2.folder3.dataName
