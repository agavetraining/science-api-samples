#!/usr/bin/python

import random
import matplotlib

matplotlib.use('Agg')

import matplotlib.pyplot as plt



print "hello"

# plot the values of 100 random points
x = random.sample(range(1000), 100)
xbins = [0, len(x)]
plt.bar(range(0,100), x)
#plt.show()
plt.savefig('/home/ubuntu/scratch/results/myHistogram.png',format='png')
