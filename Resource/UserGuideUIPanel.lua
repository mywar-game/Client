UserGuideUIPanel = {}
--[[
save 表示要提交保存到服务器里面的。
px_Offset  py_Offset 表示手指坐标的偏移量
non_compulsory 这个true 表示是非强制的引导
]]
UserGuideUIPanel.Dialog_Pack = "Pack" -- 背包
UserGuideUIPanel.Dialog_TZ = "TuanZhang" --团长技能
UserGuideUIPanel.Dialog_TS = "TanSuo" --开发探索
UserGuideUIPanel.Dialog_JJC = "JinJiChang" --开发探索
UserGuideUIPanel.Dialog_SH ="ShengHuo" -- 生活系统
UserGuideUIPanel.Dialog_SX ="ShengXin" -- 升星系统
--新手引导位置
local winSize = cc.Director:getInstance():getWinSize()

--一些从新进来的任务
UserGuideUIPanel.guideMainTaskButton = {pic="shouyebuchong/xunlushouxiangkuang.png",name="btn_menu_guide" ,save =false,px_Offset= -80,py_Offset=-50}

--新手引导的 有声对话
UserGuideUIPanel.guideDialogString = {
{{name="蛋蛋",test="恭喜你，有一名新伙伴加入了队伍，记得要把她上阵哦!"}, },
{{name="蛋蛋",test="获得的装备要及时穿上才能发挥最大威力"}  },
{{name="蛋蛋",test="你可以在城里随便逛逛街"},{name="npc2",test="也许可以找到几个志同道合的好友"},{name="蛋蛋",test="另外城里时不时会有一些人发布任务，奖励很丰富哦"},{name="蛋蛋",test="（每个等级都有不同的支线任务可以领取）"} },
{{name="蛋蛋",test="邀请好友助阵,可以使你更轻松的击败怪物"}},
{{name="蛋蛋",test="接下来可能是一场恶战。"} ,{name="蛋蛋",test="你可以去酒馆再招募一些英雄补充战斗力"} },
{{name="蛋蛋",test="团长技能会给你带来很多协助。"} ,{name="蛋蛋",test="这是一名优秀的团长必须熟悉的技能"},{name="蛋蛋",test="(团长技能拥有各种效果)"} ,  },
{{name="蛋蛋",test="终于出城了！"} ,{name="蛋蛋",test="在你的冒险过程中你可以探索整个艾泽世界，"},{name="蛋蛋",test="说不定会发现一些拆包和一些强力英雄"},{name="蛋蛋",test="(探索可能招募到新的英雄)"} },
{{name="蛋蛋",test="你已经是一个很强力的冒险者了"} , {name="蛋蛋",test="可以尝试着去参与一些竞技活动,获得好名次的话还有不错的奖品哦"} , {name="蛋蛋",test="（竞技场每日都会结算排名，获得不菲的奖励）"} , },
{{name="蛋蛋",test="英雄升星可以快速提高英雄属性。"} ,{name="蛋蛋",test="平时收集的材料可以用材料升星，"} , {name="蛋蛋",test="如果想快速提高英雄属性也可以通过购买道具进行道具升星。"} , },
{{name="蛋蛋",test="生活技能可以让一些闲置的英雄挂机干活获取奖励。"} , {name="蛋蛋",test="左边的空地可以建造鱼池进行挂机，"} , {name="蛋蛋",test="右边的空地可以在花圃跟矿石之间选择一个进行挂机"} , {name="蛋蛋",test="以后需要的大量材料都是靠生活技能的累计哦！"} ,  },
}
--菜单的图片  urces\xinqietu\baoshi\i_wupingkx  
UserGuideUIPanel.guidePos_1001 = {  --新手任务
--1 強制 进入游戏点击主线任务框
{pic="shouyebuchong/xunlushouxiangkuang.png",name="btn_menu_guide",save =false,px_Offset= -80,py_Offset=-50,}, 
--2 強制 自动去到新兵训练营 之后   点击主线任务提示  NpcFunctionUPanel
{pic="npcduihua/renwudi.png",name="btn_click_guide",save =false,px_Offset= -80,py_Offset=-50},
--3 強制 点击了任务提示之后  点击接受任务   这一步需要保存
{pic="tongyong/anniu/b_anniuda01.png",name="btn_receive",nextPos=true,save =true,px_Offset = -80,py_Offset=-60},
--4 強制 点击了接受任务之后   可以“前往”  如果退出了程序，再次进来，我应该额外的处理。因为这一步 可以被 按一下主线任务代替。
{pic="tongyong/anniu/b_anniuda01.png",name="btn_moveTo",save =true,px_Offset= -80,py_Offset=-60},

--5 強制 去到了“杂货铺”要求点击 杂货铺  NpcFunctionUPanel
{pic="tongyong/anniu/b_hongsezhong01.png",name="btn_func1",save =false,px_Offset= -80,py_Offset=-50},
--6 強制 点击完 “杂货铺”之后。要求点击“招募” PrestigeUIPanel --点击了邀请之后。要求点击返回
{pic="tongyong/anniu/b_anniuda01.png",name="btn_exchange",nextPos=true,save =true,px_Offset= -80,py_Offset=-60,dialog = 1}, --有一个有声对话。
--7 強制 点击完"招募"之后，要求点击返回。
{pic="tongyong/anniu/b_fanhui.png",name="btn_back",nextPos=true,footPanel=true,save =true,px_Offset=-20,py_Offset=-50},

--8 強制 要求去  点击菜单的“阵容”  菜单 我这边处理 。
{pic="baoshi/i_wupingkx.png",name="image_menu_guide2",save =false,px_Offset=-80,py_Offset=-30},
--9 強制 点击完 "阵容" 之后,选着上阵的人员  HeroTeamUIPanel
{pic="duiwupeizhi/i_renwudi.png",name="img_guideBg_guide",nextPos=true,save =true,px_Offset= -100,py_Offset=-50},
--10 強制 点击完"上阵"之后，要求点击返回。
{pic="tongyong/anniu/b_fanhui.png",name="btn_back",nextPos=true,footPanel=true,save =true,px_Offset=-20,py_Offset=-50},

--11 強制 從新點擊主線任務。要求引導去 領取任務  非強制
{pic="shouyebuchong/xunlushouxiangkuang.png",name="btn_menu_guide",save =false,px_Offset= -80,py_Offset=-50 },
--12 強制 去領取任務 。當前那條任務。
{pic="npcduihua/renwudi.png",name="btn_click_guide",save =false,px_Offset= -80,py_Offset=-60 },
--13 強制 点击了當前那條任務后。看到 完成的按鈕，指引 去完成  --
{pic="tongyong/anniu/b_anniuda01.png",name="btn_complete",save =true,px_Offset = -80,py_Offset=-60,nextPos=true, },
}

