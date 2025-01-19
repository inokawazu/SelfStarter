using SelfStarter

@selfstart begin
    using Plots # Starts slow on first run
    
    function make_plot()
        plot(sinpi, -1, 3, title = "Sinpi from SelfStarter", xlabel = "x", ylabel = "sinpi")
    end

    my_plot = make_plot()
    display(my_plot)
    print("Press enter to continue or a filename to save graph: ")
    filename = readline()
    if !isempty(filename)
        savefig(my_plot, filename)
    end
end
