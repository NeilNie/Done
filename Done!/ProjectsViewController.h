//
//  ProjectsViewController.h
//  Done!
//
//  Created by Yongyang Nie on 4/27/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Realm/Realm.h>

#import "Events.h"
#import "Projects.h"
#import "TodoViewController.h"
#import "CreateNewVC.h"
#import "ProjectCollectionViewCell.h"
#import "QBPopupMenu.h"
#import "EAIntroView.h"
#import "PurchaseViewController.h"
#import "RZTransitionsInteractionControllers.h"
#import "RZTransitionsAnimationControllers.h"
#import "RZTransitionInteractionControllerProtocol.h"
#import "RZTransitionsManager.h"

NSInteger gestureIndex;

@import GoogleMobileAds;

@interface ProjectsViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource, CreateNewDelegate, UIGestureRecognizerDelegate, EAIntroDelegate, RZTransitionInteractionControllerDelegate>{
    RLMResults *projects;
    Projects *passedProject;
}
@property (nonatomic, strong) id<RZTransitionInteractionController> presentInteractionController;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet GADBannerView *banner;

@end
