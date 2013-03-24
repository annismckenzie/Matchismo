//
//  Deck.m
//  Matchismo
//
//  Created by Daniel Lohse on 3/23/13.
//  Copyright (c) 2013 dozeo GmbH. All rights reserved.
//

#import "Deck.h"

@interface Deck()
@property (strong, nonatomic) NSMutableArray *cards; // of Card
@end

@implementation Deck

- (NSMutableArray *)cards
{
  if (!_cards) _cards = [[NSMutableArray alloc] init];

  return _cards;
}

- (void)addCard:(Card *)card atTop:(BOOL)atTop
{
  if (atTop) {
    [self.cards insertObject:card atIndex:0];
  } else {
    [self.cards addObject:card];
  }
}

- (Card *)drawRandomCard
{
  Card *randomCard = nil;

  if ([self canDrawCard]) {
    unsigned index = arc4random() % self.cards.count;
    randomCard = self.cards[index];
    [self.cards removeObjectAtIndex:index];
  }

  return randomCard;
}

- (BOOL)canDrawCard
{
  return self.cards.count;
}

@end
