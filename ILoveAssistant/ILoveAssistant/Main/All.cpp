////#include "StdAfx.h"
//#include "All.h"
//
////通讯常量
//char *szIp="113.105.152.15";//服务器IP  218.16.122.163
////char *szIp="192.168.1.100";//服务器IP  218.16.122.163
//
//#ifndef VERSION_VER
//	//季飞
//	#if VER_KAI == 1//为1是普通 为2是4开
//	WORD hPort=9824;//服务器端口
//	WORD hPortKeep=9825;//服务器端口 保持socket端口
//	WORD hPortDll=9814;//服务器端口 (dll发送题目)
//	#elif VER_KAI == 2
//	WORD hPort=9824;//服务器端口
//	WORD hPortKeep=9825;//服务器端口 保持socket端口
//	WORD hPortDll=9814;//服务器端口 (dll发送题目)
//	#endif
//
//#endif
//
//#ifdef VERSION_VER
////小林
//WORD hPort=9820;//服务器端口
//WORD hPortKeep=9821;//服务器端口 保持socket端口
//WORD hPortDll=9814;//服务器端口 (dll发送题目)
//
//#endif
//
//
//
//
//All::All(void)
//{
//}
//
//All::~All(void)
//{
//}
//bool All::recvM(SOCKET clientSocket,tCommand& recvComm)//接收数据 返回TRUE表示成功 FALSE失败去要退出
//{
//	bool ret=TRUE;
//	int recvNum=0;//需要接收88个数据
//	int recvCt;
//	int tick=GetTickCount();
//	while(1)
//	{
//		fd_set fs;
//		timeval ti;
//		fs.fd_count=1;
//		fs.fd_array[0]=clientSocket;
//		ti.tv_sec=0;
//		ti.tv_usec=200*1000;
//		int recvSf=select(0,&fs,NULL,NULL,&ti);//;返回 0没有数据到达 1已经有数据到达 SOCKET_ERROR链路中断 
//		if(recvSf==SOCKET_ERROR)
//		{
//			ret=FALSE;
//			//outputEdit("链路中断,退出");
//			break;
//		}
//		if(recvSf)//有数据到达
//		{
//			recvCt=recv(clientSocket,(char*)(&recvComm)+recvNum,sizeof(tCommand)-recvNum,0);//接收数据
//			if(recvCt==SOCKET_ERROR)
//			{
//				ret=FALSE;
//				//outputEdit("接收数据时套接字失败,退出");
//				break;
//			}
//			if(recvCt==0)
//			{
//				ret=FALSE;
//				//outputEdit("接收到的数据为0 估计客户端退出了，结束");
//				break;
//			}
//			recvNum+=recvCt;//接收的数据长度++  
//			if(recvNum==88 || recvNum>88)
//			{
//				//outputEdit("接收88数据完成..");
//				break;
//			}
//
//			//char buf[30];
//			//wsprintf(buf,"当前接收的数据是=%d",recvNum);
//			//outputEdit(buf);
//
//		}
//		if((GetTickCount()-tick)>30*1000)
//		{
//			ret=FALSE;
//			//outputEdit("接收数据超时12秒，退出");
//			break;
//		}
//	}
//	return ret;
//}
//bool All::recvMKeep(SOCKET clientSocket,tCommand& recvComm)//接收数据 返回TRUE表示成功 FALSE失败去要退出  (保持socket链接用)
//{
//	bool ret=TRUE;
//	int recvNum=0;//需要接收88个数据
//	int recvCt;
//	int tick=GetTickCount();
//	while(1)
//	{
//		fd_set fs;
//		timeval ti;
//		fs.fd_count=1;
//		fs.fd_array[0]=clientSocket;
//		ti.tv_sec=0;
//		ti.tv_usec=200*1000;
//		int recvSf=select(0,&fs,NULL,NULL,&ti);//;返回 0没有数据到达 1已经有数据到达 SOCKET_ERROR链路中断 
//		if(recvSf==SOCKET_ERROR)
//		{
//			ret=FALSE;
//			//OutputDebugString("select错误");
//			break;
//		}
//		if(recvSf)//有数据到达
//		{
//			recvCt=recv(clientSocket,(char*)(&recvComm)+recvNum,sizeof(tCommand)-recvNum,0);//接收数据
//			if(recvCt==SOCKET_ERROR)
//			{
//				ret=FALSE;
//				//OutputDebugString("recv错误");
//				break;
//			}
//			if(recvCt==0)
//			{
//				ret=FALSE;
//				//OutputDebugString("recv接收的数据为0,表示服务器断开了");
//				break;
//			}
//			recvNum+=recvCt;//接收的数据长度++  
//			if(recvNum==88 || recvNum>88)
//			{
//				//outputEdit("接收88数据完成..");
//				break;
//			}
//
//			//char buf[30];
//			//wsprintf(buf,"当前接收的数据是=%d",recvNum);
//			//outputEdit(buf);
//
//		}
//		if((GetTickCount()-tick)>20*1000)
//		{
//			//ret=FALSE;
//			//outputEdit("接收数据超时12秒，退出");
//			break;
//		}
//	}
//	return ret;
//}

//outputEdit("处理查询余额 消息");
//outputEdit((char*)&recvComm.ye.sUser);
//recvuserYe=userYe((char*)&recvComm.ye.sUser);//查询余额 返回88888888不存在此帐号 正常返回余额
//sendComm.commandType=CM6;
//sendComm.yeResp.dwResult=recvuserYe;//将要返回的消息
//break;

////处理消息线程
//DWORD _stdcall CMserverDlg::_socketThread(LPVOID sock)
//{
//    char nowIp[255];
//    if(m_saveSocket==(SOCKET)sock)//保存本次的socket 如果socket一样则拷贝IP，不然就拷贝1.1.1.1
//        strcpy(nowIp,m_szNowIp);//读取一下本次连接的IP地址
//    else
//        strcpy(nowIp,"1.1.1.1");//本次IP被冲掉了
//    
//    outputEdit(nowIp);
//    
//    SOCKET clientSocket=(SOCKET)sock;
//    tCommand recvComm,sendComm;//接收数据 发送数据
//    int tick=GetTickCount();
//    while(1)
//    {
//        int ret=recvM(clientSocket,recvComm);//接收88数据
//        if(ret==FALSE)
//        {
//            outputEdit("recvM返回失败 退出");
//            break;
//        }
//        Cencryp::decryptLen((unsigned long*)&recvComm,(unsigned long*)&recvComm.key,72);//解密 加解密部份的数据长度是88-16=72
//        recvCommandProc(recvComm,sendComm,nowIp);//对客户端接收的数据进行分析处理 然后再对要发送的SendComm进行处理
//        
//        Cencryp::encryptLen((unsigned long*)&sendComm,(unsigned long*)&recvComm.key,72);//利用客户端的密钥对数据加密 加密 加解密部份的数据是88-16=72
//        send(clientSocket,(char*)&sendComm,88,0);//发送数据
//        if((GetTickCount()-tick)>20*1000)
//        {
//            ret=FALSE;
//            outputEdit("client线程超时20秒，退出");
//            break;
//        }
//        
//    }
//    closesocket(clientSocket);
//    outputEdit("关闭套接子,结束-------------------");
//    return 0;
//}
//


