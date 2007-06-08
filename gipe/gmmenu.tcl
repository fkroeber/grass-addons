###############################################################
# gmmenu.tcl - menu file for GRASS GIS Manager
# January 2006 Michael Barton, Arizona State University
# COPYRIGHT:	(C) 1999 - 2006 by the GRASS Development Team
#
#		This program is free software under the GNU General Public
#		License (>=v2). Read the file COPYING that comes with GRASS
#		for details.
###############################################################

# our job is simply to make a variable called descmenu

#source "$env(GISBASE)/etc/gui/menus/menu.tcl"


global execom 
global mon
global filename
global devnull

# Tear off menus (yes / no)
global tmenu
# Key to use for control (for menu accelerators)
global keyctrl
# The environment
global env



# if extensions dir exists: create an "Xtns" menu item
# and read all menu descriptions from .gem files
set dirName [set env(GISBASE)]/etc/gm/Xtns
set XtnsMenu "False"
set splitError "False"
set XtnsMenuList ""

if { [file exists $dirName] && [file isdirectory $dirName] } {	
	lappend listNames "Dummy"; # we need this to check for num of elements later
	foreach fileName [glob -nocomplain [file join $dirName *.gem]] {
		lappend listNames $fileName
	}
	if { [llength $listNames] > 1 } { #only do this, if there is at least one menu file
		set listNames [lreplace $listNames 0 0]; # let's get rid of the dummy element
		set listNames [lsort $listNames]
		#now read each menu file and append to list
		foreach fileName $listNames {
			set inputFile [open $fileName "r"]
			set line [read $inputFile]
			set splitLines [split $line "\n"]
			if { [llength $splitLines] == 1 } {
				# splitting didn't work.
				# maybe we have Mac style newlines, let's split again!
				set splitLines [split $line "\r"]
			}
			# split up into individual lines for processing
			foreach line $splitLines {
				# strip off comments
				set commentPos [string first "#" $line]
				# 1.: leading comment
				if { $commentPos == 0 } {
					set line ""
				}
				if { $commentPos > 0 } {
					set line [string range $line 0 [expr $commentPos-1]]
				}					
				set line [subst $line]; # substitute variables like $tmenu
				lappend splitLinesDone $line
			}
			# now join individual lines back into one string ...
			set line [join $splitLinesDone]
			# ... and append to list of submenus
			lappend XtnsMenuList [subst {$line}]
			set splitLinesDone ""
			close $inputFile
		}
		set XtnsMenu "True"
	}
}
		

# This is the menu. 

