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

@property (strong, nonatomic)       NSMutableArray *cards;
@property (strong, nonatomic)       NSMutableArray *cardsFaceUp;

@property (nonatomic, readwrite)    int score;

@property (nonatomic, readwrite)    NSString *lastMove;
@property (nonatomic, readwrite)    int pointsForMove;

@end

@implementation CardMatchingGame

#pragma mark Lazy instantiation

- (NSMutableArray *)cards {
    if (! _cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

- (NSMutableArray *)cardsFaceUp {
    // Tracks the cards that have been turned face up so far.
    if(!_cardsFaceUp) _cardsFaceUp = [[NSMutableArray alloc] init];
    return _cardsFaceUp;
}

#pragma mark Designated initializer

- (id) initWithCardCount:(NSUInteger)cardCount
               usingDeck:(Deck *)deck
              matchCount:(NSUInteger)matchCount{
    self = [super init];
    if (self) {
        self.matchCount = matchCount;
        // Draw enough cards to fill the card list.
        for (int i = 0; i < cardCount; i++) {
            Card *card = [deck drawRandomCard];
            if (!card) {
                // Fail if we ran out of cards.
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
    // Bullet-proof the card fetching; if we try to go outside of the array, return nil.
    return index < self.cards.count ? self.cards[index] : nil;
}

#pragma mark main game logic

- (void) flipCardAtIndex:(NSUInteger)index {
    Card *card = [self cardAtIndex:index];
    self.pointsForMove = 0;
    self.lastMove = @"";
    NSLog(@"score when flip starts: %d", self.score);
    
    // Assess the currently-selected card in light of the current game state.
    if (! card.isUnplayable) {
        // Card is playable...
        if (! card.isFaceUp) {
            // ...and card is face-down, so we're turning it up to see if it matches
            // anything currently face-up.
            if ([self.cardsFaceUp count]) {
                // At least one other card face up. Make sure the current one matches the card(s)
                // already face up.
                NSLog(@"Checking %@ against other cards", card.contents);
                int matchScore = [card match:self.cardsFaceUp];
                NSLog(@"Tentative match score is %d", matchScore);
            
                if (matchScore) {
                    // New card matches face-up cards. Turn it up, and add it to the face-up list.
                    // (Score is zero if the card did not match.)
                    [self.cardsFaceUp addObject:card];
                    card.faceUp = YES;
                    
                    NSLog(@"%d cards face up", [self.cardsFaceUp count]);
                    if ([self.cardsFaceUp count] == self.matchCount) {
                        // Build the status message, listing the matching cards.
                        self.lastMove = [NSString stringWithFormat:@"Matched"];
                        for (Card *displayCard in self.cardsFaceUp) {
                            // Append each matched card with a space in front of it.
                            self.lastMove =
                            [self.lastMove stringByAppendingString:
                                [NSString stringWithFormat:@" %@", displayCard.contents]];
                            displayCard.faceUp = YES;
                            
                            // This card has been matched out; mark it unplayable now.
                            displayCard.unplayable = YES;
                        }
                        NSLog(@"%@",self.lastMove);
                        
                        // Mark the current card unplayable too.
                        card.unplayable = YES;
                        card.faceUp = YES;
                        
                        // No cards are face up now.
                        self.cardsFaceUp = nil;
                        
                        // Update the score.
                        self.pointsForMove = matchScore * MATCH_BONUS;
                        NSLog(@"Move is worth %d points", self.pointsForMove);
                    }
                }
                else {
                    // This card didn't match the ones already face-up.
                    self.pointsForMove = -MISMATCH_PENALTY;
                    self.lastMove = [NSString stringWithFormat:@"%@ doesn't match",
                                     card.contents];
                    NSLog(@"Bad move costs %d points", self.pointsForMove);
                    
                    // Trun all face-up cards down.
                    for (Card *displayCard in self.cardsFaceUp) {
                        self.lastMove = [self.lastMove stringByAppendingString:[NSString stringWithFormat:@" %@", displayCard.contents]];
                        displayCard.faceUp = NO;
                    }
                    
                    // No face-up cards now.
                    self.cardsFaceUp = nil;
                    
                    // dd this one.
                    [self.cardsFaceUp addObject:card];
                    card.faceUp = YES;
                    NSLog(@"%@",self.lastMove);
                }
            }
            else {
                // No other cards up. Just remember this one. Don't match. Turn it face up.
                [self.cardsFaceUp addObject:card];
                card.faceUp = YES;
                NSLog(@"First card");
                NSLog(@"%@",self.cardsFaceUp);
            }
            // Card management done. If we didn't have anything else to say, just say we flipped
            // up the current card. Charge the flip cost.
            if ([self.lastMove isEqualToString:@""]) {
                self.lastMove = [NSString stringWithFormat:  @"Flipped up %@", card.contents];
                self.pointsForMove -= FLIP_COST;
                NSLog(@"Move is worth %d points", self.pointsForMove);
            }
        }
        else {
            // Card was already face-up. Turn it face-down and remove it from the face-up
            // list. No charge.
            NSLog(@"Flipping card down");
            [self.cardsFaceUp removeObject:card];
            card.faceUp = NO;
            self.lastMove = [NSString stringWithFormat:  @"Flipped down %@", card.contents];
        }
    }
    // Update score with however many points (or penalties).
    self.score += self.pointsForMove;
    NSLog(@"Score is now %d",self.score);
}
@end
