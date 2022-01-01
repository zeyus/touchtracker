import numpy as np

x=1000
y=0
z=0

y,z = (y+20, z+20) if x > 100 else (y, z)

print(y,z)

v=np.array([x,y,z])
if v[0] > 100: v[1:] = v[1:]+20

print(v)