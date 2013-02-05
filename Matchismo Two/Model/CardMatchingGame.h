//
//  CardMatchingGame.h
//  Matchismo Two
//
//  Created by Joe McMahon on 2/2/13.
//  Copyright (c) 2013 Joe McMahon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"

@interface CardMatchingGame : NSObject

// designated initializer
- (id) initWithCardCount:(NSUInteger)cardCount
              usingDeck:(Deck *)deck
              matchCount:(NSUInteger)matchCount;

- (void) flipCardAtIndex:(NSUInteger)index;

-(Card *)cardAtIndex:(NSUInteger)index;

// Set this to change the number of cards per match
@property (nonatomic) int matchCount;

// Current game score
@property (nonatomic, readonly) int score;

// Point score/cost of the last move
@property (nonatomic, readonly) int pointsForMove;

// Text representation of the last move
@property (nonatomic, readonly) NSString *lastMove;


@end
