//
//  ListaContacto.h
//  Lab03
//
//  Created by Alberto Cordero Arellanes on 05/02/15.
//  Copyright (c) 2015 AlbertoCorderoArellanes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import <Twitter/Twitter.h>

@interface ListaContacto : UIViewController <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *imagen;
@property (strong, nonatomic) IBOutlet UILabel *estado;
@property (strong, nonatomic) IBOutlet UILabel *nombre;

@end
