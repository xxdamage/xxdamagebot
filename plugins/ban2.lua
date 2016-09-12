-- puedes banear otros bots con ID o username

local function id_users(usuario)
 local url = 'HTTPS://api.pwrtelegram.xyz/bot'..config.bot_api_key..'/getChat?chat_id='..usuario
 local dat = HTTPS.request(url)	
 local res = JSON.decode(dat)
 if not res.ok or not res then
		return '(no existe)'
 end
		return res.result.id
end


local action = function(msg, blocks)
if roles.is_admin(msg) then

 if blocks[1] == 'expulsar' then
 
  if blocks[2] then
  
	local resolviendo = id_users(blocks[2])
	local accion = api.kickUser(msg.chat.id, resolviendo)
	
	if accion then
		api.sendMessage(msg.chat.id, 'Usuario `'..resolviendo..'` expulsado', true)
	else
		api.sendMessage(msg.chat.id, 'Usuario `'..resolviendo..'` no expulsado', true)
	end
	
  end
 end 

 if blocks[1] == 'banear' then
  if blocks[2] then
  
	local resolviendo = id_users(blocks[2])
	local accion = api.banUser(msg.chat.id, resolviendo)
	
	if accion then
		api.sendMessage(msg.chat.id, 'Usuario `'..resolviendo..'` baneado', true)
	else
		api.sendMessage(msg.chat.id, 'Usuario `'..resolviendo..'` no baneado', true)
	end
	
  end
 end

 if blocks[1] == 'desbanear' then
  if blocks[2] then
  
	local resolviendo = id_users(blocks[2])
	local accion = api.unbanUser(msg.chat.id, resolviendo)
	
	if accion then
		api.sendMessage(msg.chat.id, 'Usuario `'..resolviendo..'` desbaneado', true)
	else
		api.sendMessage(msg.chat.id, 'Usuario `'..resolviendo..'` no desbaneado', true)
	end
  end
 end

end
end


return {
	action = action,
	triggers = {
		'^/(expulsar) (.+)$',
		'^/(banear) (.+)$',
		'^/(desbanear) (.+)$'
		 }
		}
