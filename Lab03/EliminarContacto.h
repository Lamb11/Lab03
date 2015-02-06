//
//  EliminarContacto.h
//  Lab03
//
//  Created by Alberto Cordero Arellanes on 06/02/15.
//  Copyright (c) 2015 AlbertoCorderoArellanes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseD.h"


@interface EliminarContacto : UIViewController <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *Elimina;
@end
