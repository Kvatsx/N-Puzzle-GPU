# Kaustav Vats (2016048)

import matplotlib.pyplot as plt

# In[]
x = [8, 15]
# x = [0, 8]
y = [
    [58, 8905442],
    [2429, 0],
    [14, 680001],
    [10, 312]
]
# y = [
#     [0, 58],
#     [0, 2429],
#     [0, 14],
#     [0, 10]
# ]
size = ["Bfs", "Dfs", "A*", "IDA*"]

# In[]
color = ['b', 'r', 'g', "y"]
plt.figure()
for i in range(len(size)):
    plt.plot(x, y[i][:], color[i], label="Execution time of %s"%size[i])
    plt.ylabel("Execution Time in us")
    plt.xlabel("Value of N in N-Puzzle Problem")
    plt.title("Execution time for all serial algorithms")
    plt.legend(loc='best')
    # plt.show()
plt.savefig("serial_graph.png")
