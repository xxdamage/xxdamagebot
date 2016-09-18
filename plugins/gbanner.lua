local function grep_reply(msg)
		local action = io.popen('grep -rn "'..msg.reply.from.id..'" ./data/gbans.lua')
		local read = action:read("*a")
		return read
end

local function grep_matches(msg, matches)
		local action = io.popen('grep -rn "'..matches[2]..'" ./data/gbans.lua')
		local read = action:read("*a")
		return read
end


local action = function(msg, matches)

if msg.from.id == config.admin.owner then

 if matches[1] == "gban" then
	
	if matches[2] then
	get = grep_matches(msg, matches)
	 if get == '' then
  		os.execute('perl -pi -e "s[gbans = \\{][gbans = {\n\t'..matches[2]..',]g" data/gbans.lua')
		api.sendReply(msg, "ID " ..matches[2].. " *globalmente baneada*.", true)
		bot_init(true)
	 else
	 	api.sendMessage(msg.chat.id, 'Este usuario *ya había sido baneado* anteriormente.', true)
		return nil
	 end
	end
	
 	if not matches[2] then
		if msg.reply then
			get = grep_reply(msg)
			action_sucess = api.kickUser(msg.chat.id, msg.reply.from.id)
			if action_sucess then
			 if get == '' then
			 	os.execute('perl -pi -e "s[gbans = \\{][gbans = {\n\t'..msg.reply.from.id..',]g" data/gbans.lua')
				api.sendReply(msg, "Usuario *expulsado*.\nID " ..msg.reply.from.id.. " *globalmente baneada*.", true)
				bot_init(true)
			 else
			 	api.sendMessage(msg.chat.id, 'Esta ID *ya había sido globalmente baneada* anteriormente.', true)
			 	return nil
			 end
			end
			if not action_sucess then
			 if get == '' then
			 	os.execute('perl -pi -e "s[gbans = \\{][gbans = {\n\t'..msg.reply.from.id..',]g" data/gbans.lua')
				api.sendReply(msg, "Usuario *no expulsado*.\nID " ..msg.reply.from.id.. " *globalmente baneada*.", true)
				bot_init(true)
			 else
			 	api.sendMessage(msg.chat.id, 'Esta ID *ya había sido globalmente baneada* anteriormente.', true)
			 	return nil
			 end
			end
		else
			api.sendMessage(msg.chat.id, "Este comando necesita respuesta")
		end
	end
 end

 if matches[1] == "ungban" then
	if matches[2] then
	get = grep_matches(msg, matches)
	 if get == '' then
	 	api.sendMessage(msg.chat.id, 'Esta ID *ya había sido globalmente desbaneada* anteriormente.', true)
	  	return nil
	 else
	  	os.execute('sed -i "/' ..matches[2].. '/d" ./data/gbans.lua')
		api.sendReply(msg, "ID " ..matches[2].. " *globalmente desbaneada*.", true)
		bot_init(true)
	 end
	end
	
 	if not matches[2] then
		if msg.reply then
			get = grep_reply(msg)
			action_sucess = api.unbanChatMember(msg.chat.id, msg.reply.from.id)
			if action_sucess then
			 if get == '' then
	 			api.sendReply(msg, 'Esta ID *ya había sido globalmente desbaneada* anteriormente.', true)
	  			return nil
	 		 else
	 		 	os.execute('sed -i "/' ..msg.reply.from.id.. '/d" ./data/gbans.lua')
				api.sendReply(msg, "ID " ..msg.reply.from.id.. " *globalmente desbaneada*.\nEste usuario, ya puede ingresar al grupo de nuevo.", true)
				bot_init(true)
			 end
			end
			if not action_sucess then
			 if get == '' then
	 			api.sendReply(msg, 'Esta ID *ya había sido globalmente desbaneada* anteriormente.', true)
	  			return nil
	 		 else
	 		 	os.execute('sed -i "/' ..msg.reply.from.id.. '/d" ./data/gbans.lua')
				api.sendReply(msg, "ID " ..msg.reply.from.id.. " *globalmente desbaneada*.\nEste usuario aún no puede ingresar al grupo de nuevo.", true)
				bot_init(true)
			 end
			end
		else
			api.sendMessage(msg.chat.id, "Este comando necesita respuesta")
		end
	end
 end

 if matches[1] == "isgban" then
	if matches[2] then
		local grep = io.popen("grep "..matches[2].. " ./data/gbans.lua")
		local list = grep:read("*a")
		if list == "" then
		api.sendMessage(msg.chat.id, "_No se encontraron coincidencias_", true)
		else
			api.sendMessage(msg.chat.id, "*Demasiado seguro*\nSe encontraron las siguientes coincidencias:\n\n_"..list.."_", true)
			end
	end
	
 	if not matches[2] then
		if msg.reply then
			local grep = io.popen("grep "..msg.reply.from.id.. " ./data/gbans.lua")
		local list = grep:read("*a")
		if list == "" then
		api.sendReply(msg, "_Esta ID no esta globalmente baneada_", true)
		else
	        api.sendReply(msg, "La ID "..msg.reply.from.id.." está *globalmente baneada*", true)
		end
		end
		end
 end
end

end

return {
	action = action,
	triggers = {
				'^[/!](gban)$',
				'^[/!](gban) (%d+)$',
				'^[/!](ungban)$',
				'^[/!](ungban) (%d+)$',
				'^[/!](isgban)$',
				'^[/!](isgban) (%d+)$'
				}
		}
