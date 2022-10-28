local gameList = { "Carcassone", "Chess", "MrJackPocket", "Stratego" };

-- Chech Arg[1]
if not arg[1] then
	print("\nUSE $: lua init.lua <gameNumber>\n")
	for i,v in ipairs(gameList) do print(i..") "..v) end
	print(" ");
	return
end

local gameNumber = assert( tonumber(arg[1]), "Couldn't read gameNumber." );
assert(gameNumber>=1 and gameNumber<=#gameList, "game "..gameNumber.." not exist.");
local gameName = gameList[gameNumber];

-- START SERVER
local Server = require "wsServer";
local Board = require "board";

math.randomseed( os.time() );

-- Player Join
Server:addEvent("open", function(clientID)
	Board:newPlayer(clientID);

	local D = { pjs={}; cards=Board.cards; turn=Board.turns.c; }
	for k,p in pairs(Board.pjs) do table.insert(D.pjs,{id=k,turn=p.turn}) end
	Server:sendAll({name="gameStatus", data=D});
	Server:send(clientID,{name="setMyID", data=clientID});
end)

-- Player Leave
Server:addEvent("close", function(clientID)
	Board:rmvPlayer(clientID);
	
	Server:sendAll({name="playerDC", data={id=clientID,turn=Board.turns.c}})
end)

-- Player Name
Server:addEvent("setName", function(clientID,data)
	Board.pjs[clientID].name = data;

	local D = {};
	for k,p in pairs(Board.pjs) do table.insert(D,{id=k,name=p.name}) end
	Server:sendAll({name="setNames", data=D});
end)

-- Player Mouse Position :: {x=0,y=0}
Server:addEvent("mousePos", function(clientID,data)
	Board:updateMousePos(clientID,data);

	local pjMouse = Board.pjs[clientID].mouse
	Server:sendAll({ name="updateMousePos"; data={x=pjMouse.x,y=pjMouse.y,id=clientID} })
end)

-- Player do action :: 1,2...
Server:addEvent("action", function(clientID,data) Board.actions[data](Board,clientID,Server); end)

-- Next turn
Server:addEvent("nextTurn", function(clientID)
	if Board:nextTurn(clientID) then Server:sendAll({name="setTurn", data=Board.turns.c}) end
end)


Board:init(gameName);
Server:init(gameName); 