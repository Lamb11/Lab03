//
//  persona.h
//  Lab03
//
//  Created by Alberto Cordero Arellanes on 25/01/15.
//  Copyright (c) 2015 AlbertoCorderoArellanes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface persona : NSObject{
    NSInteger identificadorID;
    NSString *fotoPersona;
    NSString *nombrePersona;
    NSString *estatusPersona;
    NSString *videoPersona;
}

@property (nonatomic, assign) NSInteger identificadorID;
@property (nonatomic, retain) NSString *fotoPersona;
@property (nonatomic, retain) NSString *nombrePersona;
@property (nonatomic, retain) NSString *statusPersona;
@property (nonatomic, retain) NSString *videoPersona;


@end
