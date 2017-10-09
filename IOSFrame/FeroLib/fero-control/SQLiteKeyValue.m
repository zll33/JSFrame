//
//  SQLiteKeyValue.m
//  FreeCondomWeb
//
//  Created by kzd on 14-4-10.
//  Copyright (c) 2014年 kzd. All rights reserved.
//

#import "SQLiteKeyValue.h"
#import "HelpApi.h"
sqlite3 *database=NULL;

sqlite3 * openSQLite3(){
    if (database==NULL) {
        NSArray *array=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsPaths=[array objectAtIndex:0];
        NSString *databasePaths=[documentsPaths stringByAppendingPathComponent:@"KeyValue_KZDDB"];
        //新建数据库，存在则打开，不存在则创建
        if (sqlite3_open([databasePaths UTF8String], &database)==SQLITE_OK)
        {
            NSLog(@"SQLite3 open success");
            char *errorMsg;
            NSString *sql=@"create table if not exists KeyValue(Key text primary key,Value text,Time integer)";
            //创建表
            if (sqlite3_exec(database, [sql UTF8String], NULL, NULL, &errorMsg)==SQLITE_OK )
            {
                NSLog(@"SQLite3 create success");
                return database;
            }else{
                NSLog(@"SQLite3 create error:%s",errorMsg);
                sqlite3_free(errorMsg);
            }
        }else{NSLog(@"SQLite3 open failed");}
        colosSQLite3();
    }
    return database;
}
void colosSQLite3(){
    if (database!=NULL) {
        sqlite3_close(database);
        database= NULL;
    }
}

@implementation SQLiteKeyValue
+(bool) add:(NSString*)key Value:(NSString*)value
{
   bool ret =false;
    //添加数据
    sqlite3_stmt *stmt=nil;//定义sql语句对象
    int flag=sqlite3_prepare_v2(database, "insert into KeyValue(Key,Value,Time) values(?,?,?)", -1, &stmt, nil);//调用预处理函数将sql语句赋值给stmt对象  多值绑定逗号隔开
    if (flag==SQLITE_OK)
    {
        sqlite3_bind_text(stmt, 1, [key UTF8String],-1,nil);//给问号占位符赋值
        sqlite3_bind_text(stmt, 2, [value UTF8String],-1,nil);//给问号占位符赋值
        sqlite3_bind_int(stmt, 3, 0);//给问号占位符赋值
        int rett = sqlite3_step(stmt);
        if(rett==SQLITE_ERROR)//执行insert动作
        {
            NSLog(@"SQLite3 insert error");
        }else{
            ret = true;
        }
    }
    sqlite3_finalize(stmt);//回收stmt对象
    return ret;
}

+(bool) updata:(NSString*)key Value:(NSString*)value
{
    bool ret =false;
    //添加数据
    sqlite3_stmt *stmt=nil;//定义sql语句对象
    int flag=sqlite3_prepare_v2(database, "update KeyValue set Value=?,Time=? where Key=?", -1, &stmt, nil);//调用预处理函数将sql语句赋值给stmt对象
    
    if (flag==SQLITE_OK)
    {
        sqlite3_bind_text(stmt, 1, [value UTF8String],-1,nil);//给问号占位符赋值
        sqlite3_bind_int(stmt, 2, 0);//给问号占位符赋值
        sqlite3_bind_text(stmt, 3, [key UTF8String],-1,nil);//给问号占位符赋值
        int rett = sqlite3_step(stmt);
        if(rett==SQLITE_ERROR)//执行insert动作
        {
            NSLog(@"SQLite3 insert error");
        }else{
            ret = true;
        }
    }
    sqlite3_finalize(stmt);//回收stmt对象
    return ret;
}
+(BOOL) getBOOLValueKey:(NSString*)key
{
    return [[SQLiteKeyValue getValueWithKey:key] boolValue];
}
+(bool) saveKey:(NSString*)key BOOLValue:(BOOL)value
{
    return [SQLiteKeyValue saveKey:key
                             Value:[[[NSNumber alloc]initWithBool:value] stringValue]];
}
+(bool) saveKey:(NSString*)key Value:(NSString*)value
{
    bool ret =false;
    openSQLite3();
    if (database) {

        sqlite3_stmt *stmt=nil;//定义sql语句对象
        int flag=sqlite3_prepare_v2(database, "select * from KeyValue where Key=?", -1, &stmt, nil);//调用预处理函数将sql语句赋值给stmt对象
        if (flag==SQLITE_OK)
        {
            sqlite3_bind_text(stmt, 1, [key UTF8String],-1,nil);//给问号占位符赋值
            if ((sqlite3_step(stmt)==SQLITE_ROW))
            {
                ret = [SQLiteKeyValue updata:key Value:value];
            }else{
                ret = [SQLiteKeyValue add:key Value:value];
            }
        }
        sqlite3_finalize(stmt);//回收stmt对象
    
    }
    return ret;
}
+(NSString*)getValueWithKey:(NSString*)key
{
    NSString* value = nil;
    openSQLite3();
    if (database) {
        sqlite3_stmt *stmt=nil;//定义sql语句对象
        int flag=sqlite3_prepare_v2(database, "select * from KeyValue where Key=?", -1, &stmt, nil);//调用预处理函数将sql语句赋值给stmt对象
        if (flag==SQLITE_OK)
        {
            sqlite3_bind_text(stmt, 1, [key UTF8String],-1,nil);//给问号占位符赋值
            //while (sqlite3_step(stmt)==SQLITE_ROW)
            if ((sqlite3_step(stmt)==SQLITE_ROW))
            {
                //根据列顺序（从零开始）
                value=[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 1)];//取nsstring数据
            }
        }
        sqlite3_finalize(stmt);//回收stmt对象
    }
    return value;
}

+(bool) saveJsonKey:(NSString*)key Value:(XJson*)value
{
    NSString* valueStr = toString(value);
    return [SQLiteKeyValue saveKey:key Value:valueStr];
}
+(bool) saveJsonArrKey:(NSString*)key Value:(XJsonArray*)value
{
    NSString* valueStr = toString(value);
    return [SQLiteKeyValue saveKey:key Value:valueStr];
}

+(XJson*)getJsonWithKey:(NSString*)key
{
    XJson* json = nil;
   
    @try {
        NSString* valueStr = [SQLiteKeyValue getValueWithKey:key];
        if(valueStr.length>0){
            json =  [XJson newWithString:valueStr];
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        return json;
    }
}
+(XJsonArray*)getJsonArrWithKey:(NSString*)key
{
    XJsonArray* jARR = nil;
    
    @try {
        NSString* valueStr = [SQLiteKeyValue getValueWithKey:key];
        if([valueStr length]>0){
            jARR =  [XJsonArray newJArrWithString:valueStr];
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        return jARR;
    }
}

@end