UserGuideUIPanel.guidePos_1002 = {  -- 击杀豺狼人的任务
--1 15 非強制 应该指引去 点击  maiguide  接受新的任务 。但 此时打开的 是新的 任务框 打财狼人  1002 
{pic="shouyebuchong/xunlushouxiangkuang.png",name="btn_menu_guide",save =false,px_Offset= -80,py_Offset=-50,non_compulsory = true },

}

UserGuideUIPanel.guidePos_1003 = {
--1  強制  打开背包装备  HeroDescUIPanel  这一步变成强制的
{pic="baoshi/i_wupingkx.png",name="image_menu_guide2",save =false,px_Offset=-80,py_Offset=-30,},
--2  強制  点击装备一个内容上去。有2个内容要点击上去
{pic="tongyong/i_wupingkuang.png",name="image_item_guide",save =true,px_Offset= -60,py_Offset=-50,nextPos=true,},
--3 強制 点击完"上阵"之后，要求点击返回。
{pic="tongyong/anniu/b_fanhui.png",name="btn_back",nextPos=true,footPanel=true,save =true,px_Offset=-20,py_Offset=-50},

--4  非强制 去新兵训练营 接受第三个任务  指示点击领取第三个任务   击杀莫格大王
{pic="shouyebuchong/xunlushouxiangkuang.png",name="btn_menu_guide" ,save =true,px_Offset= -80,py_Offset=-50,non_compulsory = true },
--5  非强制 完成第三个任务  引导去 增加阵容。 上阵 牧师。
{pic="shouyebuchong/zhenrong.png",name="image_menu_guide3",save =true,px_Offset=-80,py_Offset=-30,non_compulsory = true},

}

