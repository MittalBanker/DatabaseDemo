//
//  DBManager.m
//  testSample
//
//  Created by Mittal J. Banker on 22/09/16.
//  Copyright © 2016 digicorp. All rights reserved.
//

#import "DBManager.h"

@implementation DBManager

static DBManager *sharedInstance = nil;
static sqlite3 *database = nil;
static sqlite3_stmt *statement = nil;

+(DBManager*)getSharedInstance{
    if (!sharedInstance) {
        sharedInstance = [[super allocWithZone:NULL]init];
        [sharedInstance createDB];
    }
    return sharedInstance;
}

-(BOOL)createDB{
    NSString *docsDir;
    NSArray *dirPaths;
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString:
                    [docsDir stringByAppendingPathComponent: @"student.db"]];
    BOOL isSuccess = YES;
    NSFileManager *filemgr = [NSFileManager defaultManager];
    if ([filemgr fileExistsAtPath: databasePath ] == NO)
    {
        const char *dbpath = [databasePath UTF8String];
        if (sqlite3_open(dbpath, &database) == SQLITE_OK)
        {
            
            //to copy database from bundle
            NSString *localDB=[[NSBundle mainBundle] pathForResource:@"studentsDetail" ofType:@"sqlite"];
            NSError *err;
            if(![filemgr copyItemAtPath:localDB toPath:databasePath error:&err]){
                //NSLog(@"Error in creating DB -> %@",err);
            }
            
            //to create database dynamically
            char *errMsg;
            const char *sql_stmt = "create table if not exists studentsDetail (regno integer"
            "primary key, name text, department text, year text)";
            if (sqlite3_exec(database, sql_stmt, NULL, NULL, &errMsg)
                != SQLITE_OK)
            {
                isSuccess = NO;
                NSLog(@"Failed to create table");
            }
            sqlite3_close(database);
            sqlite3_finalize(statement);
            sqlite3_close(database);
            return  isSuccess;
        }
        else {
            isSuccess = NO;
            NSLog(@"Failed to open/create database");
        }
    }
    return isSuccess;
}

- (BOOL) saveData:(NSString*)registerNumber name:(NSString*)name
       department:(NSString*)department year:(NSString*)year;
{
    BOOL success;
    if([self findByRegisterNumber:registerNumber].count>0){
        
        [self updateData:registerNumber name:name department:department year:year];
        
        return true;
    }
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat:@"insert into studentsDetail (regno,name, department, year) values                                (\"%ld\",\"%@\", \"%@\", \"%@\")",(long)[registerNumber integerValue],name, department, year];
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            success =  YES;
        }
        else {
            success = NO;
        }
        sqlite3_finalize(statement);
        sqlite3_close(database);
    }
    return success;
}

- (BOOL) updateData:(NSString*)registerNumber name:(NSString*)name
       department:(NSString*)department year:(NSString*)year;
{
    BOOL success;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"update studentsDetail set name= '%@', department = '%@', year = '%@' where  regno = %ld",name, department, year,(long)[registerNumber integerValue]];
        const char *update_stmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(database, update_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            success =  YES;
        }
        else {
            success =  NO;
             NSLog( @"Error: %s", sqlite3_errmsg(database)) ;
        }
        sqlite3_finalize(statement);
        sqlite3_close(database);
        
    }
    return success;
}


- (NSArray*) findByRegisterNumber:(NSString*)registerNumber
{
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"select name, department, year from studentsDetail where                                      regno=\"%@\"",registerNumber];
        const char *query_stmt = [querySQL UTF8String];
        NSMutableArray *resultArray = [[NSMutableArray alloc]init];
        if (sqlite3_prepare_v2(database,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSString *name = [[NSString alloc] initWithUTF8String:
                                  (const char *) sqlite3_column_text(statement, 0)];
                [resultArray addObject:name];
                NSString *department = [[NSString alloc] initWithUTF8String:
                                        (const char *) sqlite3_column_text(statement, 1)];
                [resultArray addObject:department];
                NSString *year = [[NSString alloc]initWithUTF8String:
                                  (const char *) sqlite3_column_text(statement, 2)];
                [resultArray addObject:year];
                sqlite3_finalize(statement);
                sqlite3_close(database);
                return resultArray;
            }
            else{
                NSLog(@"Not found");
                sqlite3_finalize(statement);
                sqlite3_close(database);
                return nil;
            }
         
        }
    }
    return nil;
}

-(NSMutableArray*)selectData{
    NSMutableArray *resultArray = [[NSMutableArray alloc]init];
    // Check if the query is non-executable.
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"select regno,name, department, year from studentsDetail"];
      
        if (sqlite3_prepare_v2(database, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSString *name = [[NSString alloc] initWithUTF8String:
                                  (const char *) sqlite3_column_text(statement, 0)];
                [resultArray addObject:name];
            }
            sqlite3_reset(statement);
        }
  
       
    }
    sqlite3_finalize(statement);
    sqlite3_close(database);
    return resultArray;
}

- (BOOL)deleteData:(NSString*)registerNumber
{


    
      const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK) {
        
        NSString *sql = [NSString stringWithFormat:@"delete from studentsDetail where regno =%d",[registerNumber intValue]];
        
        const char *del_stmt = [sql UTF8String];
        
        sqlite3_prepare_v2(database, del_stmt, -1, & statement, NULL);
        if(SQLITE_DONE != sqlite3_step(statement))
        {
           NSLog( @"Error: %s", sqlite3_errmsg(database) );
            
        }
        else
        {
             return YES;
            NSLog(@"Deleted chart segment successfully !");
            
        }
        sqlite3_finalize(statement);
        sqlite3_close(database);
        
        
    }
      return NO;
}

@end
