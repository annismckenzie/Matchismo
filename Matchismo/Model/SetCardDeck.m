//
//  SetDeck.m
//  Matchismo
//
//  Created by Daniel Lohse on 4/3/13.
//  Copyright (c) 2013 dozeo GmbH. All rights reserved.
//

#import "SetCardDeck.h"
#import "SetCard.h"

@implementation SetCardDeck

- (id)init
{
  self = [super init];

  if (self) {
    for (NSString *suit in [SetCard validSuits]) {
      for (NSUInteger rank = 1; rank <= [SetCard maxRank]; rank++) {
        for (NSString *color in [SetCard validColors]) {
          for (NSUInteger shadeIndex = 0; shadeIndex < [[SetCard validShades] count]; shadeIndex++) {
            SetCard *card = [[SetCard alloc] init];
            card.rank = rank;
            card.suit = suit;
            card.color = color;
            card.shading = [[[SetCard validShades] objectAtIndex:shadeIndex] floatValue];

            [self addCard:card atTop:YES];
          }
        }
      }
    }
  }

  return self;
}

@end