UserGuideUIPanel.guidePos_1004 = {
--25 占位 不用处理 去暴风城的那个地方不用引导了。
{pic="shouyebuchong/xunlushouxiangkuang.png",name="btn_menu_guide" ,save =true,px_Offset= -80,py_Offset=-50, nextPos=true,non_compulsory = true},

}
UserGuideUIPanel.guidePos_1005 = {
--1   非强制 引导去接受任务 这个任务是  监狱叛乱 所谓的轻罪犯人 。 1005
{pic="shouyebuchong/xunlushouxiangkuang.png",name="btn_menu_guide" ,save =true,px_Offset= -80,py_Offset=-50, nextPos=true,non_compulsory = true },
--2   非强制 占位用 。用来处理弹出 一个对话框
{pic="shouyebuchong/xunlushouxiangkuang.png",name="btn_menu_guide" ,save =false,px_Offset= -80,py_Offset=-50, nextPos=true,non_compulsory = true },
--3   强制 引导去 战斗，强制的内容。一步  这个步骤先固定死。
{pic="tongyong/anniu/b_anniuda01.png",name="btn_goto" ,save =false,px_Offset= -80,py_Offset=-60,nextPos=true},
--4   强制 引导去 战斗，强制的内容。两步  
{pic="tongyong/anniu/b_fenleianniu01.png",name="btn_hy" ,save =false,px_Offset= -80,py_Offset=-50, nextPos=true},
--5   强制 引导去 战斗，强制的内容。三步 这一步比较危险。不处理。  FightDeploy
{pic="duiwupeizhi/i_renwudi.png",name="img_guideBg_guide" ,save =false,px_Offset= -80,py_Offset=-50,nextPos=true},
--6   强制 引导去 战斗，强制的内容。直接战斗。
{pic="duiwupeizhi/b_zhandou.png",name="btn_fight" ,save =true,px_Offset= -80,py_Offset=-50,nextPos=true},

}

UserGuideUIPanel.guidePos_1006 = {
--30  非强制 占位用 。用来处理弹出一个有声对话  1006  第二次副本
{pic="shouyebuchong/xunlushouxiangkuang.png",name="btn_menu_guide" ,save =false,px_Offset= -80,py_Offset=-50, nextPos=true,non_compulsory = true },
}
UserGuideUIPanel.guidePos_1007 = {--正压吃人魔	

}
UserGuideUIPanel.guidePos_1008 = {

}
UserGuideUIPanel.guidePos_1009 = { -- 团长技能 这个内容原来是应该在 1008 完成之后处理的。
--1 强制 打开菜单 
--{pic="caidan/lianmengbiaozhi.png",name="btn_menu",save =false,px_Offset= -80,py_Offset=-50,nextPos=true,},
--2  強制 要求去  点击菜单的“团长技能”  
--{pic="baoshi/i_wupingkx.png",name="image_menu_guide3",save =false,px_Offset=-80,py_Offset=-30,},
--3  強制 团队技能 点击一步就可以了
--{pic="tuanchangjineng/i_jndida.png",name="img_itemBg",save =true,px_Offset=-130,py_Offset=-100 },
--4  強制 团队技能 点击一步就可以了  -- 确定解锁
--{pic="tuanchangjineng/i_jndida.png",name="btn_qrjs",save =true,px_Offset=-130,py_Offset=-100},
}

UserGuideUIPanel.guidePos_lv10 = { -- 探索
--1 强制 占位用 。用来处理弹出一个有声对话  探索 NPC
{pic="shouyebuchong/xunlushouxiangkuang.png",name="btn_menu_guide" ,save =false,px_Offset= -80,py_Offset=-50, nextPos=true,},
--2 强制  指示打开探索菜单。
{pic="baoshi/i_wupingkx.png",name="image_menu_guide14",save =true,px_Offset=-30,py_Offset=-60, }, 
--3 强制  指示打开探索里面的探索按钮。
{pic="tongyong/anniu/b_hongsezhong01.png",name="btn_explore",save =true,px_Offset=-30,py_Offset=-60,nextPos=true,  }, 
--4 强制  指示打开探索里面的探索按钮。
{pic="tanhsuo/i_hengtiaosj.png",name="btn_one",save =true,px_Offset=-30,py_Offset=-60,nextPos=true, }, 
--5 强制  指示点击确定。 这一步比较危险。不处理。
--{pic="tongyong/anniu/b_lvsezhong01.png",name="btn_sure",save =true,px_Offset=-30,py_Offset=-60,}, 
}

