import matplotlib.pyplot as plt
import numpy as np

plt.figure()
# y = np.array([[64, 62, 61], [9, 2529, 4441], [15, 29, 34], [16, 13, 11]]).transpose()

y = np.array([[69, 58, 8905442], [17, 2429, None], [39, 14, 680001], [15, 10, 321]]).transpose()
x = np.array([[3, 8, 15], [3, 8, 15], [3, 8, 15], [3, 8, 15]]).transpose()
plt.plot(x, y, '-o')
plt.title("Time taken by algorithms for increasing value of N")
plt.xlabel("Value of N in N-Puzzle problem")
plt.ylabel("Time")
plt.legend(["BFS", "DFS", "A*", "IDA*"])
plt.show()

# 69us 17us 39us 15us
# 58us 2429us 14us 10us
# 8905442us - 680001us 321us