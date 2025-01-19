# SelfStarter

Make your julia scripts self-starters!

# How to Use

To use `SelfStarter` in your scripts, just invoke the `@selfstarter` macro on the main body of your script in a `begin...end` block.

```julia
using SelfStarter

@selfstart begin

    using Distributions

    function using_distributions()
        println("This is some other function that uses Distributions.")
        println("A random number!: $(rand(InverseGaussian(1.5, 10)))")
    end

    function main(args)
        println("I am doing stuff with the args: $args!")
        using_distributions()
    end

    main(ARGS)
end
```
