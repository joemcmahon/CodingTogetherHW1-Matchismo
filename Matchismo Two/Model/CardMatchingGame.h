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
              usingDeck:(Deck *)deck;

- (void) flipCardAtIndex:(NSUInteger)index;

-(Card *)cardAtIndex:(NSUInteger)index;

@property (nonatomic, readonly) int score;
@property (nonatomic, readonly) NSString *lastMove;
@property (nonatomic, readonly) int pointsForMove;

@end
