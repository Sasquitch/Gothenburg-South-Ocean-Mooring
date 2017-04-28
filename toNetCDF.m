%Written by David Pasquale
%Davpasquale@gmail.com
%Last Edit on 2/10/2017

dataName = S412; %replace with name of matlab data
dataNameStr = 'S412'; %replace with name of matlab data

filename = [dataNameStr '.nc'];
ncid = netcdf.create(filename, 'NC_WRITE');
%Mab is meters above bottom.
[lenx,numMicrocat] = size(dataName.ins); %find number of sensors
m = 1;
while m < numMicrocat
    
    if string(dataName.ins(m).type) == 'ADCP' % ADCP loop, assumes ADCP is first row in data
        ADCPtime = dataName.ins(m).time;
        [lenx,leny] = size(ADCPtime);
        if lenx > leny
            ADCPtimeDimID = netcdf.defDim(ncid,'ADCP',lenx); %create dimension with len of sensor data
        else
            ADCPtimeDimID = netcdf.defDim(ncid,'ADCP',leny);
        end
        
        ADCPheight = dataName.ins(m).hab;
        [lenx,leny] = size(ADCPheight);
        if lenx > leny
            ADCPheightDimID = netcdf.defDim(ncid,'ADCPheight',lenx);
        else
            ADCPheightDimID = netcdf.defDim(ncid,'ADCPheight',leny);
        end
        heightDimID = netcdf.defDim(ncid,'Height Above Sea Floor',1);
        
        
        ADCPtime_id = netcdf.defVar(ncid,'ADCP Time', 'NC_DOUBLE',ADCPtimeDimID);
        netcdf.putAtt( ncid, ADCPtime_id, 'standard_name', 'time');
        netcdf.putAtt( ncid, ADCPtime_id, 'units', 's');
        netcdf.putAtt( ncid, ADCPtime_id, 'long_name', 'Date and time of the ADCP instrument');
        
        ADCPheight_id = netcdf.defVar(ncid,'ADCP Heights', 'NC_Double',ADCPheightDimID);
        netcdf.putAtt( ncid, ADCPheight_id, 'axis', 'Z');
        netcdf.putAtt( ncid, ADCPheight_id, 'comment', 'Depth above seafloor');
        netcdf.putAtt( ncid, ADCPheight_id, 'units', 'm');
        
        ADCPu_id = netcdf.defVar(ncid,'Eastern Ocean Current', 'NC_DOUBLE',[ADCPtimeDimID,ADCPheightDimID]);
        netcdf.putAtt(ncid, ADCPu_id, 'standard_name', 'eastward_sea_water_velocity');
        netcdf.putAtt(ncid, ADCPu_id, 'units', 'm s-1');
        netcdf.putAtt(ncid, ADCPu_id, 'comment', 'The sensor is an upward looking 150 kHz ADCP (RDI, QuarterMaster). Corrected for magnetic declination by 53 degrees.');
        
        ADCPv_id = netcdf.defVar(ncid,'Northward Ocean Current', 'NC_DOUBLE',[ADCPtimeDimID,ADCPheightDimID]);
        netcdf.putAtt(ncid, ADCPv_id, 'standard_name', 'northward_sea_water_velocity');
        netcdf.putAtt(ncid, ADCPv_id, 'units', 'm s-1');
        netcdf.putAtt(ncid, ADCPv_id, 'comment', 'The sensor is an upward looking 150 kHz ADCP (RDI, QuarterMaster). Corrected for magnetic declination by 53 degrees.');
        
        ADCPu = dataName.ins(m).u; %Grab ADCP data
        ADCPv = dataName.ins(m).v;
        
        netcdf.endDef (ncid); %Begin write to
        
        netcdf.putVar (ncid, ADCPtime_id, ADCPtime); %Write ADCP data to Netcdf
        netcdf.putVar (ncid, ADCPu_id, ADCPu);
        netcdf.putVar (ncid, ADCPv_id, ADCPv);
        netcdf.putVar (ncid, ADCPheight_id, ADCPheight);
        
        netcdf.reDef(ncid); %Restart reDefine mode
        
    else
        heightDimID = netcdf.defDim(ncid,['Height Above Sea Floor' num2str(m)],1);
        ins = dataName.ins(m);
        
        microcatTime = dataName.ins(m).time;
        [lenx,leny] = size(microcatTime);
        DimIDName = []; %#ok<*NASGU> %clear for sequent iterations
        DimIDName = ['Microcat Size ' num2str(m)];
        
        if lenx > leny
            microcatDimID = netcdf.defDim(ncid, DimIDName,lenx);
        else
            microcatDimID = netcdf.defDim(ncid, DimIDName,leny);
        end
        
        
        microcatTemp_id = netcdf.defVar(ncid,['Temperature Array ' num2str(m)],'NC_DOUBLE', microcatDimID); %Asign local variables to microcat data
        netcdf.putAtt (ncid, microcatTemp_id, 'long_name', 'List of all microcat temperatures');
        netcdf.putAtt( ncid, microcatTemp_id, 'standard_name', 'sea_water_temperature');
        netcdf.putAtt( ncid, microcatTemp_id, 'units', 'K');
        
        microcatSal_id = netcdf.defVar(ncid,['Salinity Array' num2str(m)], 'NC_DOUBLE', microcatDimID);
        netcdf.putAtt(ncid, microcatSal_id, 'long_name', 'List of all microcat salinity measurements');
        netcdf.putAtt(ncid, microcatSal_id, 'standard_name', 'sea_water_salinity');
        netcdf.putAtt(ncid, microcatSal_id, 'units', '1e-3');
        
        microcatPress_id = netcdf.defVar(ncid,['Pressure Array' num2str(m)], 'NC_DOUBLE', microcatDimID);
        netcdf.putAtt(ncid, microcatPress_id, 'long_name', 'List of all microcat pressures');
        netcdf.putAtt(ncid, microcatPress_id, 'standard_name', 'sea_water_pressure');
        netcdf.putAtt(ncid, microcatPress_id, 'units', 'dbar');
        
        microcatDepths_id = netcdf.defVar(ncid,['Depth' num2str(m)], 'NC_DOUBLE',heightDimID);
        netcdf.putAtt( ncid, microcatDepths_id, 'standard_name', 'depth');
        netcdf.putAtt( ncid, microcatDepths_id, 'axis', 'Z');
        netcdf.putAtt( ncid, microcatDepths_id, 'comment', 'Depth above seafloor');
        netcdf.putAtt( ncid, microcatDepths_id, 'units', 'm');
        
        microcatTime_id = netcdf.defVar(ncid,['Microcat Time' num2str(m)], 'NC_DOUBLE', microcatDimID);
        netcdf.putAtt( ncid, microcatTime_id, 'long_name', 'Date and time of the Microcat Array');
        netcdf.putAtt( ncid, microcatTime_id, 'standard_name', 'time');
        netcdf.putAtt( ncid, microcatTime_id, 'units', 's');
        
        microcatTemp = dataName.ins(m).t; %Assign Data
        microcatSal = dataName.ins(m).s;
        microcatPress = dataName.ins(m).p;
        microcatDepth = dataName.ins(m).hab;
        
        netcdf.endDef (ncid); %Begin write to
        
        netcdf.putVar (ncid, microcatTemp_id, microcatTemp); %Write microcat data to netcdf file
        netcdf.putVar (ncid, microcatSal_id, microcatSal);
        netcdf.putVar (ncid, microcatPress_id, microcatPress);
        netcdf.putVar (ncid, microcatDepths_id, microcatDepth);
        netcdf.putVar (ncid, microcatTime_id, microcatTime);
        
        netcdf.reDef(ncid); %Restart reDefine mode
        
    end
    m = m+1;
