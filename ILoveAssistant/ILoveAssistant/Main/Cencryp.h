#pragma once
//数据加密类
#include "Header.h"
//class Cencryp
//{
//public:
//	Cencryp(void);
//public:
//	~Cencryp(void);
//	static void GetRandom(char Random[]);//获取16byte随机数
//	static void encrypt(unsigned long * v, unsigned long * k);//tea 加密 v=8byte数据 k=16位密钥
//	static void decrypt(unsigned long * v, unsigned long * k);//tea 解密 v=8byte数据 k=16位密钥
//	static void encryptLen(unsigned long * v, unsigned long * k,int len);//tea 加密 v=8byte数据 k=16位密钥 (参3必须指定数据的长度 且数据长度必须是8的倍数)
//	static void decryptLen(unsigned long * v, unsigned long * k,int len);//tea 解密 v=8byte数据 k=16位密钥 (参3必须指定数据的长度 且数据长度必须是8的倍数)
//	//以下是答题相当的
//	static void encryptDt(unsigned long * v, unsigned long * k);//tea 加密 v=8byte数据 k=16位密钥
//	static void decryptDt(unsigned long * v, unsigned long * k);//tea 解密 v=8byte数据 k=16位密钥
//	static void encryptLenDt(unsigned long * v, unsigned long * k,int len);//tea 加密 v=8byte数据 k=16位密钥 (参3必须指定数据的长度 且数据长度必须是8的倍数)
//	static void decryptLenDt(unsigned long * v, unsigned long * k,int len);//tea 解密 v=8byte数据 k=16位密钥 (参3必须指定数据的长度 且数据长度必须是8的倍数)
//
//};

//发送登录消息结构体 注册结构体
typedef struct tLogin
{
	char sUser[16];//帐号
	char sPass[16];//密码
	char sBind[32];//机器码
}*pLogin;

//返回登录确认消息
typedef struct tLoginResp
{
	DWORD sUnknown;//未知
	DWORD sUnknown2;//未知
	DWORD sUnknown3;//未知
	DWORD dwResult;//1帐号或密码错误 2余额不足 3梆定的帐号或机器码不对 4成功登录
}*pLoginResp;

//返回注册消息
typedef struct tRegResp
{
	DWORD dwResult;//1帐号或密码错误 2余额不足 3梆定的帐号或机器码不对 4成功登录
}*pRegResp;

//发送充值消息
typedef struct tCz
{
	char sUser[16];//充入帐号
	char sCard[24];//充值卡号
	char sCardPass[24];//充值密码
}*pCz;
//返回充值消息
typedef struct tCzResp
{
	DWORD sUnknown;//未知
	DWORD sUnknown2;//未知
	DWORD dwResult;//充值消息
}*pCzResp;
//查询余额
typedef struct tYe
{
	char sUser[16];//帐号
}*pYe;
//返回余额
typedef struct tYeResp
{
	DWORD sUnknown;//未知
	DWORD sUnknown2;//未知
	DWORD dwResult;//余额
}*pYeResp;
//发送计算机名/当前用户名 给服务器
typedef struct tComputer
{
	char sComputer[25];//计算机名
	char sComputerUser[25];//用户名
}*pComputer;

//服务器生成的 密钥给客户机登录用
typedef struct tKey
{
	DWORD sUnknown;//未知
	DWORD sUnknown2;//未知
	char szKey[16];//16位密钥
}*pKey;
//通信相关的命令类型
/*CM1;注册帐号
CM2;返回注册消息
CM3;充值
CM4;返回充值信息
CM5;查询余额
CM6;返回查询的余额
CM7;发送登录消息
CM8;返回登录确认消息
CM9;发送假消息
CM10;用来保持一个心跳socket使用
CM11;发送计算机名/当前用户名 给服务器
CM12;告诉客户机你是被人挤下线的
CM13;客户机:请求服务器分配密钥 服务器:分配成功密钥 并且回发给客户机
*/
enum commandType{CM1=161,CM2,CM3,CM4,CM5,CM6,CM7,CM8,CM9,CM10,CM11,CM12,CM13};
//数据通信总结构体 大小为88字节
typedef struct tCommand
{
	DWORD commandType;//命令类型
	DWORD length;//当前包的数据长度
	union
	{
		struct tLogin	login;//发送登录消息结构体 注册帐号结构体
		struct tLoginResp	loginResp;//返回登录确认消息
		struct tRegResp	regResp;//返回注册消息
		struct tCz	cz;//发送充值消息
		struct tCzResp	czResp;//返回充值消息
		struct tYe	ye;//查询余额
		struct tYeResp	yeResp;//返回余额
		struct tComputer tCom;//发送计算机名/当前用户名 给服务器
		struct tKey szKey;//服务器生成的 密钥给客户机登录用
	};
	char key[16];//客户端发送的 16位随机密钥
}*pCommand;