UserGuideUIPanel.guidePos_lv12 = { --竞技场
--1 强制  指示打开竞技场菜单。
{pic="baoshi/i_wupingkx.png",name="image_menu_guide13",save =false,px_Offset=-30,py_Offset=-60, }, 
--2 调整  
{pic="tongyong/anniu/b_anniulv01.png",name="btn_join",save =false,px_Offset=-30,py_Offset=-60, }, 
--3 选着 3 个SB  
{pic="baoshi/i_wupingkx.png",name="Image_item_guide1",save =false,px_Offset=-30,py_Offset=-60,nextPos=true},
--4 选着 3 个SB  
{pic="baoshi/i_wupingkx.png",name="Image_item_guide2",save =false,px_Offset=-30,py_Offset=-60,nextPos=true},
--5 选着 3 个SB  
{pic="baoshi/i_wupingkx.png",name="Image_item_guide3",save =false,px_Offset=-30,py_Offset=-60,nextPos=true },
--6 选着 3 个SB 之后保存阵容 
{pic="tongyong/anniu/b_anniulv01.png",name="btn_save",save =true,px_Offset=-30,py_Offset=-60,nextPos=true },
}
UserGuideUIPanel.guidePos_lv13 = { --升星系统
--1 强制  指示打开升星
{pic="baoshi/i_wupingkx.png",name="image_menu_guide11",save =true,px_Offset=-30,py_Offset=-60,dialog = 9},


}
UserGuideUIPanel.guidePos_lv18 = { --生活系统
--1 强制  指示打开生活
{pic="baoshi/i_wupingkx.png",name="image_menu_guide2",save =false,px_Offset=-80,py_Offset=-30, dialog = 10},
}

local hand 
local pClip 
local guide --当前的指引的guide
local current_panel --当前的panel



--引导步骤遍历
function UserGuideUIPanel.findStep(idx)
	local step = DataManager.getRecordGuideStep()
	--如果传入的步骤数在列表中说明已经完成了该引导
	if #step ~= 0 then
		for k,v in pairs(step) do
			if idx == tonumber(v) then
				return true
			end
		end
	end
	return false
