# Hangman

This project is a part of [The Odin Project's](https://www.theodinproject.com) Ruby curriculum. 

In case you don't know what Hangman is, click [here](https://en.wikipedia.org/wiki/Hangman_(game)).


## Closer look
The project is a basic implementation of Hangman. The computer chooses a random word, between 5 and 12 characters, and your job is to guess that word by picking individual letters. If you fail to do so within 8 rounds, the computer finishes the hangman stickman and you lose. 


## Additional info
- While picking a letter, you can save the current game by entering ``` save ``` into the terminal, or quit the game without saving by using ``` quit ```.
- As for the save names, only *letters* from the english alphabet, *digits* from 0 to 9, *hyphens* and *underscores* are supported. If your save name isn't valid, it will be named automatically to ``` saveX ```, where X is the current number of saved games.
