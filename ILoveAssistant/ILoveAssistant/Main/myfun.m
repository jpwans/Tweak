//
//  myfun.m
//  ILoveAssistant
//
//  Created by user on 15/10/7.
//
//

//#import <Foundation/Foundation.h>

#import "myfun.h"

DWORD result;
DWORD newSp;

DWORD sp8;
DWORD sp1c;
DWORD sp18;

static void (*old_getResults)();

static
void* getResults_real(id obj) {
    
    asm volatile(
                 "mov %0, r0\n"
                 : "=r"(result)
                 :
                 :
                 );
    
    sp8=*(DWORD*)(newSp+0x8);
    sp1c=*(DWORD*)(newSp+0x1c);
    sp18=*(DWORD*)(newSp+0x18);
    //WDLog("send results:%@",result);
    NSLog(@"hook了 r0=%d sp=%d 8=%lx 1c=%lx 18=%lx",result,newSp,sp8,sp1c,sp18);
    
    
    return old_getResults;
}

static  void $getResults(){
    
    asm volatile(
                 "mov %0, sp\n"
                 : "=r"(newSp)
                 :
                 :
                 );
    
    //__asm__ __volatile__("mov %[ps],#2" :[ps]"=r"(mVal) : :);
    
    asm volatile(
                 "stmfd sp!,{r0}\n"
                 "stmfd sp!,{r0-r12,r14}\n"
                 "bl %0\n"
                 "str r0,[sp,#0x38]\n"
                 "ldmfd sp!,{r0-r12,r14}\n"
                 "ldmfd sp!,{pc}\n"
                 :
                 :"g"(getResults_real)
                 :
                 );
}

void hook1() {
    unsigned long getResults = (_dyld_get_image_vmaddr_slide(0) + (0x11333))|1;
    MSHookFunction((void *)getResults, (void *)$getResults, (void **)&old_getResults);//arg1:目标地址 arg2:要替换的函数 arg3:原始地址
    NSLog(@"hook了 getResults:%p", (void*)getResults);
    //WDLog(".");
}






void getJb()//收取金币等材料
{
    typedef DWORD (*type_clickAll)(byte* arg1);//收取金币
    type_clickAll clickAll=(type_clickAll)0x53341;
    byte mybyte[258];
    *(DWORD*)(mybyte+0x74)=0;
    *(DWORD*)(mybyte+0xF8)=4;//此数据为6是收集材料 4是升级建筑
    
    clickAll(mybyte);//收取金币
}







//全局变量不能放在 头文件里面吗?
float gem;//宝石 钻石
float gold;//金币
float wood;//木材
float stone;//石材
float metal;//钢材
void getAllGoods()//获取当前自己现有的 宝石 金币 木材 石材 钢材
{
    

}

void getAllBulid()//遍历基地
{
    
    hook1();
    getAllGoods();//获取当前自己现有的 宝石 金币 木材 石材 钢材
    
    
}

void checkWorld()//切换基地/世界地图
{
    typedef DWORD (*type_clickMap)(DWORD *dwMap);
    byte dwMap[255];//0xF5
    *(DWORD*)(dwMap+0xF4)=8;
    *(DWORD*)(dwMap+0x74)=0;//
    type_clickMap clickMap=(type_clickMap)0x00033145;
    clickMap((DWORD*)dwMap);//切换基地/世界地图
}
//检测当前是否是世界地图 如果是则返回1 如果是基地则返回0
DWORD checkIsWorld()
{
    DWORD ret=0;
    DWORD base1=*(DWORD*)0x321451;
    if (base1>0xFFFF) {
        DWORD base158=*(DWORD*)(base1+0x158);
        DWORD base15c=*(DWORD*)(base1+0x15c);
        if(base158>0xFFFF && base158 != base15c)
        {
            ret =1;
        }
    }
    NSLog(@"基地/世界地图 =%d",ret);
    return ret;
}


void getZs(DWORD dwDx)//收取钻石
{
    //我们观察发现 [dwDx+0x20]=f是钻石
    //然后我们的调用call的参数是 [dwDx+0x70]
    DWORD my20=*(DWORD*)(dwDx+0x20);
    DWORD my70=*(DWORD*)(dwDx+0x70);
    if (my20==0xf && my70>0xFFFF) {
        typedef DWORD (*type_clickZs)(DWORD *dwZs);
        type_clickZs clickZs=(type_clickZs)0x00321353;
        clickZs(my70);//切换基地/世界地图
        [NSThread sleepForTimeInterval:1];
    }
    else
    {
        NSLog(@"不是钻石不收取!");
    }
    
}


void getWorldBuild()//遍历世界地图
{
    /*
     [421bd0]
     [[421bd0]+158]!=[[421bd0]+15c]则
     [[[[421bd0]+158]]]+0x12c]-[[[[421bd0]+158]]]+0x128]得到的数除4 就是总共有多少个 世界数据
     然后[[[[[421bd0]+158]]]+0x128]+numI*4]一直读取到结束
     */
    NSLog(@"begin----------");
    
    
    DWORD base1=*(DWORD*)0x31234;
    if (base1>0xFFFF) {
        NSLog(@"base1 =%lx",base1);
        DWORD base158=*(DWORD*)(base1+0x158);
        DWORD base15c=*(DWORD*)(base1+0x15c);
        NSLog(@"base158 =%lx",base158);
        NSLog(@"base15c =%lx",base15c);
        if(base158>0xFFFF && base158 != base15c)
        {
            
        }
    }
}