set descmenu [subst  {
 {[G_msg "&File"]} all file $tmenu {
	{cascad {[G_msg "Workspace"]} {} "" $tmenu {			
		{command {[G_msg "Open..."]} {} "Open gis.m workspace file" {} -accelerator $keyctrl-O -command { Gm::OpenFileBox }}
		{command {[G_msg "Save"]} {} "Save gis.m workspace file" {} -accelerator $keyctrl-S -command { Gm::SaveFileBox }}
		{command {[G_msg "Save as..."]} {} "Save gis.m workspace file as new name" {} -command { set filename($mon) "" ; Gm::SaveFileBox }}
		{command {[G_msg "Close"]} {} "Close gis.m workspace" {} -accelerator $keyctrl-W -command { GmTree::FileClose {}}}
	}}
	{cascad {[G_msg "Import"]} {} "" $tmenu {			
		{cascad {[G_msg "Raster map"]} {} "" $tmenu {
			{command {[G_msg "Multiple formats using GDAL"]} {} "r.in.gdal" {} -command { execute r.in.gdal }}
			{separator}
			{command {[G_msg "Aggregate ASCII xyz data into raster grid"]} {} "r.in.xyz" {} -command { execute r.in.xyz }}
			{command {[G_msg "ASCII GRID (includes GRASS ASCII)"]} {} "r.in.ascii" {} -command { execute r.in.ascii }}
			{command {[G_msg "Polygons and lines from ASCII file"]} {} "r.in.poly" {} -command { execute r.in.poly }}
			{separator}
			{command {[G_msg "Binary file (includes GTOPO30 format)"]} {} "r.in.bin" {} -command { execute r.in.bin }}
			{command {[G_msg "ESRI Arc/Info ASCII grid"]} {} "r.in.arc" {} -command { execute r.in.arc }}
			{command {[G_msg "GRIDATB.FOR map file (TOPMODEL)"]} {} "r.in.gridatb" {} -command { execute r.in.gridatb }}
			{command {[G_msg "MAT-File (v.4) array (Matlab or Octave)"]} {} "r.in.mat" {} -command { execute r.in.mat }}
			{command {[G_msg "SPOT vegetation NDVI data sets"]} {} "i.in.spotvgt" {} -command { execute i.in.spotvgt }}
			{command {[G_msg "SRTM hgt files"]} {} "r.in.srtm" {} -command { execute r.in.srtm }}
			{command {[G_msg "Terra ASTER HDF files"]} {} "r.in.aster" {} -command { execute r.in.aster }}
			{separator}
			{command {[G_msg "Web Mapping Server"]} {} "r.in.wms" {} -command { execute r.in.wms }}
		}}
		{cascad {[G_msg "Vector map"]} {} "" $tmenu {			
			{command {[G_msg "Various formats using OGR"]} {} "v.in.ogr" {} -command { execute v.in.ogr }}
			{separator}
			{command {[G_msg "ASCII points file or GRASS ASCII vector file"]} {} "v.in.ascii" {} -command { execute v.in.ascii }}
			{command {[G_msg "Import old GRASS vector format"]} {} "v.convert" {} -command { execute v.convert }}
			{separator}
			{command {[G_msg "DXF file"]} {} "v.in.dxf" {} -command { execute v.in.dxf }}
			{command {[G_msg "ESRI e00 format"]} {} "v.in.e00" {} -command { execute v.in.e00 }}
			{command {[G_msg "Garmin GPS Waypoints/Routes/Tracks"]} {} "v.in.garmin" {} -command { execute v.in.garmin }}
			{command {[G_msg "GPS Waypoints/Routes/Tracks using GPSBabel"]} {} "v.in.gpsbabel" {} -command { execute v.in.gpsbabel }}
			{command {[G_msg "GEOnet Name server country files (US-NGA GNS)"]} {} "v.in.gns" {} -command { execute v.in.gns }}
			{command {[G_msg "Matlab and MapGen files"]} {} "v.in.mapgen" {} -command { execute v.in.mapgen }}
		}}
		{cascad {[G_msg "Grid 3D"]} {} "" $tmenu {			
			{command {[G_msg "ASCII 3D file"]} {} "r3.in.ascii" {} -command { execute r3.in.ascii }}
			{command {[G_msg "Vis5D file"]} {} "r3.in.v5d" {} -command { execute r3.in.v5d }}
		}}
	}}
	{cascad {[G_msg "Export"]} {} "" $tmenu {
		{cascad {[G_msg "Raster map"]} {} "" $tmenu {
			{command {[G_msg "Multiple formats using GDAL"]} {} "r.out.gdal" {} -command { execute r.out.gdal }}
			{separator}
			{command {[G_msg "ASCII grid (for GRASS, Surfer, Modflow, etc)"]} {} "r.out.ascii" {} -command { execute r.out.ascii }}
			{command {[G_msg "ASCII x,y,z values of cell centers"]} {} "r.out.xyz" {} -command { execute r.out.xyz }}
			{separator}
			{command {[G_msg "ESRI Arc/Info ASCII grid"]} {} "r.out.arc" {} -command { execute r.out.arc }}
			{command {[G_msg "GRIDATB.FOR map file (TOPMODEL)"]} {} "r.out.gridatb" {} -command { execute r.out.gridatb }}
			{command {[G_msg "MAT-File (v.4) array (Matlab or Octave)"]} {} "r.out.mat" {} -command { execute r.out.mat }}
			{separator}
			{command {[G_msg "Binary file"]} {} "r.out.bin" {} -command { execute r.out.bin }}
			{separator}
			{command {[G_msg "MPEG-1 animations"]} {} "r.out.mpeg" {} -command { execute r.out.mpeg }}
			{command {[G_msg "PNG image (not georeferenced)"]} {} "r.out.png" {} -command { execute r.out.png }}
			{command {[G_msg "PPM image (24bit)"]} {} "r.out.ppm" {} -command { execute r.out.ppm }}
			{command {[G_msg "PPM image from red, green, blue raster maps"]} {} "r.out.ppm3" {} -command { execute r.out.ppm3 }}
			{command {[G_msg "POVray height-field"]} {} "r.out.pov" {} -command { execute r.out.pov }}
			{command {[G_msg "TIFF image (8/24bit)"]} {} "r.out.tiff" {} -command { execute r.out.tiff }}
			{command {[G_msg "VRML file"]} {} "r.out.vrml" {} -command { execute r.out.vrml }}
			{command {[G_msg "VTK ASCII file"]} {} "r.out.vtk" {} -command { execute r.out.vtk }}
		}}
		{cascad {[G_msg "Vector map"]} {} "" $tmenu {			
			{command {[G_msg "Various formats using OGR (SHAPE, MapInfo etc)"]} {} "v.out.ogr" {} -command { execute v.out.ogr }}
			{separator}
			{command {[G_msg "DXF file (ASCII)"]} {} "v.out.dxf" {} -command { execute v.out.dxf }}
			{command {[G_msg "ASCII vector or point file/old GRASS ASCII vector file"]} {} "v.out.ascii" {} -command { execute v.out.ascii }}
			{command {[G_msg "POV-Ray format"]} {} "v.out.pov" {} -command { execute v.out.pov }}
			{command {[G_msg "SVG file"]} {} "v.out.svg" {} -command { execute v.out.svg }}
			{command {[G_msg "VTK ASCII file"]} {} "v.out.vtk" {} -command { execute v.out.vtk }}
		}}
		{cascad {[G_msg "Grid 3D"]} {} "" $tmenu {
			{command {[G_msg "ASCII 3D file"]} {} "r3.out.ascii" {} -command { execute r3.out.ascii }}
			{command {[G_msg "Vis5D file"]} {} "r3.out.v5d" {} -command { execute r3.out.v5d }}
			{command {[G_msg "VTK ASCII file"]} {} "r3.out.vtk" {} -command { execute r3.out.vtk }}
		}}
	}}
	{separator}
	{cascad {[G_msg "Manage maps and volumes"]} {} "" $tmenu {
		{command {[G_msg "Copy maps"]} {} "g.copy" {} -command {execute g.copy }}
		{command {[G_msg "List maps"]} {} "g.list" {} -command {execute g.list}}
		{command {[G_msg "List maps using expressions and 'wildcards'"]} {} "g.mlist" {} -command {execute g.mlist }}
		{command {[G_msg "Rename maps"]} {} "g.rename" {} -command {execute g.rename }}
		{command {[G_msg "Remove maps"]} {} "g.remove" {} -command {execute g.remove }}
		{command {[G_msg "Remove maps using expressions and 'wildcards'"]} {} "g.mremove" {} -command {execute g.mremove }}
	}}
	{cascad {[G_msg "Map type conversions"]} {} "" $tmenu {
		{command {[G_msg "Raster to vector map"]} {} "r.to.vect" {} -command {execute r.to.vect }}
		{command {[G_msg "Raster map series to volume"]} {} "r.to.rast3" {} -command {execute r.to.rast3 }}
		{command {[G_msg "Raster 2.5D map to volume"]} {} "r.to.rast3elev" {} -command {execute r.to.rast3elev }}
		{command {[G_msg "Vector to raster"]} {} "v.to.rast" {} -command {execute v.to.rast }}
		{command {[G_msg "Vector to vector"]} {} "v.type" {} -command {execute v.type }}
		{command {[G_msg "Vector lines to points"]} {} "v.to.points" {} -command {execute v.to.points }}
		{command {[G_msg "Vector 3D points to volume voxels"]} {} "v.to.rast3" {} -command {execute v.to.rast3 }}
		{command {[G_msg "Sites (GRASS 5) to vector"]} {} "v.in.sites" {} -command {execute v.in.sites }}
		{command {[G_msg "Volumes to raster map series"]} {} "r3.to.rast" {} -command {execute r3.to.rast }}
	}}
	{separator}
	{command {[G_msg "Georectify"]} {} "Georectify raster map in XY location" {} -command { GRMap::startup }}
	{separator}
	{command {[G_msg "Convert between bearing/distance and coordinates"]} {} "m.cogo" {} -command { execute m.cogo }}
	{separator}
	{command {[G_msg "Create cartographic PostScript plot"]} {} "ps.map" {} -command { execute ps.map }}
	{separator}
	{command {[G_msg "E&xit"]} {} "Exit GIS Manager" {} -accelerator $keyctrl-Q -command { exit } }
 }
 {[G_msg "&Config"]} all options $tmenu {
	{cascad {[G_msg "Region"]} {} "" $tmenu {
		{command {[G_msg "Display region settings"]} {} "g.region -p" {} -command {run_panel "g.region -p" }}
		{command {[G_msg "Change region settings"]} {} "g.region" {} -command {execute g.region }}
		{command {[G_msg "Zoom to maximum extent of all displayed maps"]} {} "d.extend" {} -command {run_panel d.extend }}
	}}
	{cascad {[G_msg "GRASS working environment"]} {} "" $tmenu {			
		{command {[G_msg "Access other mapsets in current location"]} {} "g.mapsets.tcl" {} -command {spawn $env(GISBASE)/etc/g.mapsets.tcl}}
		{command {[G_msg "Change current working session to new mapset, location, or GISDBASE"]} {} "g.mapset" {} -command {execute g.mapset }}
		{command {[G_msg "Modify access by other users to current mapset"]} {} "g.access" {} -command {execute g.access }}
		{command {[G_msg "Show current GRASS environment settings"]} {} "g.gisenv" {} -command {run_panel g.gisenv }}
		{command {[G_msg "Set GRASS environment settings"]} {} "g.gisenv" {} -command {execute g.gisenv }}
		{command {[G_msg "Show current GRASS version"]} {} "g.version -c" {} -command {run_panel "g.version -c" }}
	}}
	{cascad {[G_msg "Manage projections"]} {} "" $tmenu {
		{command {[G_msg "Create/edit projection information for current location"]} {} "g.setproj" {} -command {term g.setproj }}
		{command {[G_msg "Show projection information and create projection files"]} {} "g.proj" {} -command {execute g.proj }}
		{separator}
		{command {[G_msg "Convert coordinates from one projection to another"]} {} "m.proj" {} -command {execute m.proj }}
	}}
	{cascad {[G_msg "X-monitor displays"]} {} "" $tmenu {
		{command {[G_msg "Configure xmonitor displays"]} {} "d.mon" {} -command {execute d.mon }}
		{command {[G_msg "Configure frames for xmonitors"]} {} "d.frame" {} -command {execute d.frame }}
		{command {[G_msg "Start/restart xmonitor at specified window size"]} {} "d.monsize" {} -command {execute d.monsize }}
		{command {[G_msg "Set active xmonitor to specified size"]} {} "d.resize" {} -command {execute d.resize }}
		{command {[G_msg "Display information about active xmonitor"]} {} "d.info" {} -command {execute d.info }}
	}}
	{separator}
	{command {[G_msg "Install GRASS Extensions"]} {} "m.gem" {} -command {execute m.gem }}
 } 
 {[G_msg "&Raster"]} all options $tmenu {
	{cascad {[G_msg "Develop map"]} {} "" $tmenu {			
		{command {[G_msg "Digitize raster"]} {} "r.digit" {} -command {guarantee_xmon; term r.digit }}
		{separator}
		{command {[G_msg "Compress/decompress raster file"]} {} "r.compress" {} -command {execute r.compress }}
		{command {[G_msg "Manage boundary definitions"]} {} "r.region" {} -command {execute r.region }}
		{command {[G_msg "Manage null values"]} {} "r.null" {} -command {execute r.null }}
		{command {[G_msg "Manage timestamps for files"]} {} "r.timestamp" {} -command {execute r.timestamp }}
		{command {[G_msg "Quantization for floating-point maps"]} {} "r.quant" {} -command {execute r.quant }}
	    {cascad {[G_msg "Resample (change resolution)"]} {} "" $tmenu {
			{command {[G_msg "Resample using nearest neighbor method"]} {} "r.resample" {} -command {execute r.resample }}
			{command {[G_msg "Resample using various interpolation methods"]} {} "r.resamp.interp" {} -command {execute r.resamp.interp }}
			{command {[G_msg "Resample using aggregate statistics"]} {} "r.resamp.stats" {} -command {execute r.resamp.stats }}
			{command {[G_msg "Resample using regularized spline with tension method"]} {} "r.resamp.rst" {} -command {execute r.resamp.rst }}
	    }}
		{command {[G_msg "Support file creation and maintenance"]} {} "r.support" {} -command {term r.support }}
		{command {[G_msg "Update raster map statistics"]} {} "r.support.stats" {} -command {execute r.support.stats }}
		{separator}
		{command {[G_msg "Reproject raster from other location"]} {} "r.proj" {} -command {execute r.proj }}
		{command {[G_msg "Generate tiling for other projection"]} {} "r.tileset" {} -command {execute r.tileset }}
	}}
	{cascad {[G_msg "Manage map colors"]} {} "" $tmenu {			
		{command {[G_msg "Set colors to predefined color tables"]} {} "r.colors" {} -command {execute r.colors }}
		{command {[G_msg "Set colors using color rules"]} {} "r.colors.rules" {} -command {execute $env(GISBASE)/etc/gm/script/r.colors.rules }}
		{separator}
		{command {[G_msg "Blend 2 color maps to produce 3 RGB files"]} {} "r.blend" {} -command {execute r.blend }}
		{command {[G_msg "Create color image from RGB files"]} {} "r.composite" {} -command {execute r.composite }}
		{command {[G_msg "Create 3 RGB (red, green, blue) maps from 3 HIS (hue, intensity, saturation) maps"]} {} "r.his" {} -command {execute r.his }}
	}}
	{cascad {[G_msg "Query/Profile"]} {} "" $tmenu {			
		{command {[G_msg "Query by coordinate(s)"]} {} "r.what" {} -command { execute r.what }}
		{command {[G_msg "Profile analysis"]} {} "d.profile" {} -command {guarantee_xmon; execute d.profile }}
	}}
	{separator}
	{command {[G_msg "Create raster MASK"]} {} "r.mask" {} -command { execute r.mask }}
	{command {[G_msg "Create raster buffers"]} {} "r.buffer" {} -command { execute r.buffer }}
	{command {[G_msg "Map calculator"]} {} "r.mapcalculator" {} -command { execute r.mapcalculator }}
	{separator}
	{cascad {[G_msg "Overlay maps"]} {} "" $tmenu {			
		{command {[G_msg "Cross product"]} {} "r.cross" {} -command {execute r.cross }}
		{command {[G_msg "Function of map series (time series)"]} {} "r.series" {} -command {execute r.series }}
		{command {[G_msg "Patch maps"]} {} "r.patch" {} -command {execute r.patch }}
		{separator}
		{command {[G_msg "Statistical calculations for cover map over base map"]} {} "r.statistics" {} -command {execute r.statistics }}
	}}
	{cascad {[G_msg "Transform features"]} {} "" $tmenu {			
		{command {[G_msg "Clump small areas (statistics calculated by r.volume)"]} {} "r.clump" {} -command {execute r.clump }}
		{command {[G_msg "Grow areas"]} {} "r.grow" {} -command {execute r.grow }}
		{command {[G_msg "Thin linear features"]} {} "r.thin" {} -command {execute r.thin }}
	}}
	{cascad {[G_msg "Proximity/Neighborhood analysis"]} {} "" $tmenu {
		{command {[G_msg "Moving window analysis of raster cells"]} {} "r.neighbors" {} -command { execute r.neighbors }}
		{command {[G_msg "Analyze vector points in neighborhood of raster cells"]} {} "v.neighbors" {} -command { execute v.neighbors }}
		{separator}
		{command {[G_msg "Locate closest points between areas in 2 raster maps"]} {} "r.distance" {} -command { execute r.distance }}
	}}
	{separator}
	{cascad {[G_msg "Modeling: Hydrologic"]} {} "" $tmenu {
		{command {[G_msg "Carve stream channels into elevation map using vector streams map"]} {} "r.carve" {} -command {execute r.carve }}
		{command {[G_msg "Depressionless elevation map and flowline map"]} {} "r.fill.dir" {} -command {execute r.fill.dir }}
		{command {[G_msg "Fill lake from seed point to specified level"]} {} "r.lake" {} -command {execute r.lake }}
		{command {[G_msg "Flow accumulation for massive grids"]} {} "r.terraflow" {} -command {execute r.terraflow }}
		{command {[G_msg "Generate flow lines for raster map"]} {} "r.flow" {} -command {execute r.flow }}
		{command {[G_msg "SIMWE overland flow modeling"]} {} "r.sim.water" {} -command {execute r.sim.water }}
		{command {[G_msg "SIMWE sediment erosion, transport, & deposition modeling"]} {} "r.sim.sediment" {} -command {execute r.sim.sediment }}
		{command {[G_msg "Topographic index map"]} {} "r.topidx" {} -command {execute r.topidx }}
		{command {[G_msg "TOPMODEL simulation"]} {} "r.topmodel" {} -command {execute r.topmodel }}
		{command {[G_msg "Watershed subbasins"]} {} "r.basins.fill" {} -command {execute r.basins.fill }}
		{command {[G_msg "Watershed analysis"]} {} "r.watershed" {} -command {execute r.watershed }}
		{command {[G_msg "Watershed basin creation"]} {} "r.water.outlet" {} -command {execute r.water.outlet }}
	}}
	{cascad {[G_msg "Modeling: Landscape structure"]} {} "" $tmenu {			
		{command {[G_msg "Set up sampling and analysis framework"]} {} "r.le.setup" {} -command {guarantee_xmon; term r.le.setup }}
		{separator}
		{command {[G_msg "Analyze landscape characteristics"]} {} "r.le.pixel" {} -command {execute r.le.pixel }}
		{command {[G_msg "Analyze landscape patch characteristics"]} {} " r.le.patch" {} -command {execute r.le.patch }}
		{command {[G_msg "Output landscape patch information"]} {} "r.le.trace" {} -command {execute r.le.trace }}
	}}
	{cascad {[G_msg "Modeling: Landscape patch analysis"]} {} "" $tmenu {			
		{command {[G_msg "Configure and create patch map for analysis"]} {} "r.li.setup" {} -command {execute r.li.setup }}
		{separator}
		{command {[G_msg "Calculate contrast weighted edge density index"]} {} "r.li.cwed" {} -command {execute r.li.cwed }}
		{command {[G_msg "Calculate dominance's diversity index"]} {} "r.li.dominance" {} -command {execute r.li.dominance }}
		{command {[G_msg "Calculate edge density index using a 4 neighbour algorithm"]} {} "r.li.edgedensity" {} -command {execute r.li.edgedensity }}
		{command {[G_msg "Calculate mean patch size index using a 4 neighbour algorithm"]} {} " r.li.mps" {} -command {execute r.li.mps }}
		{command {[G_msg "Calculate coefficient of variation of patch area"]} {} "	r.li.padcv" {} -command {execute r.li.padcv }}
 		{command {[G_msg "Calculate range of patch area size"]} {} "r.li.padrange" {} -command {execute r.li.padrange }}
 		{command {[G_msg "Calculate standard deviation of patch area"]} {} "r.li.padsd" {} -command {execute r.li.padsd }}
 		{command {[G_msg "Calculate patch density index using a 4 neighbour algorithm"]} {} "r.li.patchdensity" {} -command {execute r.li.patchdensity }}
 		{command {[G_msg "Calculate patch number index using a 4 neighbour algorithm"]} {} "r.li.patchnum" {} -command {execute r.li.patchnum }}
 		{command {[G_msg "Calculate dominance's diversity index"]} {} "r.li.shannon" {} -command {execute r.li.shannon }}
		{command {[G_msg "Calculate Shannon's diversity index"]} {} "r.li.richness" {} -command {execute r.li.richness }}
 		{command {[G_msg "Calculate shape index"]} {} "r.li.shape" {} -command {execute r.li.shape }}
 		{command {[G_msg "Calculate Simpson's diversity index"]} {} "r.li.simpson" {} -command {execute r.li.simpson }}
	}}
	{cascad {[G_msg "Modeling: Terrain and solar"]} {} "" $tmenu {			
		{command {[G_msg "Calculate cumulative movement costs between locales"]} {} "r.walk" {} -command {execute r.walk }}
		{command {[G_msg "Cost surface"]} {} "r.cost" {} -command {execute r.cost }}
		{command {[G_msg "Least cost route or flow"]} {} "r.drain" {} -command {execute r.drain }}
		{separator}
		{command {[G_msg "Shaded relief map"]} {} "r.shaded.relief" {} -command {execute r.shaded.relief }}
		{command {[G_msg "Slope and aspect"]} {} "r.slope.aspect" {} -command {execute r.slope.aspect }}
		{command {[G_msg "Terrain parameters"]} {} "r.param.scale" {} -command {execute r.param.scale }}
		{separator}
		{command {[G_msg "Textural features"]} {} "r.texture" {} -command {execute r.texture }}
		{command {[G_msg "Visibility/line of sight"]} {} "r.los" {} -command {execute r.los }}
		{separator}
		{command {[G_msg "Solar irradiance and daily irradiation"]} {} "r.sun" {} -command {execute r.sun }}
		{command {[G_msg "Shadows map for sun position or date/time"]} {} "r.sunmask" {} -command {execute r.sunmask }}
	}}
	{separator}
	{cascad {[G_msg "Modeling: Universal Soil Loss Equation (USLE)"]} {} "" $tmenu {			
		{command {[G_msg "Rainfall Erosivity (R)"]} {} "r.usler" {} -command {execute r.usler }}
		{command {[G_msg "Soil Erodibility (K)"]} {} "r.uslek" {} -command {execute r.uslek }}
		{command {[G_msg "Length Slope and Slope (LS)"]} {} "r.watershed" {} -command {execute r.watershed }}
	}}
	{cascad {[G_msg "Modeling: Wildfire modeling"]} {} "" $tmenu {			
		{command {[G_msg "Generate rate of spread (ROS) maps"]} {} "r.ros" {} -command {execute r.ros }}
		{command {[G_msg "Generate least-cost spread paths"]} {} "r.spreadpath" {} -command {execute r.spreadpath }}
		{command {[G_msg "Simulate anisotropic spread phenomena"]} {} "r.spread" {} -command {execute r.spread }}
	}}
	{separator}
	{cascad {[G_msg "Change category values and labels"]} {} "" $tmenu {			
		{command {[G_msg "Edit category values of individual cells for displayed raster map"]} {} "d.rast.edit" {} \
		-command {guarantee_xmon; term d.rast.edit }}
		{separator}
		{command {[G_msg "Reclassify categories for areas of specified sizes"]} {} "r.reclass.area" {} -command {execute r.reclass.area }}
		{command {[G_msg "Reclassify categories using rules"]} {} "r.reclass.rules" {} -command {execute $env(GISBASE)/etc/gm/script/r.reclass.rules }}
		{command {[G_msg "Reclassify categories using rules file"]} {} "r.reclass.file" {} -command {execute $env(GISBASE)/etc/gm/script/r.reclass.file }}
		{separator}
		{command {[G_msg "Recode categories using rules (create new map)"]} {} "r.recode.rules" {} -command {execute $env(GISBASE)/etc/gm/script/r.recode.rules }}
		{command {[G_msg "Recode categories using rules file (create new map)"]} {} "r.recode.file " {} -command {execute $env(GISBASE)/etc/gm/script/r.recode.file }}
		{separator}
		{command {[G_msg "Rescale categories (create new map)"]} {} "r.rescale" {} -command {execute r.rescale }}
		{command {[G_msg "Rescale categories with equalized histogram (create new map)"]} {} "r.rescale.eq" {} -command {execute r.rescale.eq }}
	}}
	{separator}
	{cascad {[G_msg "Generate"]} {} "" $tmenu {
		{command {[G_msg "Concentric circles around points"]} {} "r.circle" {} -command { execute r.circle }}
		{command {[G_msg "Density surface using moving Gausian kernal"]} {} "v.kernel" {} -command {execute v.kernel }}
		{command {[G_msg "Fractal surface"]} {} "r.surf.fractal" {} -command {execute r.surf.fractal }}
		{command {[G_msg "Gaussian deviates surface"]} {} "r.surf.gauss" {} -command {execute r.surf.gauss }}
		{command {[G_msg "Plane"]} {} "r.plane" {} -command {execute r.plane }}
		{separator}
		{command {[G_msg "Random cells"]} {} "r.random.cells" {} -command {execute r.random.cells }}
		{command {[G_msg "Random cells and vector points from raster map"]} {} "r.random" {} -command {execute r.random }}
		{command {[G_msg "Random deviates surface"]} {} "r.surf.random" {} -command {execute r.surf.random }}
		{command {[G_msg "Random surface with spatial dependence"]} {} "r.random.surface" {} -command {execute r.random.surface }}
		{separator}
		{command {[G_msg "Vector contour lines"]} {} "r.contour" {} -command { execute r.contour }}
	}}
	{cascad {[G_msg "Interpolate surfaces"]} {} "" $tmenu {			
		{command {[G_msg "Bicubic and bilinear interpolation with Tykhonov regularization from vector points"]} {} "v.surf.bspline" {} -command { execute v.surf.bspline }}
		{command {[G_msg "Bilinear interpolation from raster points"]} {} "r.bilinear" {} -command { execute r.bilinear }}
		{command {[G_msg "Inverse distance weighted interpolation from raster points"]} {} "r.surf.idw" {} -command { execute r.surf.idw }}
		{command {[G_msg "Interpolation from raster contours"]} {} "r.surf.contour" {} -command { execute r.surf.contour }}
		{separator}
		{command {[G_msg "Inverse distance weighted interpolation from vector points"]} {} "v.surf.idw" {} -command { execute v.surf.idw }}
		{command {[G_msg "Regularized spline tension interpolation from vector points or contours"]} {} "v.surf.rst" {} -command { execute v.surf.rst }}
		{separator}
		{command {[G_msg "Fill NULL cells by interpolation using regularized spline tension"]} {} " r.fillnulls" {} -command {execute r.fillnulls }}
	}}
	{separator}
	{cascad {[G_msg "Reports and statistics"]} {} "" $tmenu {			
		{command {[G_msg "Report basic file information"]} {} "r.info" {} -command {execute r.info }}
		{command {[G_msg "Report category labels and values"]} {} "r.cats" {} -command {execute r.cats }}
		{separator}
		{command {[G_msg "General statistics"]} {} "r.stats" {} -command {execute r.stats }}
		{command {[G_msg "Range of all category values"]} {} "r.describe" {} -command {execute r.describe }}
		{command {[G_msg "Sum all cell category values"]} {} "r.sum" {} -command {execute r.sum }}
		{command {[G_msg "Sum area by map and category"]} {} "r.report" {} -command {execute r.report }}
		{command {[G_msg "Summary statistics for clumped cells (works with r.clump)"]} {} "r.volume" {} -command {execute r.volume }}
		{separator}
		{command {[G_msg "Total surface area corrected for topography"]} {} "r.surf.area" {} -command {execute r.surf.area }}
		{command {[G_msg "Univariate statistics"]} {} "r.univar" {} -command {execute r.univar }}
		{command {[G_msg "Univariate statistics (script version)"]} {} " r.univar" {} -command {execute r.univar }}
		{separator}
		{command {[G_msg "Sample values along transects"]} {} "r.profile" {} -command {execute r.profile }}
		{command {[G_msg "Sample values along transects (use azimuth, distance)"]} {} " r.transect" {} -command {execute r.transect }}
		{separator}
		{command {[G_msg "Covariance/correlation"]} {} "r.covar" {} -command {execute r.covar }}
		{command {[G_msg "Linear regression between 2 maps"]} {} "r.regression.line" {} -command {execute r.regression.line }}
		{command {[G_msg "Mutual category occurences (coincidence)"]} {} "r.coin" {} -command {execute r.coin }}
	}}
 } 
 {[G_msg "&Vector"]} all options $tmenu {
	{cascad {[G_msg "Develop map"]} {} "" $tmenu {			
		{command {[G_msg "Digitize"]} {} "v.digit" {} -command {execute v.digit }}
		{separator}
		{command {[G_msg "Create/rebuild topology"]} {} "v.build" {} -command {execute v.build }}
		{command {[G_msg "Clean vector files"]} {} "v.clean" {} -command {execute v.clean }}
		{command {[G_msg "Add missing centroids"]} {} "v.centroids" {} -command {execute v.centroids }}
		{separator}
		{command {[G_msg "Build polylines from adjacent segments"]} {} "v.build.polylines" {} -command {execute v.build.polylines }}
		{command {[G_msg "Split polylines into segments"]} {} "v.segment" {} -command {execute v.segment }}
		{command {[G_msg "Create lines parallel to existing lines"]} {} "v.parallel" {} -command {execute v.parallel }}
		{command {[G_msg "Dissolve common boundaries"]} {} "v.dissolve" {} -command {execute v.dissolve }}
		{separator}
		{command {[G_msg "Convert vector feature types"]} {} "v.type" {} -command {execute v.type }}
		{command {[G_msg "Convert 2D vector to 3D by sampling raster"]} {} "v.drape" {} -command {execute v.drape }}
		{command {[G_msg "Extrude 2D vector into 3D vector"]} {} "v.extrude" {} -command {execute v.extrude }}
		{separator}
		{command {[G_msg "Create new vector as link to external OGR layer"]} {} "v.external" {} -command {execute v.external }}
		{separator}
		{command {[G_msg "Create text label file for vector features"]} {} "v.label" {} -command {execute v.label }}
		{separator}
		{command {[G_msg "Reproject vector from other location"]} {} "v.proj" {} -command {execute v.proj }}
	}}
	{command {[G_msg "Rectify and georeference vector map"]} {} "v.transform" {} -command {execute v.transform }}
	{separator}
	{command {[G_msg "Query by attributes"]} {} "v.extract" {} -command {execute v.extract }}
	{command {[G_msg "Query by coordinate(s)"]} {} "v.what" {} -command { execute v.what }}
	{command {[G_msg "Query by map features"]} {} " v.select" {} -command {execute v.select }}
	{separator}
	{command {[G_msg "Create vector buffers"]} {} "v.buffer" {} -command {execute v.buffer }}
	{cascad {[G_msg "Lidar object filtering and detection"]} {} "" $tmenu {			
		{command {[G_msg "Detect object edges in LIdar data"]} {} "v.lidar.edgedetection" {} -command {execute v.lidar.edgedetection }}
		{command {[G_msg "Detect interior of objects in Lidar data"]} {} "v.lidar.growing" {} -command {execute v.lidar.growing }}
		{command {[G_msg "Correct and reclassify objects detected in Lidar data"]} {} "v.lidar.correction" {} -command {execute v.lidar.correction }}
	}}
	{cascad {[G_msg "Linear referencing for vectors"]} {} "" $tmenu {			
		{command {[G_msg "Create linear reference system"]} {} "v.lrs.create" {} -command {execute v.lrs.create }}
		{command {[G_msg "Create stationing from imput lines, and linear reference system"]} {} "v.lrs.label" {} -command {execute v.lrs.label }}
		{command {[G_msg "Create points/segments from input lines, linear reference system and positions read from stdin"]} {} "v.lrs.segment" {} -command {execute v.lrs.segment }}
		{command {[G_msg "Find line id and real km+offset for given points in vector map using linear reference system"]} {} "v.lrs.where" {} -command {execute v.lrs.where }}
	}}
	{cascad {[G_msg "Neighborhood analysis"]} {} "" $tmenu {			
		{command {[G_msg "Locate nearest features to points or centroids"]} {} "v.distance" {} -command {execute v.distance }}
		{command {[G_msg "Generate Thiessen polygons around points (Voronoi diagram)"]} {} "v.voronoi" {} -command {execute v.voronoi }}
		{command {[G_msg "Connect points to create Delaunay triangles"]} {} "v.delaunay" {} -command {execute v.delaunay }}
	}}
	{cascad {[G_msg "Network analysis"]} {} "" $tmenu {			
		{command {[G_msg "Allocate subnets"]} {} "v.net.alloc" {} -command {execute v.net.alloc }}
		{command {[G_msg "Network maintenance"]} {} "v.net" {} -command {execute v.net }}
		{command {[G_msg "Shortest route"]} {} "v.net.path" {} -command {execute v.net.path }}
		{command {[G_msg "Shortest route (visualization only)"]} {} "d.path" {} -command {guarantee_xmon; spawn d.path.sh -b --ui }}
		{command {[G_msg "Split net to bands between cost isolines"]} {} "v.net.iso" {} -command {execute v.net.iso }}
		{command {[G_msg "Steiner tree"]} {} "v.net.steiner" {} -command {execute v.net.steiner }}
		{command {[G_msg "Traveling salesman analysis"]} {} "v.net.salesman" {} -command {execute v.net.salesman }}
	}}
	{cascad {[G_msg "Overlay maps"]} {} "" $tmenu {			
		{command {[G_msg "Overlay/combine 2 vector maps"]} {} "v.overlay" {} -command {execute v.overlay }}
		{command {[G_msg "Patch multiple maps (combine)"]} {} "v.patch" {} -command {execute v.patch }}
	}}
	{command {[G_msg "Generate area feature for extent of current region"]} {} "v.in.region" {} -command {execute v.in.region }}
	{command {[G_msg "Generate rectangular vector grid"]} {} "v.mkgrid" {} -command {execute v.mkgrid }}
	{separator}
	{cascad {[G_msg "Change attributes"]} {} "" $tmenu {			
		{command {[G_msg "Attach, delete, or report categories"]} {} "v.category" {} -command {execute v.category }}
		{command {[G_msg "Reclassify features using rules file"]} {} "v.reclass" {} -command {execute v.reclass }}
	}}
	{separator}
	{cascad {[G_msg "Work with vector points"]} {} "" $tmenu {			
 		{cascad {[G_msg "Generate points"]} {} "" $tmenu {			
			{command {[G_msg "Generate points from database with x/y coordinates"]} {} "v.in.db" {} -command {execute v.in.db }}
 			{command {[G_msg "Generate random points"]} {} "v.random" {} -command {execute v.random }}
 			{command {[G_msg "Random location perturbations of points"]} {} "v.perturb" {} -command {execute v.perturb }}
 		}}
 		{cascad {[G_msg "Generate areas from points"]} {} "" $tmenu {			
 			{command {[G_msg "Generate convex hull for point set"]} {} "v.hull" {} -command {execute v.hull }}
 			{command {[G_msg "Generate Delaunay triangles for point set"]} {} "v.delaunay" {} -command {execute v.delaunay }}
 			{command {[G_msg "Generate Voronoi diagram/Thiessen polygons for point set"]} {} "v.voronoi" {} -command {execute v.voronoi }}
 		}}
 		{cascad {[G_msg "Sample raster maps"]} {} "" $tmenu {			
 			{command {[G_msg "Calculate statistics for raster map overlain by vector map"]} {} "v.rast.stats" {} -command {execute v.rast.stats }}
 			{command {[G_msg "Sample raster map at point locations"]} {} "v.what.rast" {} -command {execute v.what.rast }}
 			{command {[G_msg "Sample raster neighborhood around points"]} {} "v.sample" {} -command {execute v.sample }}
 		}}
 		{command {[G_msg "Partition points into test/training sets for k-fold cross validatation"]} {} "v.kcv" {} -command {execute v.kcv }}
 		{command {[G_msg "Remove outliers from vector point set"]} {} "v.outlier" {} -command {execute v.outlier }}
 		{command {[G_msg "Transfer attribute data from queried vector map to points"]} {} "v.what.vect" {} -command {execute v.what.vect }}
	}}
	{separator}
	{cascad {[G_msg "Reports and statistics"]} {} "" $tmenu {			
		{command {[G_msg "Basic information"]} {} "v.info" {} -command {execute v.info }}
		{command {[G_msg "Load vector attributes to database or create reports"]} {} "v.to.db" {} -command {execute v.to.db }}
		{command {[G_msg "Report areas for vector attribute categories"]} {} "v.report" {} -command {execute v.report }}
		{command {[G_msg "Univariate statistics"]} {} "v.univar" {} -command {execute v.univar }}
 		{separator}
		{command {[G_msg "Test normality of point distribution"]} {} "v.normal" {} -command {execute v.normal }}
		{command {[G_msg "Calculate stats for raster map underlying vector objects"]} {} "v.rast.stats" {} -command {execute v.rast.stats }}
		{command {[G_msg "Indices of point counts in quadrats"]} {} "v.qcount" {} -command {execute v.qcount }}
	}}
 } 
 {[G_msg "&Imagery"]} all options $tmenu {			
	{cascad {[G_msg "Develop images and groups"]} {} "" $tmenu {			
		{command {[G_msg "Create/edit imagery group"]} {} "i.group" {} -command {execute i.group }}			
		{command {[G_msg "Target imagery group"]} {} "i.target" {} -command {execute i.target }}
		{separator}
		{command {[G_msg "Mosaic up to 4 adjacent images"]} {} "i.image.mosaic" {} -command {execute i.image.mosaic }}
	}}
	{cascad {[G_msg "Manage image colors"]} {} "" $tmenu {			
		{command {[G_msg "Color balance/enhance color tables for rgb display"]} {} "i.landsat.rgb" {} -command {execute i.landsat.rgb }}
		{command {[G_msg "Transform HIS to RGB"]} {} "i.his.rgb" {} -command {execute i.his.rgb }}
		{command {[G_msg "Transform RGB to HIS"]} {} "i.rgb.his" {} -command {execute i.rgb.his }}
	}}
	{cascad {[G_msg "Rectify and georeference image group"]} {} "" $tmenu {			
		{command {[G_msg "Set ground control points (GCP's) from raster map or keyboard entry"]} {} "i.points" {} \
		-command {guarantee_xmon; term i.points }}
		{command {[G_msg "Set ground control points (GCP's) from vector map or keyboard entry"]} {} "i.vpoints" {} \
		-command {guarantee_xmon; term i.vpoints }}
		{command {[G_msg "Affine and Polynomial rectification (rubber sheet)"]} {} "i.rectify" {} -command {execute i.rectify }}
		{command {[G_msg "Ortho photo rectification"]} {} "i.ortho.photo" {} -command {term i.ortho.photo }}
	}}
	{separator}
	{cascad {[G_msg "GIPE"]} {} "" $tmenu {
		{cascad {[G_msg "DN2Rad2Ref"]} {} "" $tmenu {
				{command {[G_msg "Landsat 7 ETM+"]} {} "i.dn2ref.l7" {} -command {execute i.dn2ref.l7 }}
				{command {[G_msg "Landsat 7 ETM+ (from .met)"]} {} "i.dn2full.l7" {} -command {execute i.dn2full.l7 }}
				{command {[G_msg "Terra-Aster"]} {} "i.dn2ref.ast" {} -command {execute i.dn2ref.ast }}
				{separator}
				{command {[G_msg "Atmospheric correction"]} {} "i.atcorr" {} -command {execute i.atcorr }}
				{command {[G_msg "Dehaze Landsat"]} {} "i.landsat.dehaze" {} -command {execute i.landsat.dehaze }}
		}}
		{cascad {[G_msg "Basic RS processing"]} {} "" $tmenu {
				{command {[G_msg "Tassled cap vegetation index"]} {} "i.tasscap" {} -command {execute i.tasscap }}
				{command {[G_msg "Vegetation Indices (13 types)"]} {} "i.vi" {} -command {execute i.vi }}
				{command {[G_msg "Vegetation Indices (13 types) cluster"]} {} "i.vi.mpi" {} -command {execute i.vi.mpi }}
				{separator}
				{command {[G_msg "Albedo"]} {} "i.albedo" {} -command {execute i.albedo }}
				{command {[G_msg "Emissivity (generic from NDVI)"]} {} "i.emissivity" {} -command {execute i.emissivity }}
				{separator}
				{command {[G_msg "Latitude map"]} {} "i.latitude" {} -command {execute i.latitude }}
				{command {[G_msg "Sunshine hours (potential)"]} {} "i.sunhours" {} -command {execute i.sunhours }}
				{command {[G_msg "Satellite overpass time"]} {} "i.sattime" {} -command {execute i.sattime }}
		}}
		{separator}
		{cascad {[G_msg "ETo, ETP, ETa"]} {} "" $tmenu {
				{command {[G_msg "Reference ET (Hargreaves)"]} {} "r.evapo.MH" {} -command {execute r.evapo.MH }}
				{separator}
				{command {[G_msg "Potential ET (Penman-Monteith)"]} {} "r.evapo.PM" {} -command {execute r.evapo.PM }}
				{command {[G_msg "Potential ET (Prestley and Taylor)"]} {} "i.evapo.PT" {} -command {execute i.evapo.PT }}
				{command {[G_msg "Potential ET (Radiative)"]} {} "i.evapo.potrad" {} -command {execute i.evapo.potrad }}
				{command {[G_msg "Potential ET (Radiative) from L7DN (.met)"]} {} "i.dn2potrad.l7" {} -command {execute i.dn2potrad.l7 }}
				{separator}
				{command {[G_msg "Actual ET (SEBAL)"]} {} "i.eb.eta" {} -command {execute i.eb.eta }}
				{command {[G_msg "Actual ET (TSA)"]} {} "i.evapo.TSA" {} -command {execute i.evapo.TSA }}
		}}
		{cascad {[G_msg "Energy Balance"]} {} "" $tmenu {
				{command {[G_msg "Surface roughness"]} {} "i.eb.z0m" {} -command {execute i.eb.z0m }}
				{command {[G_msg "Delta T"]} {} "i.eb.deltat" {} -command {execute i.eb.deltat }}
				{command {[G_msg "Net radiation"]} {} "i.eb.netrad" {} -command {execute i.eb.netrad }}
				{separator}
				{command {[G_msg "Displacement height"]} {} "i.eb.disp" {} -command {execute i.eb.disp }}
				{command {[G_msg "Monin-Obukov Length"]} {} "i.eb.molength" {} -command {execute i.eb.molength }}
				{command {[G_msg "Psichrometric param. for heat"]} {} "i.eb.psi" {} -command {execute i.eb.psi }}
				{command {[G_msg "Blending height wind speed"]} {} "i.eb.ublend" {} -command {execute i.eb.ublend }}
				{command {[G_msg "Nominal wind speed"]} {} "i.eb.ustar" {} -command {execute i.eb.ustar }}
				{command {[G_msg "Aerod. resis. to heat transp."]} {} "i.eb.rah" {} -command {execute i.eb.rah }}
				{separator}
				{command {[G_msg "Soil heat flux"]} {} "i.eb.g0" {} -command {execute i.eb.g0 }}
				{command {[G_msg "Sensible heat flux"]} {} "i.eb.h0" {} -command {execute i.eb.h0 }}
				{command {[G_msg "Sensible heat flux iteration (fixed delta T)"]} {} "i.eb.h_iter" {} -command {execute i.eb.h_iter }}
				{separator}
				{command {[G_msg "Evaporative fraction"]} {} "i.eb.evapfr" {} -command {execute i.eb.evapfr }}
		}}
		{separator}
		{cascad {[G_msg "Biomass"]} {} "" $tmenu {
				{command {[G_msg "Biomass growth"]} {} "i.biomass" {} -command {execute r.biomass }}
		}}
	}}
	{cascad {[G_msg "Classify image"]} {} "" $tmenu {			
		{cascad {[G_msg "Classify image using pr library"]} {} "" $tmenu {			
                  {command {[G_msg "pr_blob"]} {} "i.pr_blob" {} -command {execute i.pr_blob }}
                  {command {[G_msg "pr_classify"]} {} "pr_classify" {} -command {execute i.pr_classify}}
                  {command {[G_msg "pr_features"]} {} "pr_features" {} -command {execute i.pr_features}}
                  {command {[G_msg "pr_features_additional"]} {} "pr_features_additional" {} -command {execute i.pr_features_additional}}
                  {command {[G_msg "pr_features_extract"]} {} "pr_features_extract" {} -command {execute i.pr_features_extract}}
		  {command {[G_msg "pr_features_selection"]} {} "pr_features_selection" {} -command {execute i.pr_features_selection}}
                  {command {[G_msg "pr_model"]} {} "pr_model" {} -command {execute i.pr_model}}
                  {command {[G_msg "pr_sites_aggregate"]} {} "pr_sites_aggregate" {} -command {execute i.pr_sites_aggregate}}
                  {command {[G_msg "pr_statistics"]} {} "pr_statistics" {} -command {execute i.pr_statistics}}
                  {command {[G_msg "pr_subsets"]} {} "pr_subsets" {} -command {execute i.pr_subsets}}
                  {command {[G_msg "pr_training"]} {} "pr_training" {} -command {execute i.pr_training}}
                  {command {[G_msg "pr_uxb"]} {} "pr_uxb" {} -command {execute i.pr_uxb}}
		}}
		{command {[G_msg "Clustering input for unsupervised classification"]} {} "i.cluster" {} -command {execute i.cluster }}
		{separator}
		{command {[G_msg "Maximum likelyhood classification (MLC)"]} {} "i.maxlik" {} -command {execute i.maxlik }}
		{command {[G_msg "Sequential maximum a posteriory classification (SMAP)"]} {} "i.smap" {} -command {execute i.smap }}
		{separator}
		{command {[G_msg "Interactive input for supervised classification"]} {} "i.class" {} -command {term i.class }}
		{command {[G_msg "Non-interactive input for supervised classification (MLC)"]} {} "i.gensig" {} -command {execute i.gensig }}
		{command {[G_msg "Non-interactive input for supervised classification (SMAP)"]} {} "i.gensigset" {} -command {execute i.gensigset }}
		{separator}
		{command {[G_msg "Kappa classification accuracy assessment"]} {} "r.kappa" {} -command {execute r.kappa }}
	}}
	{cascad {[G_msg "Filter image"]} {} "" $tmenu {			
		{command {[G_msg "Zero edge crossing detection"]} {} "i.zc" {} -command {execute i.zc }}
		{command {[G_msg "User defined matrix/convolving filter"]} {} "r.mfilter" {} -command {execute r.mfilter }}
	}}
	{command {[G_msg "Spectral response"]} {} "i.spectral" {} -command {execute i.spectral }}
	{cascad {[G_msg "Transform image"]} {} "" $tmenu {			
		{command {[G_msg "Brovey pan sharpening"]} {} "i.fusion.brovey" {} -command {execute i.fusion.brovey }}
		{separator}
		{command {[G_msg "Canonical component"]} {} "i.cca" {} -command {execute i.cca }}
		{command {[G_msg "Principal component"]} {} "i.pca" {} -command {execute i.pca }}
		{command {[G_msg "Fast Fourier Transform"]} {} "i.fft" {} -command {execute i.fft }}
		{command {[G_msg "Inverse Fast Fourier Transform"]} {} "i.ifft" {} -command {execute i.ifft }}
	}}
	{separator}
	{cascad {[G_msg "Reports and statistics"]} {} "" $tmenu {			
		{command {[G_msg "Report basic file information"]} {} "r.info" {} -command {execute r.info }}
		{command {[G_msg "Range of image values"]} {} "r.describe" {} -command {execute r.describe }}
	}}
	{cascad {[G_msg "Quality Assessment"]} {} "" $tmenu {			
		{command {[G_msg "Bit pattern comparison for ID of low quality pixels"]} {} "r.bitpattern" {} -command {execute r.bitpattern }}
		{command {[G_msg "Optimum index factor for LandSat TM"]} {} "i.oif" {} -command {execute i.oif }}
	}}
 } 
 {[G_msg "&Grid3D"]} all options $tmenu {
	{cascad {[G_msg "Develop grid3D volumes"]} {} "" $tmenu {			
		{command {[G_msg "Manage nulls for grid3D volume"]} {} "r3.null" {} -command {execute r3.null }}
		{command {[G_msg "Manage timestamp for grid3D volume"]} {} "r3.timestamp" {} -command {execute r3.timestamp }}
	}}
	{command {[G_msg "Create 3D mask for grid3D operations"]} {} "r3.mask" {} -command {execute r3.mask }}
	{command {[G_msg "Create 2D raster cross section from grid3d volume"]} {} "r3.cross.rast" {} -command { execute r3.cross.rast }}
	{command {[G_msg "Map calculator for grid3D operations"]} {} "r3.mapcalculator" {} -command {execute r3.mapcalculator }}
	{command {[G_msg "Interpolate volume from vector points using splines"]} {} "v.vol.rst" {} -command {execute v.vol.rst }}
	{cascad {[G_msg "Report and Statistics"]} {} "" $tmenu {			
		{command {[G_msg "Display information about grid3D volume"]} {} "r3.info" {} -command {execute r3.info }}
	}}
 } 
 {[G_msg "&Databases"]} all options $tmenu {
	{cascad {[G_msg "Manage database"]} {} "" $tmenu {			
		{command {[G_msg "Connect to database"]} {} "db.connect" {} -command {execute db.connect }}
		{command {[G_msg "Login to database"]} {} "db.login" {} -command {execute db.login }}
		{separator}
		{command {[G_msg "Create and add new attribute table to vector map"]} {} "v.db.addtable" {} -command {execute v.db.addtable }}
		{command {[G_msg "Copy attribute table"]} {} "db.copy" {} -command {execute db.copy }}
		{command {[G_msg "Remove existing attribute table for vector map"]} {} "v.db.droptable" {} -command {execute v.db.droptable }}
		{separator}
		{command {[G_msg "Add columns to table"]} {} "v.db.addcol" {} -command {execute v.db.addcol }}
		{command {[G_msg "Change values in a column"]} {} "v.db.update" {} -command {execute v.db.update }}
		{command {[G_msg "Rename a column"]} {} "v.db.renamecol" {} -command {execute v.db.renamecol }}
		{separator}
		{command {[G_msg "Test database"]} {} "db.test" {} -command {execute db.test }}
	}}
	{cascad {[G_msg "Database information"]} {} "" $tmenu {			
		{command {[G_msg "Describe table"]} {} "db.describe" {} -command {execute db.describe }}
		{command {[G_msg "List columns"]} {} "db.columns" {} -command {execute db.columns }}
		{command {[G_msg "List drivers"]} {} "db.drivers" {} -command {execute db.drivers }}
		{command {[G_msg "List tables"]} {} "db.tables" {} -command {execute db.tables }}
	}}
	{separator}
	{cascad {[G_msg "Query"]} {} "" $tmenu {			
		{command {[G_msg "Query data in any table"]} {} "db.select" {} -command {execute db.select }}
		{command {[G_msg "Query vector attribute data"]} {} "db.select" {} -command {execute v.db.select }}
		{command {[G_msg "Execute SQL statement"]} {} "db.execute" {} -command {execute db.execute }}
	}}
	{cascad {[G_msg "Vector<->database connections"]} {} "" $tmenu {			
		{command {[G_msg "Reconnect vector map to attribute database"]} {} "v.db.reconnect.all" {} -command {execute v.db.reconnect.all }}
		{command {[G_msg "Set database connection for vector attributes"]} {} "v.db.connect" {} -command {execute v.db.connect }}
	}}
 }
{[G_msg "&Help"]} all options $tmenu {
	{command {[G_msg "GRASS help"]} {} "g.manual" {} -command { exec g.manual -i > $devnull & } }
	{command {[G_msg "GIS Manager &help"]} {} {[G_msg "GIS Manager help"]} {} -command { exec g.manual gis.m > $devnull & } }
	{command {[G_msg "About &GRASS"]} {} {[G_msg "About GRASS"]} {} -command { source $env(GISBASE)/etc/gm/grassabout.tcl} }
	{command {[G_msg "About &System"]} {} {[G_msg "About System"]} {} -command { exec $env(GRASS_WISH) $env(GISBASE)/etc/gm/tksys.tcl --tcltk & }}
 }

}]

# Should we add an Xtns menu entry?
if { $XtnsMenu == "True" } {
	# build extension menu
	lappend descmenu [G_msg "&Xtns"]
	lappend descmenu all
	lappend descmenu options
	lappend descmenu $tmenu
	lappend descmenu $XtnsMenuList
}