end
--通过任务的状态来处理这些新手引导。用在非强制性的引导。
local function getGuidTask( guideCurStep,panelname)    
      local nextStep = guideCurStep+1		
	  local maintask = DataManager.getMainlineTask()
	  local systemTaskId = 0 
      local status = 0 
	  if nil ~= maintask then
	   systemTaskId = maintask.systemTaskId
	   status = maintask.status --status 状态0可领取1已领取2已完成3已获得奖励
	  end
	  local userData  = DataManager.getUserBO()	 
      if userData.level == nil then--创建角色的 时候 会报错。
	     return nil
	  end
	  cclog("178  主线任务： systemTaskId = "..systemTaskId .."  status="..status.. "  guideCurStep ="..guideCurStep .."  nextStep =" .. nextStep  .."   ~~~~~~~~~~~~ ") 
	  local guide = nil
	  if 1001 == systemTaskId then  --第一条主任务 。 招募队友 全部都是强制的。
	         if  nextStep-1000  >  #UserGuideUIPanel.guidePos_1001  then--
			     return nil
			 end
	        guide = UserGuideUIPanel.guidePos_1001[nextStep - 1000] 
	        guide.currentGuid = nextStep
	        local sprite = current_panel:getChildByName(guide.name)  -- 新的这一步的sprite
	        if  0 == status then  -- 还没接受任务  1 -- 1003 
			
			elseif  1 == status then --去完成任务的过程 
			    if  nextStep <1011  then
				    if  1004 == nextStep then--点击前往
					    if nil == sprite then --如果中途退出 要从新引导点击 主任务引导。
					       guide = UserGuideUIPanel.guideMainTaskButton
					       guide.currentGuid = nextStep
					       guide.save = true 
						end  
					elseif 1005 == nextStep then -- 强制去杂货铺 
					   if nil == sprite then   -- 如果中途退出 要从新指引点击 主任务引导 。
						  guide = UserGuideUIPanel.guideMainTaskButton
						  guide.currentGuid =guideCurStep
					   end 
					end   
			    end
			elseif  2 == status then  -- 已经完成任务
			  	   cclog( " 249  2 == statu  " )
			    if   nextStep <=1014  then
				
				    if 1007 == nextStep then--招募已经完成的了 。
					   cclog( " 249  =  " .. nextStep )
					   if nil == sprite then  -- 在招募里面 没有 点击关闭按钮。
					   	  MainMenuUIPanel_menuMove(true)
						  nextStep =  1008  -- 打开阵容
						  guide = UserGuideUIPanel.guidePos_1001[nextStep-1000]  -- 新的这一步的guid
						  guide.currentGuid = nextStep 	
                          cclog( "256 通知打开 增容 " )						  
					  end
					elseif 1008 == nextStep  then 
                          MainMenuUIPanel_menuMove(true)
						  nextStep =  1008  -- 打开阵容
						  guide = UserGuideUIPanel.guidePos_1001[nextStep-1000]  -- 新的这一步的guid
						  guide.currentGuid = nextStep
				   
				    elseif 1010 == nextStep then  -- 要求点击阵容的返回按钮
						  if nil == sprite then 
							 nextStep = 1011  --强制领取任务 。 
							 guide = UserGuideUIPanel.guidePos_1001[nextStep-1000]  -- 新的这一步的guid
							 guide.currentGuid = nextStep 	
						  end
					end
			    end
			
			end
	  elseif 1002 == systemTaskId  then	 -- 去 击杀豺狼人的任务。
	         if nextStep <  2000 then
			    nextStep =  2001 --初始化 而已 。
			 end  
	         cclog( "226 击杀豺狼人的任务" ..nextStep .."status =="..status )
	         if  0 == status then  --表示要指示去领取任务。
			     if  nextStep <= 2001 then  -- 只需要提示领取1次
				     nextStep = 2001
					 guide = UserGuideUIPanel.guidePos_1002[1] 
					 guide.currentGuid = nextStep 	
				 end
			 elseif 2 == status then --表示要指示去提交任务
			 	 if  nextStep <= 2002  then  --不需要每次都提醒
				     nextStep = 2002
			         guide = UserGuideUIPanel.guidePos_1002[1] 
				     guide.currentGuid = nextStep 	   
				 end 
             end
			 
      elseif  1003 == systemTaskId then--招募已经完成的了  --打開背包
			 if nextStep < 3000 then
			    nextStep =  3001 --初始化 而已 。
			 end  
             cclog( " 289 处理 1003 "..nextStep.." -- "..status ) 			 
			 if   0 == status   then  -- 要求去 击杀莫格 
			      if  nextStep <= 3002 then
				      MainMenuUIPanel_menuMove(true)
					  guide = UserGuideUIPanel.guidePos_1003[nextStep -3000]  
				      guide.currentGuid = nextStep 
				      DataManager.setRecordGuideStep({nextStep})
				  elseif nextStep == 3003 then	--返回
				      guide = UserGuideUIPanel.guidePos_1003[nextStep -3000]  
				      guide.currentGuid = nextStep 
				      local sprite = current_panel:getChildByName(guide.name)  -- 新的这一步的sprite
					  if nil == sprite then  --这一步断了之后 走3005 
					     DataManager.setRecordGuideStep({nextStep})
					     nextStep = 3004 
					     LayerManager.closeFloatPanel()
					     guide = UserGuideUIPanel.guidePos_1003[nextStep -3000]  
				         guide.currentGuid = nextStep 
					  end
				  else
				      if nextStep == 3004 then  -- 通知击杀莫格大王 就显示一次而已
					     LayerManager.closeFloatPanel()
					     guide = UserGuideUIPanel.guidePos_1003[nextStep -3000]  
				         guide.currentGuid = nextStep 
					  end
				  end

			 elseif  2 == status  then -- 要求打开阵容 
			        if  nextStep <= 3005  then
					    MainMenuUIPanel_menuMove(true)
					    nextStep = 3005-- 菜单被打开 直接去阵容 
						guide = UserGuideUIPanel.guidePos_1003[nextStep - 3000]  
						guide.currentGuid = nextStep 	
					end
			 end

	  elseif 1004  == systemTaskId then  --暴风城的引导 如果完成就弹出一个 对话框
	          cclog( "289  1004  status == "..status.." nextStep=="..nextStep )
			--  return nil
	  elseif 1005 == systemTaskId then  -- 监狱叛乱  
	        if nextStep < 5000 then
			    nextStep =  5001 --初始化 而已 。
			end  
			if 0 == status then--监狱叛乱的内容。
			      if tonumber(guideCurStep)  >= 5001 then  -- 就显示一次
				     return nil
				  end
			      nextStep = 5001  --  
				  guide = UserGuideUIPanel.guidePos_1005[nextStep - 5000]  
				  guide.currentGuid = nextStep 	
			elseif 1== status then 
			    --cclog( "301 要弹出一个 有声对话  !" ..panelname.."!"  .. nextStep)
				if "FightDropUIPanel" ==  panelname  then
				    cclog( "303需要弹出一个 内容" )
					if  nextStep <=5002 then
						local function fu_nextStep()
							UserGuideUIPanel.showGuide(current_panel,false ,panelname )
						end
						DataManager.setRecordGuideStep({5002})
						LayerManager.showDialogForGuide(UserGuideUIPanel.guideDialogString[4],fu_nextStep ) 
						return nil
					else
					   nextStep = 5003
				       guide = UserGuideUIPanel.guidePos_1005[nextStep - 5000]  
				       guide.currentGuid = nextStep 
					   DataManager.setRecordGuideStep({5003})
					end
				elseif  "FightDeployUIPanel" == panelname then   
                    nextStep = 5004			
				    guide = UserGuideUIPanel.guidePos_1005[nextStep - 5000]  
				    guide.currentGuid = nextStep 
				elseif  nextStep == 5005  or nextStep == 5006 then
				    guide = UserGuideUIPanel.guidePos_1005[nextStep - 5000]  
				    guide.currentGuid = nextStep 
				end
	         end
	  elseif 1006 == systemTaskId  then --黑铁矮人
	            if  nextStep < 6000  then
				    nextStep =6001
					local req = UserAction_recordGuideStepReq:New()
			   	    req:setInt_guideStep(nextStep)
				    NetReqLua(req, true) --true标识有等待
					DataManager.setRecordGuideStep({nextStep})
				end
	         
	  elseif 1007 == systemTaskId  then --正压吃人魔	 
	           if  nextStep < 7000  then
				    nextStep =7001
					local req = UserAction_recordGuideStepReq:New()
			   	    req:setInt_guideStep(nextStep)
				    NetReqLua(req, true) --true标识有等待
					DataManager.setRecordGuideStep({nextStep})
			  end
 
	  elseif 1008 == systemTaskId  then --幕后黑手
	           if  nextStep < 8000  then
				    nextStep = 8001
					local req = UserAction_recordGuideStepReq:New()
			   	    req:setInt_guideStep(nextStep)
				    NetReqLua(req, true) --true标识有等待
					DataManager.setRecordGuideStep({nextStep})
			   end
	 	 
	 elseif  1009 == systemTaskId then  -- 军情 7 处
			   if  nextStep < 9000  then
				    nextStep = 9001
			   end
               --此处可能要处理团长技能。
	  end
	
       local systemConfig = DataManager.getSystemConfig()

	 --以下的内容与等级挂钩。
       if  userData.level == tonumber(systemConfig.explore_open_level)  then   -- 开发探索的等级  10级
	        if nextStep < 10000  then
			   nextStep = 10002
			end
			
			if nextStep-10000  >  #UserGuideUIPanel.guidePos_lv10    then--
			   return nil
			end

			if nextStep >= 10002 then
			   --LayerManager.closeFloatPanel()
			   MainMenuUIPanel_menuMove(true)
			   guide = UserGuideUIPanel.guidePos_lv10[nextStep - 10000]  
			   guide.currentGuid = nextStep 
			else
			 
			 
			end

     elseif  userData.level == tonumber(systemConfig.pk_open_level)  then  --竞技场tonumber(systemConfig.pk_open_level)  12
	        if nextStep < 12000  then
			   nextStep = 12001
			end
			
			if nextStep-12000  >  #UserGuideUIPanel.guidePos_lv12    then--
			   return nil
			end
			if nextStep >= 12001 then
			  -- LayerManager.closeFloatPanel()
			   MainMenuUIPanel_menuMove(true)
			   guide = UserGuideUIPanel.guidePos_lv12[nextStep - 12000]  
			   guide.currentGuid = nextStep 
               DataManager.setRecordGuideStep({nextStep})			   
			end
	 elseif userData.level == tonumber(systemConfig.hero_promote_star_open_level) then --升星	13
            if nextStep < 13000  then
			   nextStep = 13001
			end
			if nextStep-13000  >  #UserGuideUIPanel.guidePos_lv13    then--
			   return nil
			end
			if  nextStep >= 13001 then
				cclog( "462 生活系统" )
			   LayerManager.closeFloatPanel()
			   MainMenuUIPanel_menuMove(true)
			   guide = UserGuideUIPanel.guidePos_lv13[nextStep - 13000]  
			   guide.currentGuid = nextStep 
			   DataManager.setRecordGuideStep({nextStep})
			end
  	 
			
	 elseif  userData.level  ==  tonumber(systemConfig.life_open_level) then --开启生活系统  18 
	        if nextStep < 18000  then
			   nextStep = 18001
			end
			cclog( "475     生活系统" )
			if nextStep-18000  >  #UserGuideUIPanel.guidePos_lv18   then--
			   return nil
			end
			if  nextStep >= 18001 then--
				cclog( "470 生活系统" )
			   LayerManager.closeFloatPanel()
			   MainMenuUIPanel_menuMove(true)
			   guide = UserGuideUIPanel.guidePos_lv18[nextStep - 18000]  
			   guide.currentGuid = nextStep 
			   DataManager.setRecordGuideStep({nextStep})
			end
	 end 
	 return  guide
