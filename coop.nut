IncludeScript("VSLib");
IncludeScript("Common");

/**
 * 随机颜色
 */
::RandomColor <- function()
{
	local Color = Utils.GetRandNumber(50,255) + " " + Utils.GetRandNumber(50,255) + " " + Utils.GetRandNumber(50,255);
	return Color;
}

/**
 * 创建或者修改hint
 */
function VSLib::Player::CreateOrEditHint(hint, text, duration = 5, icon = "icon_tip", color = "255 255 255", pulsating = 0, alphapulse = 0, shaking = 0 )
{
	if (!IsPlayerEntityValid())
	{
		printl("VSLib Warning: Player " + _idx + " is invalid.");
		return;
	}

    if(hint && hint.IsEntityValid()) {
        hint.SetKeyValue("hint_caption", text.tostring());
	    hint.Input("ShowHint", "", 0, this);
    } else {
        duration = duration.tofloat();
        
        local hinttbl =
        {
            hint_allow_nodraw_target = "1",
            hint_alphaoption = alphapulse,
            hint_auto_start = "0",
            hint_binding = "",
            hint_caption = text.tostring(),
            hint_color = color,
            hint_forcecaption = "0",
            hint_icon_offscreen = icon,
            hint_icon_offset = "0",
            hint_icon_onscreen = icon,
            hint_instance_type = "2",
            hint_nooffscreen = "0",
            hint_pulseoption = pulsating,
            hint_range = "0",
            hint_shakeoption = shaking,
            hint_static = "1",
            hint_target = "",
            hint_timeout = duration,
            targetname = "vslib_tmp_" + UniqueString(),
        };
        
        hint = ::VSLib.Utils.CreateEntity("env_instructor_hint", Vector(0, 0, 0), QAngle(0, 0, 0), hinttbl);
        
        hint.Input("ShowHint", "", 0, this);
        
        if ( duration > 0 ) hint.Input("Kill", "", duration);
    }

    return hint;
}

::SelfHelpList <- {};
::SelfHelpDrugTime <- 3;
::SelfHelpOtherTime <- 5;

//无行动能力检测
function Notifications::OnIncapacitated::SelfHelp_Incapacitated(victim,attacker,params)
{
    if(!victim || !victim.IsEntityValid()) return;
	if(victim.IsPlayerEntityValid() && victim.GetTeam() == SURVIVORS) {
		SelfHelpAddList(victim);
	}
}

//悬挂检测
function Notifications::OnGrabbedLedge::SelfHelp_GrabbedLedge(causer, victim, params)
{
    if(!victim || !victim.IsEntityValid()) return;
	if(victim.IsPlayerEntityValid() && victim.GetTeam() == SURVIVORS) {
		SelfHelpAddList(victim);
	}
}

// 长舌抓人
function EasyLogic::Notifications::OnSmokerTongueGrab::SelfHelp_SmokerTongueGrab(entity, victim, params)
{
	if(!entity || !victim || !entity.IsEntityValid() || !victim.IsEntityValid()) return;
	if(victim.IsPlayerEntityValid() && victim.GetTeam() == SURVIVORS) {
		SelfHelpAddList(victim);
		SelfHelpSetAttacker(victim,entity);
	}
}

// 长舌放人
function EasyLogic::Notifications::OnSmokerTongueReleased::SelfHelp_SmokerTongueReleased(entity, victim, params)
{
	if(!entity || !victim || !entity.IsEntityValid() || !victim.IsEntityValid()) return;
	if(victim.IsPlayerEntityValid() && victim.GetTeam() == SURVIVORS && entity.IsEntityValid()) {
		if(GetObjectUniqueID(victim) in SelfHelpList && entity.GetIndex() == SelfHelpList[GetObjectUniqueID(victim)].attacker.GetIndex()) {
			SelfHelpSetAttacker(victim,null);
		}
	}
}

