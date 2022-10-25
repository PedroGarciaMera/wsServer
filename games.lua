local function newCard(X,Y,W,H,Rot,frontI,backI,SIDE,Owner,Color,CanHand,Tiled)
	return {
		x=X; y=Y;
		w=W; w_2=W/2;
		h=H; h_2=H/2;
		rot=Rot;
		I={front=frontI,back=backI};
		side=SIDE or "front";
		owner=Owner;
		color=Color;
		canHand=CanHand;
		tiled=Tiled;
		onBoard=true;
		invi=false;
	}
end

local function newBox(X,Y,W,H,Type,Random)
	return { cardsI={}; x=X; y=Y; w=W; w_2=W/2; h=H; h_2=H/2; type=Type; rand=Random; }
end


local G = {
	sel="MrJackPocket";
	list = {
		"Jaipur"; "Hive"; "TidesOfTime"; "Pinguinos"; "Tsuro"; "Catan"; "Takenoko"; "Rummikub";
		"Carcassone"; "Chess"; "MrJackPocket";
	};
	inits = {};
}

G.inits["Carcassone"] = function(B)
	-- Settings
	B.allowRots = 4; B.isTiled = 100;
	B.nPlayers = 5; for i=1,B.nPlayers do table.insert(B.turns.free,i) end;

	local W,H = B.isTiled,B.isTiled;
	---- Boxs
	local BoxX, BoxY = W*10, H*2;
	table.insert(B.boxs,newBox(BoxX, BoxY, W, H, {"back",1}, true))
	---- Cards
	-- Points BOARD
	table.insert(B.cards,newCard(0,w_h,480,330,false,1,false,"front",-1));
	-- Tile Cards
	local nCs={ 4,2,1,3,1,1,2,3,2,3,2,1,2,2,3,3,2,3,3,3,3,4,4,3,3,3,2,2,1 };
	for i,v in ipairs(nCs) do
		for j=1,v do
			table.insert(B.cards,newCard(BoxX,BoxY,W,H,1,i+1,1,"back",false,false,true,true))
		end
	end
	table.insert(B.cards,newCard(W*5,0,W,H,1,22,1,"front",false,false,true,true));
	-- table.insert(B.cards,newCard(100,100,W,H,1,21,1,"front",false,false,true,true));
	-- Mapples
	local mW,mH = W*0.4,H*0.4; local nMapples = 8;
	for i=1,B.nPlayers do
		for j=1,nMapples do
			table.insert(B.cards,newCard(W*8+j*mW,w_h_2+mH*i,mW,mH,1,30+i,false,"front",i))
		end
	end



	print("Carcassone Board Server Ready")
end

