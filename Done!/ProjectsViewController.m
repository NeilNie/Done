//
//  ProjectsViewController.m
//  Done!
//
//  Created by Yongyang Nie on 4/27/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import "ProjectsViewController.h"

@interface ProjectsViewController ()

@end

@implementation ProjectsViewController

#pragma mark - CollectionView

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    passedProject = [projects objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"TodaySegue" sender:nil];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ProjectCollectionViewCell *cell = (ProjectCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"idCollectionView" forIndexPath:indexPath];
    NSDateFormatter *formate = [[NSDateFormatter alloc] init];
    [formate setDateFormat:@"MM/dd HH:mm"];
    Projects *current = [projects objectAtIndex:indexPath.row];
    cell.titleLabel.text = current.title;
    cell.dateLabel.text = [formate stringFromDate:current.date];
    
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 1.5; //seconds
    lpgr.delegate = self;
    [self.collectionView addGestureRecognizer:lpgr];
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return projects.count;
}

#pragma mark - CreateNew Delegate

-(void)addProject:(Projects *)project{
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    [realm addObject:project];
    [realm commitWriteTransaction];
    NSLog(@"new project added %@", project);
    [self.collectionView reloadData];
}

-(void)addNewEventToProject:(Events *)event{}

#pragma mark - Private

-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    CGPoint p = [gestureRecognizer locationInView:self.collectionView];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:p];
    
    QBPopupMenuItem *item = [QBPopupMenuItem itemWithTitle:@"Delete" target:self action:@selector(gestureDelete:)];
    QBPopupMenuItem *item2 = [QBPopupMenuItem itemWithTitle:@"Info" target:self action:@selector(gestureInfo:)];
    QBPopupMenuItem *item3 = [QBPopupMenuItem itemWithTitle:@"Edit" target:self action:@selector(gestureModify:)];
    NSArray *items = @[item, item2, item3];
    
    QBPopupMenu *popupMenu = [[QBPopupMenu alloc] initWithItems:items];
    popupMenu.highlightedColor = [[UIColor colorWithRed:0 green:0.478 blue:1.0 alpha:1.0] colorWithAlphaComponent:0.8];

    ProjectCollectionViewCell *cell = (ProjectCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    
    if (indexPath == nil) {
        NSLog(@"long press on table view but not on a row");
    } else if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        [popupMenu showInView:self.collectionView targetRect:cell.frame animated:YES];
        gestureIndex = indexPath.row;
    }
}

-(void)gestureInfo:(NSNumber *)index{
    NSLog(@"%@", index);
}

-(void)gestureDelete:(NSNumber *)index{
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    [realm deleteObject:[projects objectAtIndex:gestureIndex]];
    [realm commitWriteTransaction];
    [self.collectionView reloadData];
}

-(void)gestureModify:(NSNumber *)index{
    NSLog(@"%@", index);
}

-(void)cropImagetoRound:(UIImageView *)image{
    
    CALayer *imageLayer = image.layer;
    [imageLayer setCornerRadius:5];
    [imageLayer setBorderWidth:0];
    [imageLayer setMasksToBounds:YES];
    [image.layer setCornerRadius:image.frame.size.width/2];
    [image.layer setMasksToBounds:YES];
}

- (IBAction)addNewEvent:(id)sender {
    
    [self performSegueWithIdentifier:@"newProject" sender:nil];
}

#pragma mark - Life Cycle

-(void)viewDidAppear:(BOOL)animated{
    
    if (projects.count == 0) {
        self.collectionView.hidden = YES;
    }else{
        self.collectionView.hidden = NO;
    }
    [super viewDidAppear:YES];
}

- (void)viewDidLoad {
    
    projects = [Projects allObjects];
    UISwipeGestureRecognizer *gesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(addNewEvent:)];
    gesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.collectionView addGestureRecognizer:gesture];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue destinationViewController] isKindOfClass:[TodoViewController class]]) {
        TodoViewController *viewController = [segue destinationViewController];
        viewController.project = passedProject;
        NSLog(@"passed project %@", passedProject);
    }
    else if ([[segue destinationViewController] isKindOfClass:[CreateNewVC class]]) {
        CreateNewVC *vc = [segue destinationViewController];
        vc.delegate = self;
        vc.sender = @"project";
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
