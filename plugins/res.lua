local function res_usuario(msg, blocks)
	local dec = blocks[2]:gsub(' ', ''):gsub('\t', ''):gsub('\n', '')
	local url = 'HTTPS://api.pwrtelegram.xyz/bot'..config.bot_api_key..'/getChat?chat_id='..dec
	local dat = HTTPS.request(url)	
	local res = JSON.decode(dat)
	if not res.ok or not res then
			return '**No encontrado**'
	end
	if res.result.last_name and res.result.username then
	   return 'ID: '..res.result.id
	   ..'\nNombre: ' ..res.result.first_name
	   ..'\nApellido: ' ..res.result.last_name
	   ..'\nAlias: @' ..res.result.username
	end
	if not res.result.last_name and res.result.username and not res.result.title then
	   return 'ID: '..res.result.id
	   ..'\nNombre: ' ..res.result.first_name
	   ..'\nAlias: @' ..res.result.username
	end
	if not res.result.last_name and not res.result.username and not res.result.title then
	   return 'ID: '..res.result.id
	   ..'\nNombre: ' ..res.result.first_name
	end
	if res.result.last_name and not res.result.username then
	   return 'ID: '..res.result.id
	   ..'\nNombre: ' ..res.result.first_name
	   ..'\nApellido: ' ..res.result.last_name
	end
	if res.result.title and res.result.username then
	   return 'Chat ID: '..res.result.id
	   ..'\nTítulo: ' ..res.result.title
	   ..'\nAlias: @' ..res.result.username
	end
end

local action = function(msg, blocks, ln)
local res = res_usuario(msg, blocks)

 if blocks[1] == 'res' then
 
   if blocks[2] then
   	if roles.is_admin(msg) then
	api.sendReply(msg, res)
else
	api.sendReply(msg, '🚫 *no tienes poderes para hacer eso :)*', true)
   end
   end
 end
 
end

return {
	action = action,
	triggers = {
		'^[/!](res) (.+)$',
	}
}
