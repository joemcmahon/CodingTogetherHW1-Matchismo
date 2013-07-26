CodingTogetherHW1-Matchismo
===========================

Source for my implementation of the first homework problem.

This implementation uses a recursive scoring function in PlayingCard.m to
handle an arbitrary number of cards being matched. The cardsMatched property
was added to the game class to allow the match/score code to automatically
switch.

I rewote the game checking logic considerably; I now keep the face-up cards in
an NSMutableArray, which lets me easily pass them into the scoring function.

I chose to not abstract the game state description, as I don't think I'll be
reusing this code in a different context.  It's a tradeoff between velocity and
technical debt.
