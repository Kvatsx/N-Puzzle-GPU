# Kaustav Vats (2016048)
import numpy as np
import matplotlib.pyplot as plt

x = [2, 3, 5, 7, 11]
y = [
    [140.094/50.174, 140.094/88.7876, 140.094/47.582, 140.094/47.324, 140.094/48.4481],
    # [142.933, 50.969, 89.2429, 48.0329, 47.879, 49.2266]
    # [134.6733, 44.4371, 87.5703, 50.967, 52.2875, 48.923]
]
# y = np.asarray(y[0])
# y = 8905.44/y
print(y)
# size = ["Kernel Time", "Kernel + Memory Time", "Empty Queues"]
# size = ["Kernel Time", "Kernel + Memory Time"]
size = ["Speedup"]

color = ['r', 'b', 'g']

plt.figure()
# i = 1
for i in range(len(size)):
    plt.plot(x, y[i], marker='o', color=color[i], label="%s"%size[i])
    plt.ylabel("Execution Time")
    plt.xlabel("Number of priority queues used")
    plt.title("Execution time for differnet number of priority queues")
plt.legend(loc='best')
# plt.show()
plt.savefig("Kplot.png")
