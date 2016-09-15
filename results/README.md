This directory takes care of your basic data processing.

- `process.py` is a script which parses the data files in `data/`,
  calculates the relevant summary statistics for each trajectory, and
  saves them to `processed.csv`. It also outputs the processed
  trajectories to `nx.csv`, `ny.csv` (both normalisime time),
  `rx.csv`, and `ry.csv` (both real time), for future
  analysis/plotting.

- `viewResults.ipynb` is a notebook demonstrating some ways of visualing
  the processed mouse trajectories. 


