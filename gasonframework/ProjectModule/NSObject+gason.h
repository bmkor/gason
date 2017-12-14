//
//  NSObject+gason.h
//  gasonframework
//
//  Created by Benjamin on 26/11/2017.
//  Copyright © 2017 Benjamin. All rights reserved.
//

#ifndef NSObject_gason_h
#define NSObject_gason_h
#import <Foundation/Foundation.h>

@interface gason:NSObject
@property(nonatomic, assign) int parseStatus;
- (nullable NSString *) toString;
- (nullable NSNumber *) toNumber;
- (nullable NSNumber *) toBool;
- (nullable NSNumber *) length;
- (nullable NSString *) getKey;
- (nullable gason *) next;
- (nullable gason *) objectForKeyedSubscript:(nonnull NSString *) key;
- (nullable gason *) objectAtIndexedSubscript:(NSUInteger) index;
- (nonnull instancetype) initWithJSON:(nonnull NSString *) json;
- (nonnull instancetype) initWithData:(nonnull NSData *) data;
- (nonnull NSString *) dumpValue:(int) indent;

@end


#endif /* NSObject_gason_h */
