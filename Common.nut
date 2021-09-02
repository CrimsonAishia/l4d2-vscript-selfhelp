::GetObjectUniqueID <- function(object) {
	local classname = object.GetClassname();
	if(classname == "player" && object.IsPlayerEntityValid()) return GetPlayerUniqueID(object);
	return object.GetIndex();
}

::GetPlayerUniqueID <- function(player) {
	if(player.IsPlayerEntityValid()) {
		if(player.GetUniqueID() == "BOT") {
			return player.GetIndex();
		}
		return player.GetUniqueID();
	}
}

::FindEntityByUniqueID <- function(UniqueID) {
	foreach(object in Objects.All()) {
			if(object.GetClassname() == "player") {
				if(object.GetUniqueID() == UniqueID || object.GetIndex() == UniqueID) {
					if(object.IsPlayerEntityValid()) return object;
					return null;
				}
			} else if(object.GetIndex() == UniqueID) return object;
	}
	return null;
}

// 判断玩家是否倒地
function VSLib::Player::IsPlayerGrapEdge() {
	if (!IsPlayerEntityValid())
	{
		printl("VSLib Warning: Player " + _idx + " is invalid.");
		return;
	}

	return GetNetPropInt( "m_isHangingFromLedge" );
}

::OtherError <- function(msg) {
	Msg("\n---------------------------------------------------------------------\n");
	Msg("Error：" + msg);
	Msg("\n---------------------------------------------------------------------\n");
	return -1;
}