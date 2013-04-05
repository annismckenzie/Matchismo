//
//  SetCard.h
//  Matchismo
//
//  Created by Daniel Lohse on 4/3/13.
//  Copyright (c) 2013 dozeo GmbH. All rights reserved.
//

#import "PlayingCard.h"

@interface SetCard : PlayingCard

@property (strong, nonatomic) NSString *color;
@property (nonatomic) CGFloat shading;

+ (NSArray *)validColors;
+ (NSArray *)validShades;

@end
