//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Daniel Lohse on 3/23/13.
//  Copyright (c) 2013 dozeo GmbH. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()
@property (readwrite, nonatomic) int score;
@property (readwrite, nonatomic) int lastMatchScore;
@property (readwrite, nonatomic) NSArray *lastFlip;
@property (strong, nonatomic) NSMutableArray *cards; // of Card
@end

@implementation CardMatchingGame

- (NSMutableArray *)cards
{
  if (!_cards) _cards = [[NSMutableArray alloc] init];

  return _cards;
}

- (Card *)cardAtIndex:(NSUInteger)index
{
  return (index < [self.cards count]) ? [self.cards objectAtIndex:index] : nil;
}

- (void)flipCardAtIndex:(NSUInteger)index
{
  Card *card = [self cardAtIndex:index];
  int dealScore = 0;
  if (card && !card.isUnplayable) {
    self.lastFlip = @[card];
    if (!card.isFaceUp) {
      NSMutableArray *otherCards = [[NSMutableArray alloc] init];
      for (Card *otherCard in self.cards) {
        if (otherCard.isFaceUp && !otherCard.isUnplayable) {
          [otherCards addObject:otherCard];
        }
      }
      dealScore += [self match:otherCards withCard:card];
    } else {
      self.lastFlip = @[];
    }
    card.faceUp = !card.isFaceUp;
    self.score += dealScore;
    self.lastMatchScore = dealScore;
  }
}

#define MATCH_BONUS 4
#define MISMATCH_PENALTY 2
#define FLIP_COST 1
- (int)match:(NSMutableArray *)cards withCard:(Card *)card
{
  int dealScore = 0;
  dealScore -= FLIP_COST;

  if (![cards count]) return dealScore;
  if ([self.mode isEqualToString:@"3-card"] && [cards count] < 2) return dealScore;

  int matchScore = [card match:cards];
  if (matchScore) {
    card.unplayable = YES;
    for (Card *otherCard in cards) { otherCard.unplayable = YES; }
    dealScore += matchScore * MATCH_BONUS;
  } else {
    for (Card *otherCard in cards) { otherCard.faceUp = NO; }
    dealScore -= MISMATCH_PENALTY;
  }
  self.lastFlip = [cards arrayByAddingObject:card];

  return dealScore;
}

- (id)initWithCardCount:(NSUInteger)count
              usingDeck:(Deck *)deck
{
  self = [super init];

  if (self) {
    for (int i = 0; i < count; i++) {
      Card *card = [deck drawRandomCard];
      if (card) {
        self.cards[i] = card;
      } else {
        self = nil;
        break;
      }
    }
  }

  return self;
}

@end
