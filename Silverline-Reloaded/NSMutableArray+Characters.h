//
//  NSMutableArray+Characters.h
//  Silverline-Reloaded
//
//  Created by Marc Rink on 23.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AsyncSocket.h"

#import "Character.h"

@interface NSMutableArray (Characters)
-(Character *)getCharacterWithName:(NSString *)name;
-(NSString *)handleMessage:(NSArray *)p withSocket:(AsyncSocket*)socket;

@end
