# -*- coding: utf-8 -*-
import numpy as np

data = np.loadtxt('values.txt', skiprows=1)
nd = data.shape[0]
nv = data.shape[1]
covmx = np.cov(data.T)
v = ['x','y']

print("Kovariancia mátrix Monte Carlo szimulációval")
print(" adatok száma: {:d}".format(nd))
print("kovariancia mátrix")
for i in range(nv):
    for j in range(nv):
        print("{0:2s}{1:2s}: {2:8.4e}".format(v[i],v[j],covmx[i,j]))