end
varid = netcdf.getConstant('NC_GLOBAL'); %Define global attributes
netcdf.putAtt(ncid,varid,'ncei_template_version','NCEI_NetCDF_Timeseries_Template_v2.0');
netcdf.putAtt(ncid,varid,'featureType','timeSeries');
netcdf.putAtt(ncid,varid,'Depth', dataName.depth);
netcdf.putAtt(ncid,varid,'Conventions','CF-1.6');
% netcdf.putAtt(ncid,varid,'naming_authority','edu.columbia.ldeo');
currTime = ['File Created on ' datestr(now)];
netcdf.putAtt(ncid,varid,'date_created',currTime);
netcdf.putAtt(ncid,varid,'date_modified',currTime);
netcdf.putAtt(ncid,varid,'Institution','University of Gothenburg Department of Marine Sciences');
netcdf.putAtt(ncid,varid,'Latitude',dataName.lat);
netcdf.putAtt(ncid,varid,'Longitude',dataName.lon);
%netcdf.putAtt(ncid,varid,'DeploymentCruise',d1.deploymentCruise);
%netcdf.putAtt(ncid,varid,'Project Name',d1.moorID); %File name
netcdf.putAtt(ncid,varid, 'publisher_name', 'US National Centers for Environmental Information');
netcdf.putAtt(ncid,varid, 'publisher_email', 'ncei.info@noaa.gov');
netcdf.putAtt(ncid,varid, 'publisher_url','https://www.ncei.noaa.gov');
netcdf.putAtt(ncid,varid, 'creator_name', 'Anna Wahlin');
netcdf.putAtt(ncid,varid, 'creator_email', 'anna.wahlin@marine.gu.se');
netcdf.putAtt(ncid,varid, 'institution','University of Gothenburg');
netcdf.putAtt(ncid,varid, 'creator_url','http://marine.gu.se/english');
netcdf.putAtt(ncid,varid, 'title','ISO 19115-2 Geographic Information - Metadata - Part 2: Extensions for Imagery and Gridded Data');
netcdf.putAtt(ncid,varid, 'notes','WATER TEMPERATURE, SALINITY, and CURRNET VELOCITIES collected using RVIB Oden and RVIB Araon in the Amundsen Sea from 2010-02-15 to 2014-01-24');
netcdf.putAtt(ncid,varid, 'contributor_name',['Suggested Author List: Wahlin, Anna;Assmann, Karen;Arneborg, Lars;Björk, Göran;Kalen, Ola;University of Gothenburg, Sweden' ...
'Darelius, Elin; University of Bergen' ...
'Stranne, Christian; University of Stockholm' ...
'Lee, SangHoon; Kim, Tae Wan; Korea Polar Research Institute, Incheon, Republic of Korea' ...
'Ha, Ho Kyung; Inha University, Republic of Korea']);
netcdf.putAtt(ncid,varid, 'sea_name','Amundsen Sea');

