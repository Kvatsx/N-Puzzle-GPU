# Kaustav Vats (2016048)

import matplotlib.pyplot as plt

# In[]
# x = [8, 15, 24]
x = [0, 8]
# y = [
#     [58, 911.311, 929.279],
#     [2429, 262.004, 277.582],
#     [14, 262.004, 277.582],
#     [10, 262.004, 277.582]
# ]
y = [
    [0, 58],
    [0, 2429],
    [0, 14],
    [0, 10]
]
size = ["Bfs", "Dfs", "A*", "IDA*"]

# In[]
color = ['b', 'r', 'g', "y"]
plt.figure()
for i in range(len(size)):
    plt.plot(x, y[i][:], color[i], label="Speedup of %s"%size[i])
    plt.ylabel("Execution Time in us")
    plt.xlabel("Value of N in N-Puzzle Problem")
    plt.title("Execution time for all serial algorithms")
    plt.legend(loc='best')
    # plt.show()
plt.savefig("serial_graph.png")