G.inits["Chess"] = function(B)
	B.isTiled = 70;
	B.nPlayers = 2; for i=1,B.nPlayers do table.insert(B.turns.free,i) end;

	local bSize = B.isTiled*8; local bY = B.isTiled*4.5; local bX = B.isTiled*8.5
	-- Board
	table.insert(B.cards,newCard(bX,bY,bSize,bSize,false,1,false,"front",-1));
	-- Piezes
	local pSize = 50;
	---- Pawns
	for i=1,8 do
		table.insert(B.cards,newCard(B.isTiled*(i+4),B.isTiled*2,pSize,pSize,false,2,false,"front",false,false,false,true));
	end
	for i=1,8 do
		table.insert(B.cards,newCard(B.isTiled*(i+4),B.isTiled*7,pSize,pSize,false,8,false,"front",false,false,false,true));
	end
	---- Knight
	table.insert(B.cards,newCard(B.isTiled*6,B.isTiled*1,pSize,pSize,false,3,false,"front",false,false,false,true));
	table.insert(B.cards,newCard(B.isTiled*11,B.isTiled*1,pSize,pSize,false,3,false,"front",false,false,false,true));
	table.insert(B.cards,newCard(B.isTiled*6,B.isTiled*8,pSize,pSize,false,9,false,"front",false,false,false,true));
	table.insert(B.cards,newCard(B.isTiled*11,B.isTiled*8,pSize,pSize,false,9,false,"front",false,false,false,true));
	---- Bioshop
	table.insert(B.cards,newCard(B.isTiled*7,B.isTiled*1,pSize,pSize,false,4,false,"front",false,false,false,true));
	table.insert(B.cards,newCard(B.isTiled*10,B.isTiled*1,pSize,pSize,false,4,false,"front",false,false,false,true));
	table.insert(B.cards,newCard(B.isTiled*7,B.isTiled*8,pSize,pSize,false,10,false,"front",false,false,false,true));
	table.insert(B.cards,newCard(B.isTiled*10,B.isTiled*8,pSize,pSize,false,10,false,"front",false,false,false,true));
	---- Rock
	table.insert(B.cards,newCard(B.isTiled*5,B.isTiled*1,pSize,pSize,false,5,false,"front",false,false,false,true));
	table.insert(B.cards,newCard(B.isTiled*12,B.isTiled*1,pSize,pSize,false,5,false,"front",false,false,false,true));
	table.insert(B.cards,newCard(B.isTiled*5,B.isTiled*8,pSize,pSize,false,11,false,"front",false,false,false,true));
	table.insert(B.cards,newCard(B.isTiled*12,B.isTiled*8,pSize,pSize,false,11,false,"front",false,false,false,true));
	---- Queen & King
	table.insert(B.cards,newCard(B.isTiled*8,B.isTiled*1,pSize,pSize,false,6,false,"front",false,false,false,true));
	table.insert(B.cards,newCard(B.isTiled*9,B.isTiled*1,pSize,pSize,false,7,false,"front",false,false,false,true));
	table.insert(B.cards,newCard(B.isTiled*8,B.isTiled*8,pSize,pSize,false,12,false,"front",false,false,false,true));
	table.insert(B.cards,newCard(B.isTiled*9,B.isTiled*8,pSize,pSize,false,13,false,"front",false,false,false,true));



	print("Chess Board Server Ready")
end

