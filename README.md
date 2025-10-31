# introduction-lower version
UV has several advantages :
1. It has the fastest speed compared with other old packege managers such as pip and conda
2. Unlike pip, which only lists individual packages in requirements.txt without recording dependency relationships, uv represents all project dependencies as a unified, lockfile-based bundle.
...
however,it also has some disadvantage : 
1. you cannot create virtual env by name -they must be created in each project 
2. it lacks tools for managing multiple virturl environments easily
3. based on those reason, i designed extensions

# advanced phrase
UV offers exceptional speed compared to traditional package managers like pip and conda.
However, it has limitations — for example, it does not support managing virtual environments by name or handling multiple environments centrally.
To address these issues, I developed an extension inspired by Conda’s environment management.
