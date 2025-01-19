using SelfStarter

@selfstart begin

    using Distributions

    function other_function()
        println("This is some other function that uses Distributions.")
        println("A random number!: $(rand(InverseGaussian(1.5, 10)))")
    end

    function main(args)
        println("I am doing stuff with the args: $args")
        other_function()
    end

    main(ARGS)
end
