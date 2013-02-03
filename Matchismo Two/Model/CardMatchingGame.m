//
//  CardMatchingGame.m
//  Matchismo Two
//
//  Created by Joe McMahon on 2/2/13.
//  Copyright (c) 2013 Joe McMahon. All rights reserved.
//

#import "CardMatchingGame.h"
#import "Deck.h"
#import "Card.h"
#import "PlayingCard.h"

#define MATCH_BONUS         4
#define MISMATCH_PENALTY    2
#define FLIP_COST           1

@interface CardMatchingGame()
@property (strong, nonatomic) NSMutableArray *cards;
@property (nonatomic, readwrite) int score;
@end

@implementation CardMatchingGame

- (NSMutableArray *)cards {
    if (! _cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

- (id) initWithCardCount:(NSUInteger)cardCount usingDeck:(Deck *)deck {
    self = [super init];
    if (self) {
        for (int i = 0; i < cardCount; i++) {
            Card *card = [deck drawRandomCard];
            if (!card) {
                self = nil;
                break;
            }
            else {
                self.cards[i] = card;
            }
        }
    }
    return self;
}

- (Card *)cardAtIndex:(NSUInteger)index {
    return index < self.cards.count ? self.cards[index] : nil;
}

- (void) flipCardAtIndex:(NSUInteger)index {
    NSLog(@"score currently %d", self.score);
    
    Card *card = [self cardAtIndex:index];
    
    if (! card.isUnplayable) {
        if (! card.isFaceUp) {
            for (Card *otherCard in self.cards) {
                if (otherCard.isFaceUp && !otherCard.isUnplayable) {
                    int matchScore = [card match:@[otherCard]];
                    if (matchScore) {
                        otherCard.unplayable = YES;
                        card.unplayable = YES;
                        self.score += matchScore * MATCH_BONUS;
                        NSLog(@"bumped score by %d", matchScore * MATCH_BONUS);
                    }
                    else {
                        otherCard.faceUp = NO;
                        self.score -= MISMATCH_PENALTY;
                        NSLog(@"took the mismatch hit of 2");
                    }
                    break;
                }
            }
            self.score -= FLIP_COST;
            NSLog(@"took the reveal hit of 1");
        }
        card.faceUp = ! card.faceUp;
    }
    NSLog(@"score is now %d", self.score);
}
@end
