"""
Provide an executable code that is well commented using the Python library Skyfield
(https://rhodesmill.org/skyfield/api.html#id8). This code should be able to plot the two-dimensional
trajectory in latitude and longitude of any choice satellite over a 24-hour period on a flattened Earth
image.

Bonus but not required, assess the computation and memory complexity of the SGP4 propagator in big-O
notation.
"""

from skyfield.api import load, EarthSatellite
import matplotlib.pyplot as plt
import datetime
import math

"""
Goals:
1. Get TLE
2. Map r = [longitude, latitude] of satellite over 24 hours
3. Map r onto 2D projection of Earth

Further goals:
- Make time current time (YES)
- Collect all TLEs off a website (not necessary)
- Use that to find a satellite's name (not necessary)
- Do it by satellite name (YES)
- Check errors for TLE data (done automatically)

Sources:
1. Library documentation. https://rhodesmill.org/skyfield/earth-satellites.html
2. Image of the world. https://destinationofmarvel.blogspot.com/2011/03/map-coordinates-latitude-longitude.html
3. TLE for ISS. http://celestrak.com/NORAD/elements/stations.txt

"""

class track_satellite:
	def __init__(self):
		
		# TLE data in list
		self.TLE = []
		self.name = ''

		# Date and time
		self.start_date = []
		self.date = []

		# Calculation parameters
		self.sim_len = 24 # Number of hours the simulation runs for
		self.sim_step = 180 # Time step size between measurements, measured in seconds

		# Plot
		self.longitude = []
		self.latitude = []

		# Automatically start
		
		self.get_TLE()
		self.get_date()
		self.pos_in_time()
		self.map()
		r = input('PRESS ENTER TO EXIT')


	# Get TLE and date

	def get_TLE(self):
		print('\n>>>Getting TLE data...\n')
		print('Enter the (1) name and (2) TLE for the satellite you wish to chart line-by-line as instructed. Failure to do so will result in an error :(')
		print('\n\tTLE format example: \n\n\t1 25544U 98067A   20134.54218028  .00000832  00000-0  22964-4 0  9990\n\t2 25544  51.6441 159.9408 0000907 287.5638 232.4948 15.49368071226640')
		print('\n\n\tFurther examples are available at: http://celestrak.com/NORAD/elements/stations.txt\n')

		self.name = input('Type the name of your satellite or leave blank to plot the ISS. Press \'ENTER\' to continue.\n')

		# Clear previous TLE data
		self.TLE = []

		if self.name == '':
			# Automatic TLE entry. For test purposes only.

			self.name = 'ISS (Zarya)'

			# Line 1 of TLE
			self.TLE.append( '1 25544U 98067A   20136.53767674  .00002826  00000-0  58675-4 0  9990' )
			# Line 2 of TLE
			self.TLE.append( '2 25544  51.6449 150.0725 0001795 321.2979 176.4300 15.49373505226953' )

		else:
			# Line 1 of TLE
			self.TLE.append( input('Enter Line 1 of TLE: ') )
			# Line 2 of TLE
			self.TLE.append( input('Enter Line 2 of TLE: ') )			

		# Check if the right format
		"""
		Check lengths and spacing
		"""

		return self.TLE

	def get_date(self):
		print('\n>>>Getting start date...\n')
		print('Enter the start date of your satellite (Format: YYYY.MM.DD.HH.MM.SS).')
		date = input('Type \'NOW\' (or leave blank) if you wish to use the current date and time. Press \'ENTER\' to continue.\n')
		
		# If no input, take current time
		if date == '' or date == 'NOW':
			date = datetime.datetime.now().strftime("%Y.%m.%d.%H.%M.%S")

		# Parse date
		self.start_date = date.split('.')
		
		
		if len(self.start_date) != 6:
			print('Wrong date format. Try again!')
			self.get_date()
		else:
			self.start_date = [int(start) for start in self.start_date]

		# Initialize the start date
		self.date = self.start_date

		return self.start_date

	# Calculate satellite position
	def sat_pos(self):
		# Create timescale
		ts = load.timescale()

		# Satellite
		satellite = EarthSatellite(self.TLE[0],self.TLE[1],self.name,ts)

		# Find t
		t = ts.utc(self.date[0],self.date[1],self.date[2],self.date[3],self.date[4],self.date[5])
		geocentric = satellite.at(t)
		# Generate Longitude and Latitude of satellite
		y = geocentric.subpoint().latitude
		x = geocentric.subpoint().longitude
		return x,y

	def evolve_time(self):
		# Increment the seconds
		self.date[5] += self.sim_step

		# We can just add to the seconds. The functions work with this!

		return self.date

	def pos_in_time(self):
		print('\n>>>Calculating satellite position...\n')
		N = math.ceil(self.sim_len*3600 / self.sim_step)

		for i in range(0,N,1):
			x,y = self.sat_pos()
			self.longitude.append(x.degrees)
			self.latitude.append(y.degrees)
			self.evolve_time()
		
		return True

	# Map longitude, latitude -> World Map
	def map(self):
		print('\n>>>Creating satellite map...\n')

		# Print warning message
		print('Note the satellite appears to jump across the Earth when it crosses the International Date Line (IDL). Of course, it is not actually crossing the planet in such a fashion. I was going to edit this out by breaking the curve up so that I plot a new line everytime it crosses the IDL, however I realized this would be harder to track the satellite as it crosses the IDL. Thus, I decided to leave it to aid in recognizing where the satellite\'s position picks up again.\n')
		# 		Admittedly, I could have joined this 'discontinuities' with a dashed line, but then it is harder to follow a broken line...

		# Take self.pos -> map points onto 2D map of Earth
		im = plt.imread('World Map.png')
		implot = plt.imshow(im,extent=[-180,180,-90,90])
		start_date = str(self.start_date[0]) + '-' + str(self.start_date[1]) + '-' + str(self.start_date[2])
		title = '24h Orbit of ' + self.name + ' starting on ' + start_date
		plt.title(title)
		plt.xlabel('Longitude')
		plt.ylabel('Latitude')

		plt.plot(self.longitude,self.latitude, 'r-')
		plt.show()
		
		return True

def run():
	x = track_satellite()
	return True

run()