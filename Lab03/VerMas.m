//
//  VerMas.m
//  Lab03
//
//  Created by Alberto Cordero Arellanes on 06/02/15.
//  Copyright (c) 2015 AlbertoCorderoArellanes. All rights reserved.
//

#import "VerMas.h"
#import <QuartzCore/QuartzCore.h>


#import <UIKit/UIKit.h>
#import "BaseD.h"

NSString *idSelect;
NSMutableArray *dato;

@interface VerMas ()

@end

@implementation VerMas

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)initController{
    
    dato = [[BaseD getSharedInstance]consultaDB:[NSString stringWithFormat: @"select id, nombre, estado, youtube, foto FROM personas WHERE id=%@;", idSelect]];
    self.nombre.text = [dato objectAtIndex:1];
    self.estado.text = [dato objectAtIndex:2];
    self.foto.image = [UIImage imageWithData:[dato objectAtIndex:4]];
    CALayer * l = [self.foto layer];
    NSURL *url = [NSURL URLWithString:[dato objectAtIndex:3]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    
    
}

@end