end

-- 完成了任务 
function UserGuideUIPanel.TaskFinish( taskid , status) 
        cclog( " 393  完成或接受任务  1 表示 接受 任务  。3 表示领取了任务。" .. taskid .. " status ="..status)
        if  2 == status then
		       	if  taskid == 1004  then		    
					cclog("428 保存到服务 ------ ")
				    local req = UserAction_recordGuideStepReq:New()
				    req:setInt_guideStep(5000)
				    NetReqLua(req, true) --true标识有等待                   
				    DataManager.setRecordGuideStep({5000})
					LayerManager.showDialogForGuide(UserGuideUIPanel.guideDialogString[3],nil ) 
		        elseif  taskid == 1006  then  -- 打完 黑铁矮人        
				      	LayerManager.showDialogForGuide(UserGuideUIPanel.guideDialogString[5],nil ) 
				elseif  taskid == 1008  then  -- 打完了 幕后黑手 
						local function fc_nextstep()  -- 这一步没保存。非要我在  取得guide 里面 自己保存 18 步骤	
                             local req = UserAction_recordGuideStepReq:New()
			   	             req:setInt_guideStep(9000)
				             NetReqLua(req, true) --true标识有等待
					         DataManager.setRecordGuideStep({9000})				
		                     UserGuideUIPanel.showGuide(LayerManager.getRootPanel(),false,panelname)
		                end 
				        LayerManager.showDialogForGuide(UserGuideUIPanel.guideDialogString[6],fc_nextstep ) 
				end
		   
        end
