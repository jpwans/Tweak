//
//  myfun.h
//  ILoveAssistant
//
//  Created by user on 15/10/7.
//
//

#ifndef ILoveAssistant_myfun_h
#define ILoveAssistant_myfun_h
int abc1;

void hook1();
void getJb();//收取金币等材料
/*
float gem;//宝石 钻石
float gold;//金币
float wood;//木材
float stone;//石材
float metal;//钢材
 */

void getAllGoods();//获取当前自己现有的 宝石 金币 木材 石材 钢材
void getAllBulid();//遍历基地
void checkWorld();//切换基地/世界地图
DWORD checkIsWorld();//检测当前是否是世界地图 如果是则返回1 如果是基地则返回0
void getZs(DWORD dwDx);//收取钻石
void getWorldBuild();//遍历世界地图


#endif
