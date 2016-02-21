//////登录
////void CMyLogin::OnBnClickedButton1()
////{
////	VM_START  
////
////		CString strU,strP;
////	GetDlgItemText(IDC_EDIT1,strU);
////	GetDlgItemText(IDC_EDIT2,strP);
////	if(strU=="" || strP=="")
////	{
////		MessageBox("帐号或密码不能为空！");
////		return;
////	}
////
////	//登录
////	WORD dwVersion=MAKEWORD(2,0);//2.0套接字版本
////	WSADATA wsaD;
////	if(WSAStartup(dwVersion,&wsaD))//初始化库 返回非0失败
////	{
////		AfxMessageBox("初始化socket库失败！");
////		return;
////	}
////	SOCKET sock=socket(AF_INET,SOCK_STREAM,0);
////	if(INVALID_SOCKET==sock)
////	{
////		AfxMessageBox("socket失败！");
////		return;
////	}
////	SOCKADDR_IN addr;
////	addr.sin_addr.S_un.S_addr=inet_addr(szIp);
////	addr.sin_family=AF_INET;
////	addr.sin_port=htons(hPort);//端口
////	if(SOCKET_ERROR==connect(sock,(sockaddr*)&addr,sizeof(sockaddr_in)))
////	{
////		AfxMessageBox("连接服务器失败！");
////		return;
////	}
////
////	tCommand csend,crecv;
////	char mkey[16];//保存密钥
////	Cencryp::GetRandom(csend.key);//生成客户端的key
////	strncpy(mkey,csend.key,16);//把密钥保存一下  注册这里如果用lstrncpy 就不对了，lstrncpy会使数据第16个为0
////	csend.commandType=CM7;//命令类型 登录
////
////	char buf[100];
////	GetDlgItemText(IDC_EDIT1,buf,sizeof(buf));//帐号
////	lstrcpy(csend.login.sUser,buf);
////	GetDlgItemText(IDC_EDIT2,buf,sizeof(buf));//密码
////	lstrcpy(csend.login.sPass,buf);
////
////	//取硬盘码
////	char bind[255];
////	char bufbind[255];
////	WLHardwareGetFormattedID(37,1,bind);//Winlicense获取bios+cpu+hdd+mac序列 大写和数字 返回在参3
////	// 		;由于取出来的机器码是aaaa-bbbb-bbbb-cccc-cccc-dddd-dddd-eeee
////	// 		;aaaa = CPU ID
////	// 		;bbbb-bbbb = BIOS ID
////	// 		;cccc-cccc = HDD ID
////	// 		;dddd-dddd = MAC ID ;网卡序列很不稳定。经常变动，所以我们自己程序需要去掉dddd-dddd
////	// 		;eeee = internal value for WinLicense.
////	bind[20]=0;//我们不需要网卡序列号所以 把dddddddd去掉 因为我们取的是没有-的机器码，所以只需要去掉8位
////	lstrcat(bind,&bind[28]);
////	// 		lea esi,@szBind;//我们不需要网卡序列号所以 把dddddddd去掉 因为我们取的是没有-的机器码，所以只需要去掉8位
////	// 		mov BYTE ptr [esi+20],0
////	// 		add esi,28
////	// 		invoke	lstrcat,addr @szBind,esi
////
////
////	//MessageBox(bind);
////	lstrcpy(csend.login.sBind,bind);//拷贝机器码
////	Cencryp::encryptLen((unsigned long*)&csend,(unsigned long*)&csend.key,72);//数据加密发送  ********
////	send(sock,(char*)&csend,88,0);//发送
////	int ret=All::recvM(sock,crecv);//接收88数据
////	if(ret==FALSE)
////	{
////		MessageBox("接收数据失败，服务器错误！");
////		return;
////	}	
////	Cencryp::decryptLen((unsigned long*)&crecv,(unsigned long*)mkey,72);//解密数据
////
////
////
////
////	if(CM8==crecv.commandType)//CM8;返回登录确认消息
////	{
////		if(crecv.loginResp.dwResult==1)//返回6才能登录 1帐号或密码错误 2机器码不正确 3余额不足
////		{
////			MessageBox("帐号或密码错误！");
////		}
////		else if(crecv.loginResp.dwResult==2)
////		{
////			MessageBox("当前帐号梆定机器不正确！");
////		}
////		else if(crecv.loginResp.dwResult==3)
////		{
////			MessageBox("余额不足！");
////		}
////		else if(crecv.loginResp.dwResult==6)
////		{
////			//保存 第一次成功登录的 帐号 密码 机器码 供系统公告使用
////			extern char saveUser[50];
////			extern char savePass[50];
////			extern char saveBind[50];
////			GetDlgItemText(IDC_EDIT1,buf,sizeof(buf));//帐号
////			lstrcpy(saveUser,buf);
////			GetDlgItemText(IDC_EDIT2,buf,sizeof(buf));//密码
////			lstrcpy(savePass,buf);
////			lstrcpy(saveBind,bind);
////
////			m_isLogin=133;//标识已经登录
////			myYe(saveUser);//显示一下余额
////			EndDialog(-1);
////		}
////		else
////		{
////			MessageBox("未知错误！");
////		}
////	}
////	else
////	{
////		MessageBox("登录严重错误！");
////	}
////
////	closesocket(sock);
////	WSACleanup();
////
////	VM_END
////}
////
////
////
//////注册
////void CReg::OnBnClickedButton2()
////{
////	VM_START
////
////		CString strU,strP;
////	GetDlgItemText(IDC_EDIT1,strU);
////	GetDlgItemText(IDC_EDIT2,strP);
////	if(strU=="" || strP=="")
////	{
////		MessageBox("帐号或密码不能为空！");
////		return;
////	}
////
////
////	//注册
////	WORD dwVersion=MAKEWORD(2,0);//2.0套接字版本
////	WSADATA wsaD;
////	if(WSAStartup(dwVersion,&wsaD))//初始化库 返回非0失败
////	{
////		AfxMessageBox("初始化socket库失败！");
////		return;
////	}
////	SOCKET sock=socket(AF_INET,SOCK_STREAM,0);
////	if(INVALID_SOCKET==sock)
////	{
////		AfxMessageBox("socket失败！");
////		return;
////	}
////	SOCKADDR_IN addr;
////	addr.sin_addr.S_un.S_addr=inet_addr(m_szIp);
////	addr.sin_family=AF_INET;
////	addr.sin_port=htons(m_hPort);//端口
////	if(SOCKET_ERROR==connect(sock,(sockaddr*)&addr,sizeof(sockaddr_in)))
////	{
////		AfxMessageBox("连接服务器失败！");
////		return;
////	}
////
////	tCommand csend,crecv;
////	char mkey[16];//保存密钥
////	Cencryp::GetRandom(csend.key);//生成客户端的key
////	strncpy(mkey,csend.key,16);//把密钥保存一下  注册这里如果用lstrncpy 就不对了，lstrncpy会使数据第16个为0
////	csend.commandType=CM1;//命令类型 注册
////
////	char buf[100];
////	GetDlgItemText(IDC_EDIT1,buf,sizeof(buf));//帐号
////	lstrcpy(csend.login.sUser,buf);
////	GetDlgItemText(IDC_EDIT2,buf,sizeof(buf));//密码
////	lstrcpy(csend.login.sPass,buf);
////
////	//取硬盘码
////	char bind[255];
////	WLHardwareGetFormattedID(37,1,bind);//Winlicense获取bios+cpu+hdd+mac序列 大写和数字 返回在参3
////	// 		;由于取出来的机器码是aaaa-bbbb-bbbb-cccc-cccc-dddd-dddd-eeee
////	// 		;aaaa = CPU ID
////	// 		;bbbb-bbbb = BIOS ID
////	// 		;cccc-cccc = HDD ID
////	// 		;dddd-dddd = MAC ID ;网卡序列很不稳定。经常变动，所以我们自己程序需要去掉dddd-dddd
////	// 		;eeee = internal value for WinLicense.
////	bind[20]=0;//我们不需要网卡序列号所以 把dddddddd去掉 因为我们取的是没有-的机器码，所以只需要去掉8位
////	lstrcat(bind,&bind[28]);
////	// 		lea esi,@szBind;//我们不需要网卡序列号所以 把dddddddd去掉 因为我们取的是没有-的机器码，所以只需要去掉8位
////	// 		mov BYTE ptr [esi+20],0
////	// 		add esi,28
////	// 		invoke	lstrcat,addr @szBind,esi
////
////
////	//MessageBox(bind);
////	lstrcpy(csend.login.sBind,bind);//拷贝机器码
////	if(m_hPort==9815)//是9815 则是答题相关，则加解密函数都是用encryptLenDt decryptLenDt
////		Cencryp::encryptLenDt((unsigned long*)&csend,(unsigned long*)&csend.key,72);//数据加密发送
////	else
////		Cencryp::encryptLen((unsigned long*)&csend,(unsigned long*)&csend.key,72);//数据加密发送
////	send(sock,(char*)&csend,88,0);//发送
////	int ret=All::recvM(sock,crecv);//接收88数据
////	if(ret==FALSE)
////	{
////		MessageBox("接收数据失败，服务器错误！");
////		return;
////	}	
////	if(m_hPort==9815)//是9815 则是答题相关，则加解密函数都是用encryptLenDt decryptLenDt
////		Cencryp::decryptLenDt((unsigned long*)&crecv,(unsigned long*)mkey,72);//解密数据
////	else
////		Cencryp::decryptLen((unsigned long*)&crecv,(unsigned long*)mkey,72);//解密数据
////	if(CM2==crecv.commandType)//CM2;返回注册消息
////	{
////		switch(crecv.regResp.dwResult)//返回0表示帐号已经存在 返回1注册成功
////		{
////		case 0:
////			MessageBox("帐号已经存在,请更换注册帐号！");
////			break;
////		case 1:
////			MessageBox("恭喜注册成功！");
////			break;
////		default:
////			MessageBox("未知错误！");
////			break;
////		}
////	}
////	else
////	{
////		MessageBox("注册严重错误！");
////	}
////
////	closesocket(sock);
////	WSACleanup();
////
////	VM_END
////}
////
////
//余额
//void CYe::OnBnClickedButton1()
//{
//	VM_START
//
//
//		//余额
//		char buf[100];
//	if(0==GetDlgItemText(IDC_EDIT1,buf,sizeof(buf)))//帐号
//	{
//		MessageBox("请输入您的帐号,查询余额！");
//		return;
//	}
//
//	WORD dwVersion=MAKEWORD(2,0);//2.0套接字版本
//	WSADATA wsaD;
//	if(WSAStartup(dwVersion,&wsaD))//初始化库 返回非0失败
//	{
//		AfxMessageBox("初始化socket库失败！");
//		return;
//	}
//	SOCKET sock=socket(AF_INET,SOCK_STREAM,0);
//	if(INVALID_SOCKET==sock)
//	{
//		AfxMessageBox("socket失败！");
//		return;
//	}
//	SOCKADDR_IN addr;
//	addr.sin_addr.S_un.S_addr=inet_addr(m_szIp);
//	addr.sin_family=AF_INET;
//	addr.sin_port=htons(m_hPort);//端口
//	if(SOCKET_ERROR==connect(sock,(sockaddr*)&addr,sizeof(sockaddr_in)))
//	{
//		AfxMessageBox("连接服务器失败！");
//		return;
//	}
//
//	tCommand csend,crecv;
//	char mkey[16];//保存密钥
//	Cencryp::GetRandom(csend.key);//生成客户端的key
//	strncpy(mkey,csend.key,16);//把密钥保存一下  注册这里如果用lstrncpy 就不对了，lstrncpy会使数据第16个为0
//	csend.commandType=CM5;//命令类型 CM5;查询余额
//
//
//	lstrcpy(csend.ye.sUser,buf);//帐号
//
//	if(m_hPort==9815)//是9815 则是答题相关，则加解密函数都是用encryptLenDt decryptLenDt
//		Cencryp::encryptLenDt((unsigned long*)&csend,(unsigned long*)&csend.key,72);//数据加密发送
//	else
//		Cencryp::encryptLen((unsigned long*)&csend,(unsigned long*)&csend.key,72);//数据加密发送 *********
//	send(sock,(char*)&csend,88,0);//发送
//	int ret=All::recvM(sock,crecv);//接收88数据
//	if(ret==FALSE)
//	{
//		MessageBox("接收数据失败，服务器错误！");
//		return;
//	}	
//	if(m_hPort==9815)//是9815 则是答题相关，则加解密函数都是用encryptLenDt decryptLenDt
//		Cencryp::decryptLenDt((unsigned long*)&crecv,(unsigned long*)mkey,72);//解密数据
//	else
//		Cencryp::decryptLen((unsigned long*)&crecv,(unsigned long*)mkey,72);//解密数据  *********
//	if(CM6==crecv.commandType)//CM6;返回查询的余额
//	{
//		switch(crecv.yeResp.dwResult)//查询余额 返回88888888不存在此帐号 正常返回余额
//		{
//		case 88888888:
//			MessageBox("不存在此帐号！");
//			break;
//		default:
//			char wsBuf[100];
//			wsprintf(wsBuf,"帐号'%s'使用剩余<%d>！",buf,crecv.yeResp.dwResult);
//			MessageBox(wsBuf);
//			break;
//		}
//	}
//	else
//	{
//		MessageBox("余额严重错误！");
//	}
//
//	closesocket(sock);
//	WSACleanup();
//
//	VM_END
//}
//
////
//////充值
////void CCz::OnBnClickedButton1()
////{
////	VM_START
////
////		//灰化
////		GetDlgItem(IDC_EDIT1)->EnableWindow(FALSE);
////	GetDlgItem(IDC_EDIT2)->EnableWindow(FALSE);
////	GetDlgItem(IDC_EDIT3)->EnableWindow(FALSE);
////	GetDlgItem(IDC_BUTTON1)->EnableWindow(FALSE);
////
////	CString strU,strP,strB;
////	GetDlgItemText(IDC_EDIT1,strU);
////	GetDlgItemText(IDC_EDIT2,strP);
////	GetDlgItemText(IDC_EDIT3,strB);
////	if(strU=="" || strP=="" || strB=="")
////	{
////		MessageBox("帐号或充值卡号或充值密码不能为空！");
////		goto okhy;
////	}
////
////	//充值
////	WORD dwVersion=MAKEWORD(2,0);//2.0套接字版本
////	WSADATA wsaD;
////	if(WSAStartup(dwVersion,&wsaD))//初始化库 返回非0失败
////	{
////		AfxMessageBox("初始化socket库失败！");
////		goto okhy;
////	}
////	SOCKET sock=socket(AF_INET,SOCK_STREAM,0);
////	if(INVALID_SOCKET==sock)
////	{
////		AfxMessageBox("socket失败！");
////		goto okhy;
////	}
////	SOCKADDR_IN addr;
////	addr.sin_addr.S_un.S_addr=inet_addr(m_szIp);
////	addr.sin_family=AF_INET;
////	addr.sin_port=htons(m_hPort);//端口
////	if(SOCKET_ERROR==connect(sock,(sockaddr*)&addr,sizeof(sockaddr_in)))
////	{
////		AfxMessageBox("连接服务器失败！");
////		goto okhy;
////	}
////
////	tCommand csend,crecv;
////	char mkey[16];//保存密钥
////	Cencryp::GetRandom(csend.key);//生成客户端的key
////	strncpy(mkey,csend.key,16);//把密钥保存一下  注册这里如果用lstrncpy 就不对了，lstrncpy会使数据第16个为0
////	csend.commandType=CM3;//命令类型 CM3;充值
////
////	char buf[100];
////	GetDlgItemText(IDC_EDIT1,buf,sizeof(buf));//帐号
////	lstrcpy(csend.cz.sUser,buf);
////	GetDlgItemText(IDC_EDIT2,buf,sizeof(buf));//卡号
////	lstrcpy(csend.cz.sCard,buf);
////	GetDlgItemText(IDC_EDIT3,buf,sizeof(buf));//卡密码
////	lstrcpy(csend.cz.sCardPass,buf);
////
////	if(m_hPort==9815)//是9815 则是答题相关，则加解密函数都是用encryptLenDt decryptLenDt
////		Cencryp::encryptLenDt((unsigned long*)&csend,(unsigned long*)&csend.key,72);//数据加密发送
////	else
////		Cencryp::encryptLen((unsigned long*)&csend,(unsigned long*)&csend.key,72);//数据加密发送
////
////	send(sock,(char*)&csend,88,0);//发送
////	int ret=All::recvM(sock,crecv);//接收88数据
////	if(ret==FALSE)
////	{
////		MessageBox("接收数据失败，服务器错误！");
////		goto okhy;
////	}	
////	if(m_hPort==9815)//是9815 则是答题相关，则加解密函数都是用encryptLenDt decryptLenDt
////		Cencryp::decryptLenDt((unsigned long*)&crecv,(unsigned long*)mkey,72);//解密数据
////	else
////		Cencryp::decryptLen((unsigned long*)&crecv,(unsigned long*)mkey,72);//解密数据
////	if(CM4==crecv.commandType)//CM4;返回充值信息
////	{
////		if(crecv.czResp.dwResult==0)//返回0成功充值 返回1充值帐号不存在 返回2月卡帐号或密码错误 返回3此月卡已经被使用完
////		{
////			MessageBox("恭喜,充值成功！");
////		}
////		else if(crecv.czResp.dwResult==1)
////		{
////			MessageBox("用户帐号不存在！");
////		}
////		else if(crecv.czResp.dwResult==2)
////		{
////			MessageBox("充值卡号或充值密码错误！");
////		}
////		else if(crecv.czResp.dwResult==3)
////		{
////			MessageBox("此充值卡已经被使用！");
////		}
////		else
////		{
////			MessageBox("未知错误！");
////		}
////
////	}
////	else
////	{
////		MessageBox("充值严重错误！");
////	}
////
////	closesocket(sock);
////	WSACleanup();
////
////okhy:
////	//灰化
////	GetDlgItem(IDC_EDIT1)->EnableWindow();
////	GetDlgItem(IDC_EDIT2)->EnableWindow();
////	GetDlgItem(IDC_EDIT3)->EnableWindow();
////	GetDlgItem(IDC_BUTTON1)->EnableWindow();
////
////	VM_END
////}
////
////
//////更换梆定
////void CBind::OnBnClickedButton1()
////{
////	VM_START_WITHLEVEL(12)//12级的虚拟机
////
////		CString sUser,sPass,sBind,sBindNext;
////	GetDlgItemText(IDC_EDIT1,sUser);
////	if(sUser=="")
////	{
////		MessageBox("帐号不能为空！");
////		return;
////	}
////	GetDlgItemText(IDC_EDIT2,sPass);
////	if(sPass=="")
////	{
////		MessageBox("密码不能为空！");
////		return;
////	}
////	GetDlgItemText(IDC_EDIT3,sBind);
////	if(sBind=="")
////	{
////		MessageBox("原来的机器码 不能为空！");
////		return;
////	}
////	GetDlgItemText(IDC_EDIT13,sBindNext);
////	if(sBindNext=="")
////	{
////		MessageBox("当前机器码 不能为空！");
////		return;
////	}
////
////	char buf[1000];
////	wsprintf(buf,"http://113.105.152.15:84/bindc.aspx?ss=%s&ss2=%s&ss3=%s&ss4=%s",sUser,sPass,sBind,sBindNext);//密码 帐号 机器码
////	ShellExecute(NULL,"open",buf,NULL,NULL,SW_SHOW);
////
////	VM_END
////}