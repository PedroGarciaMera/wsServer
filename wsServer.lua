local http_server = require "http.server";
local http_headers = require "http.headers";
local http_websocket = require "http.websocket";
local json = require "rxi_json";  -- https://github.com/rxi/json.lua


local wsServer = { events={}, clientI=1, clients={}, gameName="None" };

function wsServer:addEvent(name,exe) self.events[name] = exe end

function wsServer:sendAll(msg)
	local status, M = pcall(json.encode,msg);
	if not status then  print("rxi_json :: ERROR :: Couldn't encode message"); return; end

	for _, client in pairs(self.clients) do assert( client:send(M) ) end
end

function wsServer:send(clientID,msg)
	local status, M = pcall(json.encode,msg);
	if not status then  print("rxi_json :: ERROR :: Couldn't encode message"); return; end
	
	assert( self.clients[clientID]:send(M) );
end

function wsServer:exeMessage(clientID, msg)
	local status, M = pcall(json.decode,msg);
	if not status then print("rxi_json :: ERROR :: Couldn't decode message", M); return; end

	if not M.name then print("ERROR :: M.name not found"); return; end
	-- if not M.data then print("json :: ERROR :: M.data not found"); return; end

	if self.events[M.name] then self.events[M.name](clientID, M.data) else print("["..M.name.."] event not found") end
end

function wsServer:exeEmpty(clientID, name)
	if self.events[name] then self.events[name](clientID) else print("json :: ["..name.."] event not found") end
end

function wsServer:initWS(ws)	
	assert(ws:accept());
	
	-- New client
	local clientID = self.clientI;
	self.clients[clientID] = ws; self.clientI = self.clientI + 1;
	self:exeEmpty(clientID, "open");
	
	-- Listen
	repeat
		local data, err, errno = ws:receive();
		if data then self:exeMessage(clientID, data) end
	until not data
	
	-- Client DC
	self.clients[clientID] = nil;
	self:exeEmpty(clientID, "close");
end

function wsServer:sendGameName(stream)
	local res_headers = http_headers.new();
	res_headers:append(":status", "200");
	res_headers:append("Content-type", "text/plain");
	res_headers:append("Access-Control-Allow-Origin", "*");

	assert(stream:write_headers(res_headers, false));
	assert(stream:write_chunk(self.gameName, true));
end

function wsServer.checkWS(server, stream)
	local request_headers = assert(stream:get_headers());
	local ws, err, nose = http_websocket.new_from_stream(stream, request_headers);
	
	if ws then wsServer:initWS(ws) else wsServer:sendGameName(stream) end
end

function wsServer:init(gameName)
	wsServer.gameName = gameName;

	wsServer.S = assert(http_server.listen {
		host = "0.0.0.0";
		port = 22122;
		onstream = wsServer.checkWS;
		-- onerror = function(myserver, context, op, err, errno) -- luacheck: ignore 212
			-- local msg = op .. " on " .. tostring(context) .. " failed"
			-- if err then
				-- msg = msg .. ": " .. tostring(err)
			-- end
			-- assert(io.stderr:write(msg, "\n"))
		-- end;
	});
	
	assert(wsServer.S:listen()); print("Now listening on port ".."22122");
	assert(wsServer.S:loop());
end

return wsServer;
