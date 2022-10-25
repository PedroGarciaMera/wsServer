local Player = { }

function Player.new(Turn)
  local new = {}; setmetatable(new, {__index = Player});

  new:defaults(Turn);

  return new;
end

function Player:updateMousePos(Mpos)
  self.mouse.x = Mpos.x; self.mouse.y = Mpos.y;
end

function Player:defaults(Turn)
  self.mouse = {x=0,y=0,card=false};
  self.turn = Turn or 0;
  self.name = "?¿?";
end

return Player
