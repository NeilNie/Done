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
#import "ProjectCollectionViewCell.h"

@interface ProjectsViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource>{
    RLMResults *projects;
    Projects *passedProject;
}

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end