end


-- 等级到的时候 通知 
function UserGuideUIPanel.showGuideLevel(panel,isConstraint,panelname,item)
         cclog( "394 UserGuideUIPanel. 升級通知 等级到的时候 通知   " ..item) 
		 LayerManager.closeFloatPanel()
		 local function fc_nextstep()  -- 这一步没保存。非要我在  取得guide 里面 自己保存 18 步骤	   
		       UserGuideUIPanel.showGuide(LayerManager.getRootPanel(),isConstraint,panelname)
		 end 
		 if  UserGuideUIPanel.Dialog_Pack  ==  item  then  -- 彈開背包的有聲對話
		    --Tips(LabelChineseStr.MainMenuUIPanel_1)				 
		    LayerManager.showDialogForGuide(UserGuideUIPanel.guideDialogString[2],fc_nextstep ) 
		 end
		 if  UserGuideUIPanel.Dialog_TZ == item then --开启了团长技能
		     LayerManager.showDialogForGuide(UserGuideUIPanel.guideDialogString[6],fc_nextstep ) 
		 end
		 if  UserGuideUIPanel.Dialog_TS == item then -- 开启探索功能 10级
		     cclog( "531 开发探索 " )
		     LayerManager.showDialogForGuide(UserGuideUIPanel.guideDialogString[7],fc_nextstep ) 
		 end
		 if  UserGuideUIPanel.Dialog_JJC == item then -- 开发竞技场 12级
	        cclog( "535  开发竞技场" )
		     LayerManager.showDialogForGuide(UserGuideUIPanel.guideDialogString[8],fc_nextstep ) 
		 end
		 if  UserGuideUIPanel.Dialog_SH == item then -- 生活系统  18级
		     cclog( "539  打开了生活 " )
		     UserGuideUIPanel.showGuide(LayerManager.getRootPanel(),isConstraint,panelname)
		 end
	     if  UserGuideUIPanel.Dialog_SX == item then -- 升星系统  13级
		     cclog( "539  打开了 升星系统 " )
		     UserGuideUIPanel.showGuide(LayerManager.getRootPanel(),isConstraint,panelname)
		 end
end


