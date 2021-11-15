# turnip
Turnip is an open source collection of scripts and tools created in Julia to investigate q-polynomials and other objects in relation to two bridge links and hyperbolic knot theory.

The main focus has been on generating and displaying the roots (input `x` values for which a function `f(x) = 0`) to q polynomials. The roots are complex numbers, so each value is a two-dimensional point. 

### Attributions and Further Reading:
This project is part of ongoing work by students in Dr. Eric Chesebro & Dr. Ryan Grady's Undergraduate Research Group at the University of Montana and Montana State University.
- http://www.umt.edu/people/chesebro
- https://www.math.montana.edu/rgrady/index.html
- https://arxiv.org/abs/1902.01968
- https://arxiv.org/abs/2008.13303

Our aesthetic and programmatic inspiration came from the  beautiful images generated and shared by John Baez, Dan Christensen, and Sam Derbyshire.
- https://www.scientificamerican.com/article/math-polynomial-roots/
- http://jdc.math.uwo.ca/roots/
- https://math.ucr.edu/home/baez/roots/

A similar project, rootviz, was created by nessig.github.io
- https://github.com/nessig/rootviz

### To-Do:
* Implement tile webserver
* Transition generating notebooks to Julia
* Upload prior research into two-bridge knots and links
* Develop client ui
- contour detection
- blob detection
* serve multi-channel images 
* serve queries for tile and pyramid metadata
- DeepNote publishing of notebooks.
- Add R Shiny interactive website workflow
