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


local G = { }

G["Carcassone"] = function(B)
	-- Settings
	B.allowRots = 4; B.isTiled = 100; B:setNPlayer(5);

	local W,H = B.isTiled,B.isTiled;
	---- Boxs
	local BoxX, BoxY = W*10, H*2;
	table.insert(B.boxs,newBox(BoxX, BoxY, W, H, {"back",1}, true))
	---- Cards
	-- Points BOARD
	table.insert(B.cards,newCard(0,640,480,330,false,1,false,"front",-1));
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
	for i=1,B.turns.n do
		for j=1,nMapples do
			table.insert(B.cards,newCard(W*8+j*mW,320+mH*i,mW,mH,1,30+i,false,"front",i))
		end
	end



	print("Carcassone Board Server Ready")
end

G["Chess"] = function(B)
	B.isTiled = 70; B:setNPlayer(2);

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

G["MrJackPocket"] = function(B)
	-- Settings
	B.allowRots = 4; B.allowInvi = true; B:setNPlayer(2);

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

G["Stratego"] = function(B)
	-- Settings
	B.isTiled = 90; B.allowInvi = true; B:setNPlayer(2);
	
	local p1y, p2y = B.isTiled, B.isTiled*10;
	local p1c = {}; local p2c = {};
	
	local bSize = B.isTiled*10; local bY = B.isTiled*5; local bX = B.isTiled*9;
	-- Board
	table.insert(B.cards,newCard(bX,bY,bSize,bSize,false,1,false,"front",-1));	
	-- Bombs
	for i=1,6 do table.insert(p1c,2); table.insert(p2c,3); end
	-- Spy
	table.insert(p1c,4); table.insert(p2c,5);
	-- Scout
	for i=1,8 do table.insert(p1c,6); table.insert(p2c,7); end
	-- Miners
	for i=1,5 do table.insert(p1c,8); table.insert(p2c,9); end
	-- Sargeants
	for i=1,4 do table.insert(p1c,10); table.insert(p2c,11); end
	-- Lieutenants
	for i=1,4 do table.insert(p1c,12); table.insert(p2c,13); end
	-- Capitans
	for i=1,4 do table.insert(p1c,14); table.insert(p2c,15); end
	-- Majors
	for i=1,3 do table.insert(p1c,16); table.insert(p2c,17); end
	-- Colonels
	for i=1,2 do table.insert(p1c,18); table.insert(p2c,19); end
	-- Generals
	table.insert(p1c,20); table.insert(p2c,21);
	-- Marchals
	table.insert(p1c,22); table.insert(p2c,23);
	-- Flags
	table.insert(p1c,24); table.insert(p2c,25);
	
	
	local cardN; local cSize_2 = B.isTiled/2; local rx,cy;
	-- Piezes P1
	cy = cSize_2;
	for r=1,5 do
		rx = cSize_2;
		for c=1,4 do
			cardN = table.remove(p1c,math.random(#p1c));
			table.insert(B.cards,newCard(rx,cy,B.isTiled,B.isTiled,false,cardN,1,"front",1,false,false,true));
			rx = rx + B.isTiled;
		end
		cy = cy + B.isTiled;
	end	
	
	cy = cSize_2;
	for r=1,5 do
		rx = cSize_2 + B.isTiled*14;
		for c=1,4 do
			cardN = table.remove(p1c,math.random(#p1c));
			table.insert(B.cards,newCard(rx,cy,B.isTiled,B.isTiled,false,cardN,1,"front",1,false,false,true));
			rx = rx + B.isTiled;
		end
		cy = cy + B.isTiled;
	end	
	-- Piezes P2
	cy = cSize_2 + B.isTiled*5;
	for r=1,5 do
		rx = cSize_2;
		for c=1,4 do
			cardN = table.remove(p2c,math.random(#p2c));
			table.insert(B.cards,newCard(rx,cy,B.isTiled,B.isTiled,false,cardN,2,"front",2,false,false,true));
			rx = rx + B.isTiled;
		end
		cy = cy + B.isTiled;
	end
	
	cy = cSize_2 + B.isTiled*5;
	for r=1,5 do
		rx = cSize_2 + B.isTiled*14;
		for c=1,4 do
			cardN = table.remove(p2c,math.random(#p2c));
			table.insert(B.cards,newCard(rx,cy,B.isTiled,B.isTiled,false,cardN,2,"front",2,false,false,true));
			rx = rx + B.isTiled;
		end
		cy = cy + B.isTiled;
	end

	-- Invi
	for i,c in ipairs(B.cards) do 
		if i>=42 then c.invi=2 else c.invi=1 end
	end; 
	B.cards[1].invi = false;
	


	print("Stratego Board Server Ready")
end


return G
