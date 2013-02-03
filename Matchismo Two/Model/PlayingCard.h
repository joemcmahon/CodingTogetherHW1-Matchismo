//
//  PlayingCard.h
//  Matchismo
//
//  Created by Joe McMahon on 2/2/13.
//  Copyright (c) 2013 Joe McMahon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"


@interface PlayingCard : Card

@property (strong, nonatomic) NSString *suit;
@property (nonatomic) NSUInteger rank;

- (NSString *) contents;

+ (NSArray *) validSuits;
+ (NSUInteger) maxRank;

@end