// 小偷扑人
function EasyLogic::Notifications::OnHunterPouncedVictim::SelfHelp_HunterPouncedVictim(entity, victim, params)
{
	if(!entity || !victim || !entity.IsEntityValid() || !victim.IsEntityValid()) return;
	if(victim.IsPlayerEntityValid() && victim.GetTeam() == SURVIVORS) {
		SelfHelpAddList(victim);
		SelfHelpSetAttacker(victim,entity);
	}
}

// 小偷放人
function EasyLogic::Notifications::OnHunterReleasedVictim::SelfHelp_HunterReleasedVictim(entity, victim, params)
{
	if(!entity || !victim || !entity.IsEntityValid() || !victim.IsEntityValid()) return;
	if(victim.IsPlayerEntityValid() && victim.GetTeam() == SURVIVORS && entity.IsEntityValid()) {
		if(GetObjectUniqueID(victim) in SelfHelpList && entity.GetIndex() == SelfHelpList[GetObjectUniqueID(victim)].attacker.GetIndex()) {
			SelfHelpSetAttacker(victim,null);
		}
	}
}

// 猴子骑人
function EasyLogic::Notifications::OnJockeyRideStart::SelfHelp_JockeyRideStart(entity, victim, params)
{
	if(!entity || !victim || !entity.IsEntityValid() || !victim.IsEntityValid()) return;
	if(victim.IsPlayerEntityValid() && victim.GetTeam() == SURVIVORS) {
		SelfHelpAddList(victim);
		SelfHelpSetAttacker(victim,entity);
	}
}

// 猴子放人
function EasyLogic::Notifications::OnJockeyRideEnd::SelfHelp_JockeyRideEnd(entity, victim, params)
{
	if(!entity || !victim || !entity.IsEntityValid() || !victim.IsEntityValid()) return;
	if(victim.IsPlayerEntityValid() && victim.GetTeam() == SURVIVORS && entity.IsEntityValid()) {
		if(GetObjectUniqueID(victim) in SelfHelpList && entity.GetIndex() == SelfHelpList[GetObjectUniqueID(victim)].attacker.GetIndex()) {
			SelfHelpSetAttacker(victim,null);
		}
	}
}

// 牛冲人
function EasyLogic::Notifications::OnChargerPummelBegin::SelfHelp_ChargerPummelBegin(entity, victim, params)
{
	if(!entity || !victim || !entity.IsEntityValid() || !victim.IsEntityValid()) return;
	if(victim.IsPlayerEntityValid() && victim.GetTeam() == SURVIVORS) {
		SelfHelpAddList(victim);
		SelfHelpSetAttacker(victim,entity);
	}
}

// 牛放人
function EasyLogic::Notifications::OnChargerPummelEnd::SelfHelp_ChargerPummelEnd(entity, victim, params)
{
	if(!entity || !victim || !entity.IsEntityValid() || !victim.IsEntityValid()) return;
	if(victim.IsPlayerEntityValid() && victim.GetTeam() == SURVIVORS && entity.IsEntityValid()) {
		if(GetObjectUniqueID(victim) in SelfHelpList && entity.GetIndex() == SelfHelpList[GetObjectUniqueID(victim)].attacker.GetIndex()) {
			SelfHelpSetAttacker(victim,null);
		}
	}
}

::SelfHelpAddList <- function(player) {
	if(!SelfHelpList) return OtherError("SelfHelpAddList function SelfHelpList is not exist");
	local uniqueID = GetObjectUniqueID(player);
	if(!(uniqueID in SelfHelpList)) {
		SelfHelpList[uniqueID] <- {
			time = 0
			hint = null
			helpOtherTime = 0
			helpOther = null
			helpOtherHint = null
			attacker = null
		}
        player.CreateOrEditHint(null,"按 [CTRL]蹲 键可以进行用医疗物资自救，如果没有则可以两位靠近倒地的人员进行互救！", 10, "icon_alert", RandomColor());
		Timers.AddTimerByName("SelfHelp" + uniqueID,0.1,true,SelfHelpTFunc,uniqueID);
	}
}

