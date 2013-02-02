//
//  Deck.h
//  Matchismo
//
//  Created by Joe McMahon on 2/2/13.
//  Copyright (c) 2013 Joe McMahon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface Deck : NSObject

- (void)addCard:(id)card atTop:(BOOL)atTheTop;
- (Card *)drawRandomCard;

@end
