//
//  MainViewController.h
//  Done!
//
//  Created by Yongyang Nie on 6/6/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import <LGSideMenuController/LGSideMenuController.h>

@interface MainViewController : LGSideMenuController

- (void)setupWithPresentationStyle:(LGSideMenuPresentationStyle)style
                              type:(NSUInteger)type;

@end
