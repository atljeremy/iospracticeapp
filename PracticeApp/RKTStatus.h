//
//  ATLStatus.h
//  PracticeApp
//
//  Created by Jeremy Fox on 4/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <RestKit/RestKit.h>
#import <RestKit/CoreData.h>

@interface RKTStatus : NSManagedObject {
}

/**
 * The unique ID of this Status
 */
@property (nonatomic, retain) NSNumber* statusID;

/**
 * Timestamp the Status was sent
 */
@property (nonatomic, retain) NSDate* createdAt;

/**
 * Text of the Status
 */
@property (nonatomic, retain) NSString* text;

/**
 * String version of the URL associated with the Status
 */
@property (nonatomic, retain) NSString* urlString;

/**
 * The User who posted this status
 */
@property (nonatomic, retain) NSManagedObject* user;

@end