::SelfHelpSetAttacker <- function(player,attacker)
{
	if(!SelfHelpList) return OtherError("SelfHelpSetAttacker function SelfHelpList is not exist");
	SelfHelpList[GetObjectUniqueID(player)].attacker = attacker;
}

::SelfHelpRemoveList <- function(uniqueID) {
	if(uniqueID in SelfHelpList) {
		ResetSelfHelpAllHintAndTime(SelfHelpList[uniqueID]);
		delete SelfHelpList[uniqueID];
		Timers.RemoveTimerByName("SelfHelp" + uniqueID);
	}
}

::SelfHelpTFunc <- function(unique) {
	local player = FindEntityByUniqueID(unique);
	if(player && player.IsPlayerEntityValid()) {
		local params = SelfHelpList[unique];
		if(!player.IsIncapacitated() && !player.IsPlayerGrapEdge() && params.attacker == null) {
			return SelfHelpRemoveList(unique);
		}
		if(player.IsPressingDuck()) {
			local item = player.GetHeldItems();
			local Drugs = 0;
			if("slot4" in item) Drugs++;
			if("slot3" in item && item.slot3.GetClassname() == "weapon_first_aid_kit") Drugs++;

			// 药品自救
			if(Drugs > 0) {
				params.time += 0.1;
				if(params.time >= SelfHelpDrugTime) {
					RemovePlayerItem(player);
				} else {
					local ChargeBar = SelfHelpHintFormat(params.time, SelfHelpDrugTime);
                    params.hint = player.CreateOrEditHint(params.hint, "药品自救：" + ChargeBar, 0, "icon_alert", RandomColor());
				}
			}
			local e = player.GetPosition();

			// 没有医疗物资
			if(Drugs <= 0) {
				local findPlayer = false;
				// 判断帮助的玩家是否超出距离或者不是倒地人员
				if(params.helpOther != null) {
					if(!params.helpOther || !params.helpOther.IsPlayerEntityValid() || !params.helpOther.IsIncapacitated() || Utils.GetDistBetweenEntities(params.helpOther,player) > 30) {
						params.helpOther = null;
						ResetSelfHelpAllHintAndTime(params);
					} else {
						findPlayer = true;
					}
				}
				// 寻找在附近的玩家
				if(params.helpOther == null) {
					foreach(p in EasyLogic.Players.IncapacitatedSurvivors()) {
						if(p && p.IsEntityValid() && Player(p) && Player(p).IsPlayerEntityValid() && p.GetIndex() != player.GetIndex() && Utils.GetDistBetweenEntities(p,player) <= 30) {
							params.helpOther = p;
							findPlayer = true;
							break;
						}
					}
				}

				// 找到玩家则互救
				if(findPlayer) {
					params.helpOtherTime += 0.1;

					local ChargeBar = SelfHelpHintFormat(params.helpOtherTime, SelfHelpOtherTime);

                    params.hint = player.CreateOrEditHint(params.hint, "你正在帮助 " + params.helpOther.GetName() + " 起来：" + ChargeBar, 0, "icon_alert", RandomColor());

                    params.helpOtherHint = params.helpOther.CreateOrEditHint(params.helpOtherHint, "<提示> " + player.GetName() + " 正在帮助你起来[" + (params.helpOtherTime / SelfHelpOtherTime * 100).tointeger() + "]!", 0, "icon_alert", RandomColor());

					if(params.helpOtherTime >= SelfHelpOtherTime) {
						local reviveCount = params.helpOther.GetReviveCount();
						ReviveClientWithPills(params.helpOther,2,28);
						params.helpOther.SetReviveCount(reviveCount + 1);

                        params.helpOther.CreateOrEditHint(null, player.GetName() + " 蓄力一脚把你踹了起来！ ", 4);
                        player.CreateOrEditHint(null, "你蓄力一脚把 " + params.helpOther.GetName() + " 起来了！ ", 4);

						// 清空救助成功玩家相关数据
						params.helpOther = null;
						ResetSelfHelpAllHintAndTime(params);
					}
				// 否则寻找附近是否有药品
				} else {
					foreach(radiusItem in EasyLogic.Objects.AroundRadius(e,35)) {
						if(radiusItem && radiusItem.IsEntityValid() && radiusItem.GetClassname() == "weapon_pain_pills" || radiusItem.GetClassname() == "weapon_adrenaline" || radiusItem.GetClassname() == "weapon_first_aid_kit") {
							// 止痛药 肾上腺素
							if(!item.rawin("slot4") && radiusItem.GetClassname() == "weapon_pain_pills" || radiusItem.GetClassname() == "weapon_adrenaline") {
								local ok = true;
								foreach(alivePlayer in EasyLogic.Players.AliveSurvivors()) {
									if(alivePlayer && alivePlayer.IsPlayerEntityValid()) {
										local pItem = alivePlayer.GetHeldItems();
										if(pItem.rawin("slot4") && radiusItem.GetIndex() == pItem.slot4.GetIndex()) {
											ok = false;
											break;
										}
									}
								}
								if(!ok) continue;
								player.Give(radiusItem.GetClassname() == "weapon_pain_pills" ? "pain_pills" : "adrenaline");
								radiusItem.Kill();
								return;
							}

							// 医疗包
							if(!item.rawin("slot3") && radiusItem.GetClassname() == "weapon_first_aid_kit") {
								local ok = true;
								foreach(alivePlayer in EasyLogic.Players.AliveSurvivors()) {
									if(alivePlayer && alivePlayer.IsPlayerEntityValid()) {
										local pItem = alivePlayer.GetHeldItems();
										if(pItem.rawin("slot3") && radiusItem.GetIndex() == pItem.slot3.GetIndex()) {
											ok = false;
											break;
										}
									}
								}
								if(!ok) continue;
								player.Give("first_aid_kit");
								radiusItem.Kill();
								return;
							}
						}
					}
				}
			}
		} else {
			ResetSelfHelpAllHintAndTime(params);
		}
	}
}

