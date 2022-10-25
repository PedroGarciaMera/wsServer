local C_Player = require 'class/player';
local Games = require 'games';

local function pointRectangle(P,R)
	return P.x>R.x-R.w_2 and P.x<R.x+R.w_2 and P.y>R.y-R.h_2 and P.y<R.y+R.h_2
end
local function isCardOwner(Card,PJ)
	if Card.owner then return Card.owner==PJ.turn end
	return true
end
local function canCard2Box(Box,Card)
	if Box.type then return Box.type[2]==Card.I[Box.type[1]] end
	return true
end

local changeSide = {front="back",back="front"}



local B = {
  pjs = {}; cards = {}; boxs = {};
	-- Game CFG
	allowRot = false; allowInvi = false; nPlayers = 0; turns = { first=true, c=0, free={}, n=1, }; isTiled = false;
};

B.actions = {
	-- Place/Pick card
	function(Self,clientID,WS)
		if Self.pjs[clientID].mouse.card then Self:placeCard(clientID,WS) else Self:pickCard(clientID,WS) end
	end,
  -- Rotate or flip card
	function(Self,clientID,WS)
		local pj = Self.pjs[clientID]; local mC=Self.cards[pj.mouse.card];

		if mC then
			-- Rotate of flip mouse card
			if Self.allowRots and mC.rot then
				-- Rotate mouse card
				mC.rot = mC.rot+1
				if mC.rot>Self.allowRots then mC.rot=1 end

				WS:sendAll({ name="rotCard"; data={ index=pj.mouse.card, rot=mC.rot } });
			else
				-- Flip mouse card
				-- if mC.I.back then mC.side = changeSide[mC.side] end
			end
		else
			-- Try flip board card
			for i,card in ipairs(Self.cards) do
				if pointRectangle(pj.mouse,card) and isCardOwner(card,pj) and card.I.back then
					card.side = changeSide[card.side]; card.invi = false;
					WS:sendAll({ name="sideBoardCard"; data={ side=card.side, invi=false, index=i } });
					return;
				end
			end
		end
	end,
	-- invisible flip card (Only you can see it)
	function(Self,clientID,WS)
		if (Self.allowInvi) then Self:inviFlip(clientID,WS) end
	end,
}



function B:init() Games.inits[Games.sel](self); self:initBoxs(); end
function B:initBoxs()
	for _,Box in ipairs(self.boxs) do
		for i,Card in ipairs(self.cards) do
			if pointRectangle(Card, Box) then table.insert(Box.cardsI,i) end
		end
	end
end

function B:newPlayer(clientID)
	local Turn; if next(self.turns.free) then Turn=table.remove(self.turns.free,1) else Turn=0 end

  if self.pjs[clientID] then self.pjs[clientID]:defaults(Turn);
	else self.pjs[clientID] = C_Player.new(Turn);
	end
end

function B:updateMousePos(clientID,Mpos)
  self.pjs[clientID]:updateMousePos(Mpos);
end

function B:rmvPlayer(clientID)
	local pj = self.pjs[clientID]; local turn = pj.turn;
	if turn~=0 then table.insert(self.turns.free,turn); table.sort(self.turns.free); end

	if pj.mouse.card then
		self.cards[pj.mouse.card].x = pj.mouse.x; self.cards[pj.mouse.card].y = pj.mouse.y;
		self.cards[pj.mouse.card].onBoard = true;
	end

  self:nextTurn(clientID); self.pjs[clientID]=nil;
end

function B:nextTurn(clientID)
	local pj = self.pjs[clientID];

	if self.turns.first then
		self.turns.first = nil;

		for _,p in pairs(self.pjs) do self.turns.c = p.turn; return true; end
	elseif self.turns.c == pj.turn then
		local usingT = {};
		for _,p in pairs(self.pjs) do table.insert(usingT,p.turn) end
		table.sort(usingT);

		self.turns.n, self.turns.c = next(usingT,self.turns.n);
		if not self.turns.c then self.turns.n, self.turns.c = next(usingT) end

		return true;
	end

	return false;
end

-- Actions
function B:pickCard(clientID,WS)
	local pj = self.pjs[clientID];

	-- Pick from Box
	for i,box in ipairs(self.boxs) do
		if next(box.cardsI) and pointRectangle(pj.mouse,box) then
			local CardI = table.remove( box.cardsI, love.math.random(#box.cardsI) );
			local Card = self.cards[CardI];

			WS:sendAll({ name="card2Mouse"; data={ id=clientID, index=CardI } });
			Card.onBoard = false; pj.mouse.card = CardI;

			return;
		end
	end

	-- Pick from Board
	local Card
	for i=#self.cards,1,-1 do
		Card = self.cards[i];

		if pointRectangle(pj.mouse,Card) and isCardOwner(Card,pj) then
			WS:sendAll({ name="card2Mouse"; data={ id=clientID, index=i } });
			Card.onBoard = false; pj.mouse.card = i;

			return;
		end
	end
end

function B:placeCard(clientID,WS)
	local pj = self.pjs[clientID];

	local Card = self.cards[pj.mouse.card]; Card.x = pj.mouse.x; Card.y = pj.mouse.y;
	-- Check Boxs
	for i,Box in ipairs(self.boxs) do
		if pointRectangle(Card,Box) then
			if canCard2Box(Box,Card) then
				Card.x=Box.x; Card.y=Box.y;
				table.insert(Box.cardsI,pj.mouse.card);
				if Card.I.back then Card.side = "back" end

				-- for _,v in ipairs(_PJS) do v.client:send("updateBoxN",{i,#Box.cards}) end
				-- if Box.rand then randBox(self,Box) end
			else
				Card.x=Box.x+Box.w; Card.y=Box.y+Box.h;
			end
			break
		end
	end
	-- isTiled ?
	if Card.tiled and self.isTiled then
		Card.x = self.isTiled * math.floor((Card.x+Card.w_2)/self.isTiled);
		Card.y = self.isTiled * math.floor((Card.y+Card.h_2)/self.isTiled);
	end
	-- Send and empty hand
	WS:sendAll({ name="card2Board"; data={ id=clientID, index=pj.mouse.card, x=Card.x, y=Card.y, side=Card.side } })
	Card.onBoard = true; pj.mouse.card = false;
end

function B:inviFlip(clientID,WS)
	local pj = self.pjs[clientID];

	-- Try invi flip board card
	for i,card in ipairs(self.cards) do
		if pointRectangle(pj.mouse,card) and isCardOwner(card,pj) and card.side=="back" and not card.invi then
			card.invi = clientID; card.side = "front";
			WS:sendAll({ name="sideBoardCard"; data={ side=card.side, invi=clientID, index=i } });
			return;
		end
	end
end


return B;