//
//  personaDAO.h
//  Lab03
//
//  Created by Alberto Cordero Arellanes on 25/01/15.
//  Copyright (c) 2015 AlbertoCorderoArellanes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface personaDAO : NSObject{
    sqlite3 *bd;
}

- (NSMutableArray *) obtenerPersona;
- (NSString *) obtenerRutaBD;


@end
