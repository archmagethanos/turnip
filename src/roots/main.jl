using PyCall
include("export.jl")

#generateQ = pyimport("src/polynomials/generate_q.py")

max_denom = "200"

generateRoots("q_to_denom_" * max_denom, "q_to_roots_" * max_denom, "csv")

max_denom = "400"

generateRoots("q_to_denom_" * max_denom, "q_to_roots_" * max_denom, "csv")