//~~~~~~~~~~~~~~~~~~~~~~~~~~以下答题器使用的数据

//发送答题数据
typedef struct dtPic
{
	DWORD dTime;//答题剩余秒数
	DWORD dtNum;//当前服务器现有题目总数
	DWORD dtNumUser;//当前服务器现有答题员
	char sPic[0x262];//机器码
}*pdtPic;


//dll发送给服务器的题目
typedef struct dtPicDll
{
	DWORD time;//题目剩余时间
	char sUser[20];//用户的帐号
	char sPic[0x262];//机器码
}*pdtPicDll;

//发送答案
typedef struct dtAnswer
{
	char answer[9];
}*pdtAnswer;

//发送答案是否正确
typedef struct dtRightError
{
	DWORD dwResult;//1正确答案 2回答错误
}*pdtRightError;

//发送我要答题
typedef struct dtWant
{
	DWORD dwResult;//为1表示我要答题 为2表示我不想答题
}*pdtWant;
//发送暂时没有题目(客户机接到后休息3秒)
typedef struct dtWait
{
	DWORD dwResult;//为1表示我没有题目请等待 (客户机接到后休息3秒)
}*pdtWait;
//发送 答题成功次数 错误次数 人为不答题 无反馈次数 晚班成功次数
typedef struct dtUserRightError
{
	DWORD dwRight;
	DWORD dwError;
	DWORD dwNot;
	DWORD dwNotDll;
	DWORD dwRightNight;
}pdtUserRightError;
//题目作废让dll重新发送题目
typedef struct dtReset
{
	DWORD dwReset;//为1表示我没有题目请等待 (客户机接到后休息3秒)
}*pdtReset;

//通信相关的命令类型
/*DT1;发送答题数据
DT2;发送答案
DT3;发送答案是否正确（1正确答案 2回答错误）
DT4;发送我要答题（为1表示我要答题 为2表示我不想答题）
DT5;发送暂时没有题目 (客户机接到后休息3秒)
DT6;心跳包
DT7;发送 答题成功次数 错误次数 人为不答题 无反馈次数
DT8;dll发送给服务器的题目
DT9;题目作废让dll重新发送题目
*/
enum commandTypedt{DT1=161,DT2,DT3,DT4,DT5,DT6,DT7,DT8,DT9};
//数据通信总结构体 大小为88字节
typedef struct dtCommand
{
	DWORD length;//当前包的数据长度 注意它包了它自己的长度一起
	DWORD commandTypedt;//命令类型
	union
	{
		struct dtPicDll dllPic;//DT8;dll发送给服务器的题目
		struct dtPic	pic;//发送答题数据
		struct dtAnswer	answer;//发送答案
		struct dtRightError	rightError;//发送答案是否正确
		struct dtWant	want;//发送我要答题
		struct dtWait	wait;//发送暂时没有题目
		struct dtUserRightError userRightError;//发送 答题成功次数 错误次数 人为不答题 无反馈次数
		struct dtReset reset1;//题目作废让dll重新发送题目
	};
}*pdtCommand;

//#ifdef __cplusplus
//extern "C" {
//#endif
//  static void GetRandom(char Random[]);//获取16byte随机数
//#ifdef __cplusplus
//}
//#endif






