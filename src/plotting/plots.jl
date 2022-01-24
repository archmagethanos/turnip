# Of course first you have to load the package
using GRUtils
# Example data
x = LinRange(0, 10, 500)
y = sin.(x.^2) .* exp.(-x)
# Making a line plot is as simple as this:
plot(x, y)
# Then hold the plot to add the envelope...
hold(true)
# The envelope is given in two columns,
# plotted as dashed lines ("--") in black color ("k")
plot(exp.(0:10).^-1 .* [1 -1], "--k")
# Now set the Y-axis limits, and annotate the plot
ylim(-0.5, 0.5)
legend("signal", "envelope")
xlabel("X")
ylabel("Y")
title("Example plot")

savefig("output/example.svg")

