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
    switch (current.color) {
        case 0:
            cell.color.backgroundColor = [UIColor blueColor];
            break;
        case 1:
            cell.color.backgroundColor = [UIColor greenColor];
            break;
        case 2:
            cell.color.backgroundColor = [UIColor yellowColor];
            break;
        case 3:
            cell.color.backgroundColor = [UIColor orangeColor];
            break;
            
        default:
            cell.color.backgroundColor = [UIColor blueColor];
            break;
    }
    CALayer *imageLayer = cell.color.layer;
    [imageLayer setCornerRadius:5];
    [imageLayer setBorderWidth:0];
    [imageLayer setMasksToBounds:YES];
    [cell.color.layer setCornerRadius:cell.color.frame.size.width/2];
    [cell.color.layer setMasksToBounds:YES];
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return projects.count;
}

- (void)viewDidLoad {
    
//    RLMRealm *realm = [RLMRealm defaultRealm];
//    [realm beginWriteTransaction];
//    Projects *project = [[Projects alloc] init];
//    project.title = @"Project 2";
//    project.date = [NSDate date];
//    [realm addObject:project];
//    [realm commitWriteTransaction];
    projects = [Projects allObjects];
    NSLog(@"all projects %@", projects);
    
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
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
