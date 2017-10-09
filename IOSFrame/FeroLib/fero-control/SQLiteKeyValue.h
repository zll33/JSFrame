//
//  SQLiteKeyValue.h
//  FreeCondomWeb
//
//  Created by kzd on 14-4-10.
//  Copyright (c) 2014年 kzd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"
#import "XJson.h"
sqlite3 * openSQLite3();
void colosSQLite3();
@interface SQLiteKeyValue : NSObject
+(bool) saveKey:(NSString*)key Value:(NSString*)value;
+(bool) saveKey:(NSString*)key BOOLValue:(BOOL)value;
+(BOOL) getBOOLValueKey:(NSString*)key;

+(NSString*)getValueWithKey:(NSString*)key;

+(bool) saveJsonKey:(NSString*)key Value:(XJson*)value;
+(XJson*)getJsonWithKey:(NSString*)key;
+(bool) saveJsonArrKey:(NSString*)key Value:(XJsonArray*)value;
+(XJsonArray*)getJsonArrWithKey:(NSString*)key;

@end
