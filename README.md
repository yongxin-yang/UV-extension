# introduction-lower version
**UV has several advantages :**
- It has the fastest speed compared with other old packege managers such as pip and conda
- Unlike pip, which only lists individual packages in requirements.txt without recording dependency relationships, uv represents all project dependencies as a unified, lockfile-based bundle.
---
however,it also has some disadvantage : 
- you cannot create virtual env by name -they must be created in each project 
- it lacks tools for managing multiple virturl environments easily
---
**based on those reason, I designed this extension**

# advanced phrase
UV offers exceptional speed compared to traditional package managers like pip and conda.
However, it has limitations — for example, it does not support managing virtual environments by name or handling multiple environments centrally.
To address these issues, I developed an extension inspired by Conda’s environment management.
