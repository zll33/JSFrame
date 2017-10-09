//
//  JsSQLite.m
//  IOSFrame
//
//  Created by zhangxiuquan on 2017/9/29.
//  Copyright © 2017年 zhangxiuquan. All rights reserved.
//

#import "JsSQLite.h"
#import "SQLiteKeyValue.h"
#import "HelpApi.h"
sqlite3 *databaseHtmlKeyValue=NULL;
void colosHtmlKeyValueSQLite3(){
    if (databaseHtmlKeyValue!=NULL) {
        sqlite3_close(databaseHtmlKeyValue);
        databaseHtmlKeyValue= NULL;
    }
}
sqlite3 * openHtmlKeyValueSQLite3(){
    if (databaseHtmlKeyValue==NULL) {
        NSArray *array=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsPaths=[array objectAtIndex:0];
        NSString *databasePaths=[documentsPaths stringByAppendingPathComponent:@"KeyValue_Fero_JSKeyValue"];
        //新建数据库，存在则打开，不存在则创建
        if (sqlite3_open([databasePaths UTF8String], &databaseHtmlKeyValue)==SQLITE_OK)
        {
            NSLog(@"HtmlSQLite3 open success");
            char *errorMsg;
            NSString *sql=@"create table if not exists KeyValue(Key text primary key,Value text,AppKey text,Time double)";
            //创建表
            if (sqlite3_exec(databaseHtmlKeyValue, [sql UTF8String], NULL, NULL, &errorMsg)==SQLITE_OK )
            {
                NSLog(@"HtmlSQLite3 create success");
                return databaseHtmlKeyValue;
            }else{
                NSLog(@"HtmlSQLite3 create error:%s",errorMsg);
                sqlite3_free(errorMsg);
            }
        }else{NSLog(@"HtmlSQLite3 open failed");}
        colosHtmlKeyValueSQLite3();
    }
    return databaseHtmlKeyValue;
}


@implementation JsSQLite
+(bool) add:(NSString*)key AppKey:(NSString*)appKey Value:(NSString*)value
{
    bool ret =false;
    //添加数据
    sqlite3_stmt *stmt=nil;//定义sql语句对象
    int flag=sqlite3_prepare_v2(databaseHtmlKeyValue, "insert into KeyValue(Key,AppKey,Value,Time) values(?,?,?,?)", -1, &stmt, nil);//调用预处理函数将sql语句赋值给stmt对象  多值绑定逗号隔开
    if (flag==SQLITE_OK)
    {
        sqlite3_bind_text(stmt, 1, [key UTF8String],-1,nil);//给问号占位符赋值
        sqlite3_bind_text(stmt, 2, [appKey UTF8String],-1,nil);//给问号占位符赋值
        sqlite3_bind_text(stmt, 3, [value UTF8String],-1,nil);//给问号占位符赋值
        sqlite3_bind_double(stmt, 4, [[NSDate new]timeIntervalSince1970]);//给问号占位符赋值
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

+(bool) updata:(NSString*)key AppKey:(NSString*)appKey Value:(NSString*)value
{
    bool ret =false;
    //添加数据
    sqlite3_stmt *stmt=nil;//定义sql语句对象
    int flag=sqlite3_prepare_v2(databaseHtmlKeyValue, "update KeyValue set Value=?,Time=? where Key=? and AppKey=? ", -1, &stmt, nil);//调用预处理函数将sql语句赋值给stmt对象
    
    if (flag==SQLITE_OK)
    {
        sqlite3_bind_text(stmt, 1, [value UTF8String],-1,nil);//给问号占位符赋值
        sqlite3_bind_double(stmt, 2, [[NSDate new]timeIntervalSince1970]);//给问号占位符赋值
        
        sqlite3_bind_text(stmt, 3, [key UTF8String],-1,nil);//给问号占位符赋值
        sqlite3_bind_text(stmt, 4, [appKey UTF8String],-1,nil);//给问号占位符赋值
        
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



//保存一个html页面
+(bool)saveKey:(NSString*)key Value:(NSString*)value AppKey:(NSString*)appKey;
{
    bool ret =false;
    openHtmlKeyValueSQLite3();
    if (databaseHtmlKeyValue) {
        
        sqlite3_stmt *stmt=nil;//定义sql语句对象
        int flag=sqlite3_prepare_v2(databaseHtmlKeyValue, "select * from KeyValue where Key=? and AppKey=? ", -1, &stmt, nil);//调用预处理函数将sql语句赋值给stmt对象
        if (flag==SQLITE_OK)
        {
            sqlite3_bind_text(stmt, 1, [key UTF8String],-1,nil);//给问号占位符赋值
            sqlite3_bind_text(stmt, 2, [appKey UTF8String],-1,nil);//给问号占位符赋值
            if ((sqlite3_step(stmt)==SQLITE_ROW))
            {
                ret = [JsSQLite updata:key  AppKey:(NSString*)appKey Value:(NSString*)value];
            }else{
                ret = [JsSQLite add:key AppKey:(NSString*)appKey Value:(NSString*)value];
            }
        }
        sqlite3_finalize(stmt);//回收stmt对象
        
    }
    return ret;
}
//更新一个html页面的时间
+(bool)removeKey:(NSString*)key AppKey:(NSString*)appKey{
    bool ret =false;
    openHtmlKeyValueSQLite3();
    if (databaseHtmlKeyValue) {
        
        //添加数据
        sqlite3_stmt *stmt=nil;//定义sql语句对象
        int flag=sqlite3_prepare_v2(databaseHtmlKeyValue, "delete from KeyValue where Key=? and AppKey=? ", -1, &stmt, nil);//调用预处理函数将sql语句赋值给stmt对象
        
        if (flag==SQLITE_OK)
        {
            sqlite3_bind_text(stmt, 1, [key UTF8String],-1,nil);//给问号占位符赋值
            sqlite3_bind_text(stmt, 2, [appKey UTF8String],-1,nil);//给问号占位符赋值
            int rett = sqlite3_step(stmt);
            if(rett==SQLITE_ERROR)//执行删除动作
            {
                NSLog(@"SQLite3 insert error");
            }else{
                ret = true;
            }
        }
        sqlite3_finalize(stmt);//回收stmt对象
        
    }
    
    return ret;
}
//获取一个html页面
+(NSString*)getValueKey:(NSString*)key AppKey:(NSString*)appKey
{
    NSString*value;
    openHtmlKeyValueSQLite3();
    if (databaseHtmlKeyValue) {
        sqlite3_stmt *stmt=nil;//定义sql语句对象
        int flag=sqlite3_prepare_v2(databaseHtmlKeyValue, "select * from KeyValue where Key=? and AppKey=?", -1, &stmt, nil);//调用预处理函数将sql语句赋值给stmt对象
        if (flag==SQLITE_OK)
        {
            sqlite3_bind_text(stmt, 1, [key UTF8String],-1,nil);//给问号占位符赋值
            sqlite3_bind_text(stmt, 2, [appKey UTF8String],-1,nil);//给问号占位符赋值
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
@end
