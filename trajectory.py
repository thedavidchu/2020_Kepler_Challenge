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
- Collect all TLEs off a website

Sources:
1. https://rhodesmill.org/skyfield/earth-satellites.html
"""

class track_satellite:
	def __init__(self):
		
		# TLE data in list
		self.TLE = []

		# Date and time
		self.start_date = []
		self.date = []
		self.step = 180 # Measured in seconds

		# Plot
		self.longitude = []
		self.latitude = []

	# Run class
	def run(self):
		print('>>>Get TLE')
		print(self.get_TLE())
		print('>>>Get Date')
		print(self.get_date())
		print('>>>Get SAT POS')
		self.pos_in_time()
		print('>>>Get Map')
		self.map()

		return True

	# Get TLE and date
	def help(self):
		print('TLE format example: \n1 25544U 98067A   20134.54218028  .00000832  00000-0  22964-4 0  9990\n2 25544  51.6441 159.9408 0000907 287.5638 232.4948 15.49368071226640')
		return True

	def get_TLE(self):
		r = input('Enter the TLE for the satellite you wish to chart one line at a time. Type \'HELP\' for further instructions. Press \'ENTER\' to continue.\n')

		# Check if needed help
		if r == 'HELP':
			self.help()
		elif r == '':
			# Line 1 of TLE
			self.TLE.append( '1 25544U 98067A   20134.54218028  .00000832  00000-0  22964-4 0  9990' )
			# Line 2 of TLE
			self.TLE.append( '2 25544  51.6441 159.9408 0000907 287.5638 232.4948 15.49368071226640' )
		else:
			# Line 1 of TLE
			self.TLE.append( [input('Enter Line 1 of TLE:')] )
			# Line 2 of TLE
			self.TLE.append( [input('Enter Line 2 of TLE:')] )

		# Check if the right format
		"""
		Check lengths and spacing
		"""

		return self.TLE

	def get_date(self):
		date = input('Enter the start date of your satellite (Format: YYYY.MM.DD.HH.MM.SS).')
		
		# If no input, take current time
		if date == '':
			date = datetime.datetime.now().strftime("%Y.%m.%d.%H.%M.%S")

		# Parse date
		self.start_date = date.split('.')
		
		
		if len(self.start_date) != 6:
			print('You got the date format wrong, mate! Try again...')
			self.get_date()
		else:
			self.start_date = [int(start) for start in self.start_date]

		# Initialize the start date
		self.date = self.start_date

		return self.start_date

	# Calculate satellite position
	def sat_pos(self):
		#Invalid...self.pos = skyfield.EarthSatellite()
		ts = load.timescale()

		# Does not identify satellite's name
		satellite = EarthSatellite(self.TLE[0],self.TLE[1],'Satellite',ts)

		# Find t
		t = ts.utc(self.date[0],self.date[1],self.date[2],self.date[3],self.date[4],self.date[5])
		geocentric = satellite.at(t)

		# Generate Longitude and Latitude of satellite
		y = geocentric.subpoint().latitude
		x = geocentric.subpoint().longitude

		#print('- Lat:', x, '\n  Long:', y)

		return x,y

	def evolve_time(self):
		# Increment the seconds
		self.date[5] += self.step

		# We can just add to the seconds. The functions work with this!

		return self.date

	def pos_in_time(self):
		N = math.ceil(24*3600 / self.step)

		for i in range(0,N,1):
			x,y = self.sat_pos()
			self.longitude.append(x.degrees)
			self.latitude.append(y.degrees)
			self.evolve_time()

		return True

	# Map longitude, latitude -> World Map
	def map(self):
		# Take self.pos -> map points onto 2D map of Earth
		im = plt.imread('World Map.png')
		implot = plt.imshow(im,extent=[-180,180,-90,90])
		#print(self.longitude,self.latitude)

		plt.plot(self.longitude,self.latitude, 'r-')
		plt.show()
		return True

def run():
	x = track_satellite()
	x.run()

	input('PRESS ENTER TO EXIT')

	return True

run()