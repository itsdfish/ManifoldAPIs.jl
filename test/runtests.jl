using SafeTestsets

files = filter(f -> f ≠ "runtests.jl" && contains(f, ".jl"), readdir())

include.(files)
