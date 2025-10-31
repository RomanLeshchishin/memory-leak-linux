import numpy as np
import time
data = []
for i in range(10):
    print(f"chunk {i}")
    data.append(np.random.rand(9000, 9000))
    time.sleep(300)

input("Press Enter to exit...")
