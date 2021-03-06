# touchtracker

Work in progress

Flutter project for Mobile + Web.

Like mousetracking, but for touch. Output CSV / logs are compatible with the [mousetrap R library](http://pascalkieslich.github.io/mousetrap/index.html). 

Example data analysis can be seen in [the example_data_analysis dirctory of this repo](https://github.com/zeyus/touchtracker/tree/main/example_data_analysis).

Tested working on Android and Web.

## Current state

mousetrap csv compatible flutter (Android, iOS, Web) touch tracking implementation of [Falk, Winter, and Spivey's “Candle-Candle-Candle-Candy: Continuous Attraction Toward Previously Seen Phonological Competitors.” (2013)](https://escholarship.org/uc/item/11c5k48v#main) experiment.

### Try it out

You can [run the latest touchtracker](https://zeyus.com/touchtracker/web/index.html) web release to give it a go.

## Future plans

After finishing using the app for a research project, I want to decouple the experiment and make it somewhat easy to use the app as an experiment builder (or maybe just a "player") which can be customized with various assets (sounds, images, text prompts). Using the Candle-Candy experiment as a demo / tutorial.

## License

Copyright (c) 2021-2022 [zeyus](https://github.com/zeyus).

[OSL 3.0](LICENSE.txt)