G.inits["MrJackPocket"] = function(B)
	-- Settings
	B.allowRots = 4; B.allowInvi = true;
	B.nPlayers = 2; for i=1,B.nPlayers do table.insert(B.turns.free,i) end;

	local W,H,X,Y,cardN,rDeck
	-- City
	local back; rDeck = {10,11,12,13,14,15,16,17,18};
	W = 200; H = 200; Y = 250;
	for r=1,3 do
		X = 600;
		for c=1,3 do
			cardN = table.remove(rDeck,math.random(#rDeck));
			back=2; if cardN==14 then back=3 end
			table.insert(B.cards,newCard(X,Y,W,H,math.random(4),cardN,back,"front"));
			X = X + 200;
		end
		Y = Y + 200;
	end
	-- SUS PEOPLE
	W = 100; H = 200; rDeck = {1,2,3,4,5,6,7,8,9};
	for i=1,9 do
		cardN = table.remove(rDeck,math.random(#rDeck));
		table.insert(B.cards,newCard(1400,450,W,H,false,cardN,1,"back"));
	end
	-- POLICE
	W = 50; H = 50;
	table.insert(B.cards,newCard(450,250,W,H,false,27));
	table.insert(B.cards,newCard(800,800,W,H,false,28));
	table.insert(B.cards,newCard(1150,250,W,H,false,29));
	-- TURNS
	W = 50; H = 50;
	for i=1,8 do
		table.insert(B.cards,newCard(150,225+(50*i),W,H,false,18+i));
	end
	-- ACTIONS
	W = 50; H = 50;
	Y = 275;
	for r=1,4 do
		X = 200;
		for c=0,6,2 do
			cardN = math.random(); if cardN<=0.5 then cardN=0 else cardN=1 end
			table.insert(B.cards,newCard(X,Y,W,H,false,cardN+30+c,4+c,"back"));
			if cardN==0 then cardN=1 else cardN=0 end
			table.insert(B.cards,newCard(X,Y+50,W,H,false,cardN+30+c,4+c,"back"));
			X = X + 50;
		end
		Y = Y + 100;
	end


	print("MrJackPocket Board Server Ready")
end


return G


--[[
_Game = "MrJackPocket"
_Games = { "Jaipur"; "Hive"; "TidesOfTime"; "Pinguinos"; "Tsuro"; "Catan"; "Takenoko"; "Rummikub"; "MrJackPocket" }

_GamesInit = {}

_GamesInit["Jaipur"] = function()
  _canRot = false
  _turn = {ing=math.random(1,2);t=false}
  _gameNPJ = 2
  _CHandI = {side="back";I=1}

	-- CARDS
	local W,H = 200,300
	local NCs = { {20,6}; {21,6}; {22,6}; {23,8}; {24,8}; {25,10}; {26,8}; }
	local Deck={};
	for i,v in ipairs(NCs) do
		for j=1,v[2] do table.insert(Deck,v[1]) end
	end
	local CardN
	local DeckPos = {-W*4,0}; local Camel={ x=0; y={-H*2,H*2} }

	--- Market and Hands
	for i=0,2 do newCard(-W*2+W*i,0,W,H,1,26,1,"front",false,false,true) end
	for i=1,2 do
		for j=1,5 do
			CardN = table.remove(Deck,math.random(1,#Deck))
			newCard(Camel.x,Camel.y[i],W,H,1,CardN,1,"back",false,false,true)
		end
	end
	for i=1,2 do
		CardN = table.remove(Deck,math.random(1,#Deck))
		newCard(W*i,0,W,H,1,CardN,1,"front",false,false,true)
	end

	--- Rest, Deck
	for i=1,#Deck do
		CardN = table.remove(Deck,math.random(1,#Deck))
		newCard(DeckPos[1],DeckPos[2],W,H,1,CardN,1,"back",false,false,true)
	end

	-- COINS
	local Wf,Hf = 140,140
	local Mats = {}; for i=1,17 do table.insert(Mats,i) end
	local MposY = {1,1,2,2,3,3,3,3,4,4,4,4,5,6,6,6,6}
	local Nms = {2,3,2,3,1,2,2,2,1,2,2,2,5,1,1,1,6}
	for i=#Mats,1,-1 do
		for j=1,Nms[i] do
			newCard(-W*5,-Hf*2.5+Hf*(MposY[i]-1),Wf,Hf,1,Mats[i],false,"front")
		end
	end

	local othersBI = { {false}; {8,8,9,10,10}; {5,5,6,6,7,7}; {2,2,3,3,3,4,4}; }
	local othersFI = {18,27,28,29}
	for i,bITable in ipairs(othersBI) do
		for j=1,#bITable do
			CardN = table.remove(bITable,math.random(1,#bITable))
			newCard(-W*5-Wf,-Hf*1.5+Hf*(i-1),Wf,Hf,1,othersFI[i],CardN,"front")
		end
	end

	-- Boxs
	newBox(DeckPos[1],DeckPos[2],W,H,{"back",1})
	newBox(-DeckPos[1],DeckPos[2],W,H,{"back",1})
	newBox(Camel.x,Camel.y[1],W,H,{"front",26}); newBox(Camel.x,Camel.y[2],W,H,{"front",26});
  -- for i=1,6 do
  --   newBox(-W*5,-Hf*2.5+Hf*(i-1),Wf,Hf,{"back",i})
  --   newBox(-Wf*2.5+Wf*(i-1),-H,Wf,Hf,{"back",i})
  --   newBox(-Wf*2.5+Wf*(i-1),H,Wf,Hf,{"back",i})
  -- end
  for i=2,4 do
    newBox(-W*5-Wf,-Hf*1.5+Hf*(i-1),Wf,Hf,{"front",25+i})
  end
	initBoxs()

  -- Tiles (MARKET)
  for i=0,4 do newTile(-W*2+W*i,0,W,H) end

	print("Jaipur Board Ready")
end

_GamesInit["Hive"] = function()

  _canRot = false
  _turn = {ing=1;t=45}
  _gameNPJ = 2
  _CHandI = false

	-- Hive BOARD
	local HSize = 200
	local xPos = {-HSize*11,HSize*7}
	local Hive = {
		{n=1,Ipos=8}; --bee
		{n=2,Ipos=10}; --spider
		{n=2,Ipos=2}; --beetle
		{n=3,Ipos=4}; --grasshopper
		{n=3,Ipos=0}; --ant
		{n=1,Ipos=6}; --mosquito
		{n=1,Ipos=12}; --ladybug
		{n=1,Ipos=14}; --pillbug
	}
	local Y = (HSize*#Hive)/-2
	for i,v in ipairs(Hive) do v.y=Y; Y=Y+HSize end
	for i=1,2 do
		for _,v in ipairs(Hive) do
			for j=1,v.n do
				newCard(HSize*j+xPos[i],v.y,HSize,HSize,1,v.Ipos+i,false,"front")
			end
		end
	end

	-- Tiles
  local TileH = HSize*0.8
	local X = {-HSize*7,-HSize*6.5}
	local Y = {-TileH*7,-TileH*6}
	for r=1,8 do
		for c=0,14 do newTile(X[1]+HSize*c,Y[1],HSize,HSize) end
		Y[1]=Y[1]+TileH*2
	end
	for r=1,7 do
		for c=0,13 do newTile(X[2]+HSize*c,Y[2],HSize,HSize) end
		Y[2]=Y[2]+TileH*2
	end

	print("Hive Board Server Ready")
end

_GamesInit["TidesOfTime"] = function()

  _canRot = false
  _turn = {ing=false;t=false}
  _gameNPJ = 2
  _CHandI = {side="back";I=1}

  -- Deck
  local Deck={}; for i=1,18 do table.insert(Deck,i) end; local CardN
  local W,H = 300,200; local X,Y=-W*2,{-H*1.5,H*1.5}
  -- PJS
  for i=1,2 do
    for c=0,4 do
      CardN = table.remove(Deck,math.random(1,#Deck))
      newCard(X+W*c,Y[i],W,H,1,CardN,1,"back",false,false,true)
    end
  end
  -- Rest
  for i=1,#Deck do
    CardN = table.remove(Deck,math.random(1,#Deck))
    newCard(-W*3,0,W,H,1,CardN,1,"back",false,false,true)
  end

  -- Tokens
  local Wf,Hf = W*0.5,H*0.5
  for i=0,3 do newCard(-Wf*1.5+Wf*i,0,Wf,Hf,1,19,false,"front") end

  -- Boxs
  newBox(-W*3,0,W,H,{"back",1})
  newBox(W*3,0,W,H,{"back",1})
  initBoxs()


  print("Tides Of Time Board Ready")
end

_GamesInit["Pinguinos"] = function()

  _canRot = false
  _turn = {ing=1;t=false}
  _gameNPJ = 4
  _CHandI = false

	-- Deck
	local Deck = {}
	for i=1,30 do table.insert(Deck,5) end
	for i=1,20 do table.insert(Deck,6) end
	for i=1,10 do table.insert(Deck,7) end

	-- Board
	local Hsize = 200; local distY = Hsize*0.9
	local X = {-Hsize*3,-Hsize*3.5}
	local Y = {-distY*3.5,-distY*2.5}
	local FishN
	for i=1,4 do
		for j=0,6 do
			FishN = table.remove(Deck,math.random(1,#Deck))
			newCard(X[1]+Hsize*j,Y[1],Hsize,Hsize,1,FishN,false,"front")
		end
		Y[1]=Y[1]+distY*2
	end
	for i=1,4 do
		for j=0,7 do
			FishN = table.remove(Deck,math.random(1,#Deck))
			newCard(X[2]+Hsize*j,Y[2],Hsize,Hsize,1,FishN,false,"front")
		end
		Y[2]=Y[2]+distY*2
	end

	-- PJS
	local Pos = {{0,-distY*5.5};{0,distY*5.5};{-Hsize*5.5,0};{Hsize*5.5,0}}
	local Psize = 128
	for i=1,4 do
		for j=1,4 do
			newCard(Pos[i][1],Pos[i][2],Psize,Psize,1,i,false,"front",i)
		end
	end

	-- Point Counters
	for i,P in ipairs(Pos) do
		newBox(P[1]-Hsize,P[2],Hsize,Hsize,{"front",5})
		newBox(P[1],P[2],Hsize,Hsize,{"front",6})
		newBox(P[1]+Hsize,P[2],Hsize,Hsize,{"front",7})
	end
	initBoxs()

	-- Zones
	for i=0,3 do
		local B = _Boxs[1+i*3]; newZone(B.x-B.w_2,B.y-B.h_2,Hsize*3,Hsize,i+1)
	end

	print("Pinguinos Board Ready")
end

_GamesInit["Tsuro"] = function()

  _canRot = 4
  _turn = {ing=1;t=false}
  _gameNPJ = 8
  _CHandI = {side="back";I=1}

  -- Board
  local BSize = 780
  newCard(0,0,BSize*1.05,BSize*1.05,false,37,false,"front",0)

  -- Cards
  local CSize = BSize/6
  local Deck={}; for i=1,35 do table.insert(Deck,i) end; local CardN
  for i=1,#Deck do
    CardN = table.remove(Deck,math.random(1,#Deck))
    newCard(-CSize*5,-CSize,CSize,CSize,1,CardN,1,"back",false,false,true)
  end
  newCard(-CSize*5,CSize,CSize,CSize,1,36,false,"front")

  -- PJS
  local PjSize = BSize/26
  for i=0,6 do
    newCard(CSize*4,-PjSize*6+PjSize*2*i,PjSize,PjSize,false,38+i,false,"front")
    newCard(CSize*4+PjSize*2,-PjSize*6+PjSize*2*i,PjSize,PjSize,false,38+i,false,"front")
  end

  -- Boxs
  newBox(-CSize*5,-CSize,CSize,CSize,{"back",1})
  initBoxs()

  -- Tiles
  local X,Y = -CSize*2.5, -CSize*2.5
  for r=1,6 do
    for c=0,5 do newTile(X+CSize*c,Y,CSize,CSize) end
    Y=Y+CSize
  end

  print("Tsuro Board Ready")
end

_GamesInit["Catan"] = function()

  _canRot = 3
  _turn = {ing=1;t=false}
  _gameNPJ = 4
  _CHandI = {side="back";I=1}

  -- Board
  local BSize,Hf = 1280, math.sqrt(3)/2
  newCard(0,0,BSize,BSize*Hf,false,8,false,"front",0)

  -- mat cards & their boxes & others
  local cW = BSize*0.1; local cH = cW*1.5; local cY=-cH*2
  for i=0,4 do
    for j=1,24 do
      newCard(BSize*0.5+cW,cY,cW,cH,false,9+i,1,"front",false,false,true)
    end
    newBox(BSize*0.5+cW,cY,cW,cH,{"front",9+i})
    cY = cY + cH
	end

  cY = -cH*2
  -- Victori Cards
  for i=0,2 do
    newCard(-BSize*0.5-cH*0.5,cY,cH,cH,1,14+i,false,"front")
    cY = cY + cH
	end
  -- Build cost
  newCard(-BSize*0.5-cH*0.5,cY,cH,cH,false,7,false,"front",0)
  cY = cY + cH
  -- Upgrade Cards
  local Deck = { 21,21,22,22,23,23,24,25,26,27,24 }; for i=1,14 do table.insert(Deck,20) end
  for i=1,#Deck do
    CardN = table.remove(Deck,math.random(1,#Deck))
    newCard(-BSize*0.5-cH*0.5,cY,cW,cH,false,CardN,2,"back",false,false,true)
  end
  newBox(-BSize*0.5-cH*0.5,cY,cW,cH,{"back",2})

  -- HexaMats
  local HSize = BSize*0.2; local WSize = HSize*Hf
  Deck={ 1,2,2,2,2,3,3,3,3,4,4,4,5,5,5,6,6,6,6 };
  local TileH = HSize*0.75
  local X = {-WSize,-WSize*1.5,-WSize*2}
  local Y = {-TileH*2,-TileH}
  for r=1,2 do
  	for c=0,2 do
      CardN = table.remove(Deck,math.random(1,#Deck))
      newCard(X[1]+WSize*c,Y[1],WSize,HSize,1,CardN,false,"front",0)
    end
  	Y[1]=Y[1]+TileH*4
  end
  for r=1,2 do
  	for c=0,3 do
      CardN = table.remove(Deck,math.random(1,#Deck))
      newCard(X[2]+WSize*c,Y[2],WSize,HSize,1,CardN,false,"front",0)
    end
  	Y[2]=Y[2]+TileH*2
  end
  for c=0,4 do
    CardN = table.remove(Deck,math.random(1,#Deck))
    newCard(X[3]+WSize*c,0,WSize,HSize,1,CardN,false,"front",0)
  end

  -- Buildings & Thief
  local BuildS = BSize*0.05
  local bX = -BuildS*3; local bY
  for i=1,4 do
    bY = -BSize*Hf*0.5-BuildS*3
    for r=1,15 do
      newCard(bX,bY,BuildS/3,BuildS,1,17,false,"front",false,i)
    end
    bY = bY + BuildS
    for s=1,5 do
      newCard(bX,bY,BuildS/2,BuildS/2,1,18,false,"front",false,i)
    end
    bY = bY + BuildS
    for c=1,4 do
      newCard(bX,bY,BuildS,BuildS/2,1,19,false,"front",false,i)
    end
    bX = bX + BuildS*2
  end
  newCard(0,0,BuildS,BuildS,1,18,false,"front",false,5)

  -- Harbors
  local HarborS = BSize*0.05
  Deck={ 28,28,28,28,29,30,31,32,33 };
  for i=1,#Deck do
    CardN = table.remove(Deck,math.random(1,#Deck))
    newCard(0,0,HarborS,HSize/2,1,CardN,3,"back")
  end

  -- Dice World
  local DicesR = 128
  _diceD={
    W=love.physics.newWorld(0, (9.81*64)/2, true);
    _pi_2 = math.pi/2; _pi_3 = math.pi/3 ; _pi2 = math.pi*2;
    WsW=2560; WsH=1440;
  };
  newWalls(_diceD.W,_diceD.WsW,_diceD.WsH)

  local X = -_diceD.WsW/2
  for i=1,2 do
    table.insert(_diceD,newHexaDice(_diceD.W,1,DicesR,X+DicesR*4*i,0))
  end


  initBoxs(); print("Catan Board Ready")
end

_GamesInit["Takenoko"] = function()
  _canRot = 3
  _turn = {ing=1;t=false}
  _gameNPJ = 4
  _CHandI = {side="back";I=1}

  -- Cards
  --- Plots
  local Plots = {
    {c=5,n=11}, {c=6,n=9}, {c=7,n=7},
    w=256, h=256
  }
  local PlotDeck={};
  for Pi,P in ipairs(Plots) do
    for i=1,P.n do table.insert(PlotDeck,P.c) end
  end
  local PlotC

  for i=1,#PlotDeck do
    PlotC = table.remove(PlotDeck,math.random(1,#PlotDeck))
    newCard(0,-200,Plots.w,Plots.h,false,5,4,"back",false,PlotC)
  end
  newCard(0,-800,Plots.w,Plots.h,false,5,false,"front",0,8)

  -- Boards
  for i=1,4 do newCard(0,400,Plots.w*1.4,Plots.h*2,false,6,false,"front") end




  --- Improvements
  local Improvements = {
    {x=-100,y=800}, {x=0,y=800}, {x=100,y=800},
    w=80, h=80
  }

  for i,imp in ipairs(Improvements) do
    for j=1,3 do newCard(imp.x,imp.y,Improvements.w,Improvements.h,1,i+1) end
    newBox(imp.x,imp.y,Improvements.w,Improvements.h,{"front",i+1})
  end


  --
  initBoxs(); print("Takenoko Board Ready")
end

_GamesInit["Rummikub"] = function()
  _canRot = false
  _turn = {ing=1;t=100}
  _gameNPJ = 4
  _CHandI = {side="back";I=1}

  local W,H = 113,157;
  -- Deck
  local Deck={}; for i=1,52 do table.insert(Deck,i); table.insert(Deck,i) end; table.insert(Deck,53); table.insert(Deck,54);
  local CardN
  ---- 14 Packs
  local X=-W*3
  for i=0,4 do
    if i~=2 then
      for j=1,14 do
        CardN = table.remove(Deck,math.random(1,#Deck))
        newCard(X,0,W,H,1,CardN,1,"back",false,false,true)
      end
      newBox(X,0,W,H,{"back",1})
    end
    X = X + W*1.5
  end
  ---- Rest
  for i=1,#Deck do
    CardN = table.remove(Deck,math.random(1,#Deck))
    newCard(0,0,W,H,1,CardN,1,"back",false,false,true)
  end
  newBox(0,0,W,H,{"back",1})

  initBoxs(); print("Rummikub Board Ready")
end

_GamesInit["MrJackPocket"] = function()
  _canRot = 4
  _turn = {ing=1;t=false}
  _gameNPJ = 2
  _CHandI = {side="back";I=1}


  local w,h = 780,780; local x,y; local Deck; local cardN

  -- Streets
  Deck={}; for i=10,18 do table.insert(Deck,i) end;
  local sW,sH = w,h; local back;
  x,y = -w,-h
  for i=1,#Deck do
    if i==4 or i==7 then x=-w; y=y+h; end
    cardN = table.remove(Deck,math.random(1,#Deck)); if cardN==14 then back=3 else back=2 end
    newCard(x,y,sW,sH,math.random(1,4),cardN,back,"front")
    newTile(x,y,sW,sH);
    x=x+w;
  end

  -- Detectives
  local dW,dH = w/3,h/3;
  newCard(-w*1.5-dW,-h,dW,dH,1,27,false,"front")
  newCard(0,h*1.5+dH,dW,dH,1,28,false,"front")
  newCard(w*1.5+dW,-h,dW,dH,1,29,false,"front")

  -- Alibis
  aW,aH = w/2,h; x = w*1.5+dW+aW
  Deck={}; for i=1,9 do table.insert(Deck,i) end;
  for i=1,#Deck do
    cardN = table.remove(Deck,math.random(1,#Deck))
    newCard(x,-h,aW,aH,1,cardN,1,"back",false,false,true)
  end
  newBox(x,-h,aW,aH,{"back",1})

  -- Action Tokens
  atW, atH = w/3,h/3;
  local j=4; y=h*0.5-atH*1.5
  for i=30,36,2 do
    newCard(x,y,atW,atH,1,i,4,"back"); newCard(x,y,atW,atH,1,i+1,4,"back"); newBox(x,y,atW,atH,{"back",j},true)
    j=j+1; y=y+atH;
  end

  -- Time Tokens
  ttW, ttH = w/4,h/4; x=-x; y=ttH*3.5
  for i=0,7 do
    newCard(x,y-ttH*i,ttW,ttH,1,19+i)
  end

  initBoxs(); print("MrJackPocket Board Ready")
end


_GamesClose = {}

_GamesClose["Jaipur"] = function() print("Jaipur Board Closed") end

_GamesClose["Hive"] = function() print("Hive Board Closed") end

_GamesClose["TidesOfTime"] = function() print("Tides Of Time Board Closed") end

_GamesClose["Pinguinos"] = function() print("Pinguinos Board Closed") end

_GamesClose["Tsuro"] = function() print("Tsuro Board Closed") end

_GamesClose["Catan"] = function() _diceD.W:destroy(); print("Catan Board Closed") end

_GamesClose["Takenoko"] = function() print("Takenoko Board Closed") end

_GamesClose["Rummikub"] = function() print("Rummikub Board Closed") end

_GamesClose["MrJackPocket"] = function() print("MrJackPocket Board Closed") end

]]