netcdf.putAtt(ncid,varid, 'references', ['Arneborg, L., Wåhlin, A. K., Björk, G., Liljebladh, B., &amp; Orsi, A. H. (2012). Persistent inflow of warm water onto the central Amundsen shelf. Nature Geoscience, 5(12), 876-880. doi:10.1038/ngeo1644'  ...
'Kalén, O., Assmann, K. M., Wåhlin, A. K., Ha, H. K., Kim, T. W., &amp; Lee, S. H. (2015). Is the oceanic heat flux on the central Amundsen sea shelf caused by barotropic or baroclinic currents? Deep Sea Research Part II: Topical Studies in Oceanography. doi:10.1016/j.dsr2.2015.07.014 ' ...
'Kim, T. W., Ha, H. K., Wåhlin, A. K., Lee, S. H., Kim, C. S., Lee, J. H., &amp; Cho, Y. K. (2017). Is Ekman pumping responsible for the seasonal variation of warm circumpolar deep water in the Amundsen Sea? Continental Shelf Research, 132, 38-48. doi:10.1016/j.csr.2016.09.005 ' ...
'Wåhlin, A. K., Kalén, O., Arneborg, L., Björk, G., Carvajal, G. K., Ha, H. K., . . . Stranne, C. (2013). Variability of Warm Deep Water Inflow in a Submarine Trough on the Amundsen Sea Shelf. Journal of Physical Oceanography, 43(10), 2054-2070. doi:10.1175/jpo-d-12-0157.1 ' ...
'Wåhlin, A. K., Kalén, O., Assmann, K. M., Darelius, E., Ha, H. K., Kim, T. W., &amp; Lee, S. H. (2015). Sub-inertial oscillations on the Amundsen Sea shelf, Antarctica. Journal of Physical Oceanography, 151030091929009. doi:10.1175/jpo-d-14-0257.1']);

netcdf.close(ncid);