--步骤被触发 。
function UserGuideUIPanel.stepClick( itemname )

     if  hand~=nil then--
	     hand:removeFromParent(true)
		 hand = nil
	 end
	 
	 if pClip~= nil then--
	 	pClip:removeFromParent(true)
		pClip = nil
	 end
	 if nil == guide  then--
	    return 
	 end
	 -- 非常特别的处理。应为UserGuideUIPanel.guidePos_lv12 有 三个特别处理的步骤
	 
	 if  guide.currentGuid ==12003 or guide.currentGuid ==12004 or guide.currentGuid ==12005  then
	     guide.name ="Image_item_guide" 
	 end

	 if itemname == guide.name  then--
		if guide.save then  --有的步骤需要保存到服务器，有的不需要保存到服务器的。
			cclog("428 保存到服务 ------ ")
			local req = UserAction_recordGuideStepReq:New()
			req:setInt_guideStep(guide.currentGuid)
			NetReqLua(req, true) --true标识有等待
		else
			cclog("433 不保存到服务器------ ")
		end
	 	DataManager.setRecordGuideStep({guide.currentGuid})
	    if guide.dialog then  -- 有一个对话框
           cclog("562   弹出对话框内容   guide.dialog ")
		    local function nextStep()
			         cclog("564 弹出对话框之后 要  nextStep ")
					 cclogtab(guide)
			   	    if guide and guide.nextPos then
				        local nextPanel
				        if guide.footPanel then
					       nextPanel = LayerManager.getRootPanel()
				        else 
					       nextPanel = current_panel
				        end
				        UserGuideUIPanel.showGuide(nextPanel,isConstraint)
					end
			end
			LayerManager.showDialogForGuide(UserGuideUIPanel.guideDialogString[guide.dialog],nextStep ) 

	    else
			if guide.nextPos then
			    cclog("580  要 guide.nextPos ")
				local nextPanel
				if guide.footPanel then
					nextPanel = LayerManager.getRootPanel()
				else 
					nextPanel = current_panel
				end
				UserGuideUIPanel.showGuide(nextPanel,isConstraint)
			end
		
		end

	 end 

end

function UserGuideUIPanel.showGuide(panel,isConstraint,panelname)
	if not Config.isOpenUserGuide then
		return
	end	
	current_panel = panel
	if  current_panel == nil  then
	    return 
	end
	local  recordGuideStep = DataManager.getRecordGuideStep() 
	local  guideCurStep = 0
	if  #recordGuideStep <=0  then  --默认是没有步骤。
	     guideCurStep = 1000 --默认从编号1000 开始
	else
	     guideCurStep  = recordGuideStep[#recordGuideStep] 
	end

	--得到当前的步骤详细
	guide = getGuidTask(guideCurStep,panelname) 

	if guide == nil  then
		return
	end
	
	local sprite = current_panel:getChildByName(guide.name)
	if sprite == nil then
		return 
	end
	
    local size = sprite:getContentSize()
	local offset = sprite:convertToWorldSpace(cc.p(0,0))
	local tx = offset.x+size.width/2
	local ty = offset.y+size.height/2
	
	local path = "NewUi/xinqietu/"..guide.pic
	local rootLayer = LayerManager.getRootLayer()
	
	--创建手的动画
	hand = cc.Sprite:create("common/hand.png")
	hand:setPosition(tx+guide.px_Offset,ty+guide.py_Offset)
	hand:setScale(0.3)
	
	local arr1 = {}
	arr1[1] = cc.ScaleBy:create(0.3,1.2)
	arr1[2] = arr1[1]:reverse()
	arr1[3] = cc.ScaleBy:create(0.1,1.1)
	arr1[4] = arr1[3]:reverse()
	local sq1 = cc.Sequence:create(arr1)
	hand:runAction(cc.RepeatForever:create(sq1))

    --强制指引的内容。
	local sp = cc.Sprite:create(path)
	local node = cc.Node:create()
	node:setPosition(tx,ty)
	node:addChild(sp,10,1000)
	
	pClip = cc.ClippingNode:create()
	pClip:setStencil(node)
	pClip:setInverted(true)
	pClip:setAlphaThreshold(0)
	rootLayer:addChild(pClip,10)
	if guide.non_compulsory == true then  --非強制
		 --加入手动画
		rootLayer:addChild(hand,11)
	else
		local bgLayer = cc.LayerColor:create(cc.c4b(0,0,0,180))
        pClip:addChild(bgLayer,1)
		--加入手动画
	    bgLayer:addChild(hand,11)
	end

	local continuous = false
	local listenner = cc.EventListenerTouchOneByOne:create()
	listenner:setSwallowTouches(true)
	listenner:registerScriptHandler(function(touch, event)
		--如果非强制引导则退出当前
		local sprite = node:getChildByTag(1000)
		local rc = sprite:getBoundingBox()
		local pt = node:convertToNodeSpace(touch:getLocation())		
		if cc.rectContainsPoint(rc,pt) then
			--发送完成任务步骤号
			return false
		else
			if guide.non_compulsory == true then  --非強制
			    if  hand~=nil then--
					hand:removeFromParent(true)
					hand = nil
				end
				if pClip~= nil then--
					pClip:removeFromParent(true)
					pClip = nil
				end
			   return false
			else
				return true
			end
			
	    end	
	end,cc.Handler.EVENT_TOUCH_BEGAN )

    local eventDispatcher = pClip:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listenner, pClip)
end