::SelfHelpHintFormat <- function(time, max) {
	local Current = time / max * 100;

	local ChargeBar = "[";
	for(local i = 0; i <= 100; i+=5) {
		if(Current >= i) ChargeBar += "|";
		else ChargeBar += " ";
	}
	ChargeBar += "]" + Current.tostring().tointeger();

	return ChargeBar;
}

::ReviveClientWithPills <- function(player,health,buffer) {
	local uniqueID = GetObjectUniqueID(player);
	if(SelfHelpList.rawin(uniqueID) && SelfHelpList[uniqueID].attacker != null) SelfHelpList[uniqueID].attacker.Kill();

	player.Give("health");
	player.SetRawHealth(health);
	player.SetHealthBuffer(buffer);
}

::RemovePlayerItem <- function(player) {
	local item = player.GetHeldItems();
	if("slot4" in item) {
        player.CreateOrEditHint(null, "自救成功(消耗了" + EntityAndPropByName(item.slot4) + ")");
		player.DropWeaponSlot(4);

		local reviveNum = player.GetReviveCount();
		ReviveClientWithPills(player,10,30);
		player.SetReviveCount(reviveNum);
	} else if("slot3" in item && item.slot3.GetClassname() == "weapon_first_aid_kit") {
        player.CreateOrEditHint(null, "自救成功(消耗了" + EntityAndPropByName(item.slot3) + ")");
		player.DropWeaponSlot(3);

		local reviveNum = player.GetReviveCount();
		ReviveClientWithPills(player,40,30);
		player.SetReviveCount(reviveNum);
	}
}

::ResetSelfHelpAllHintAndTime <- function(params) {
	params.time = 0;
	params.helpOtherTime = 0;
	if(params.hint != null) {
		params.hint.Input("Kill", "", 0);
		params.hint = null;
	}
	if(params.helpOtherHint != null) {
		params.helpOtherHint.Input("Kill", "", 0);
		params.helpOtherHint = null;
	}
}