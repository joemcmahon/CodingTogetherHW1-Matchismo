//
//  GameMove.h
//  Matchismo Two
//
//  Created by Joe McMahon on 2/4/13.
//  Copyright (c) 2013 Joe McMahon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlayingCard.h"

@interface GameMove : NSObject
@property (nonatomic, strong) PlayingCard *card;
@property (nonatomic, getter = wasFlippedUp) BOOL flippedUp;
@property (nonatomic, getter = didMatch) BOOL matched;
@property (nonatomic, strong) NSArray *matchingCards;
@property (nonatomic) NSUInteger score;
@end
