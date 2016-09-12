local action = function(msg, blocks) 
if roles.is_admin then
 if blocks[1] == "plugins" then
  if not blocks[2] then
	api.sendMessage(msg.chat.id, "*Plugins activados*\n"..load_plugins(), true)
  end

   if blocks[2] == "enable" then
	 enabled = enable_plugin(msg, blocks)
	 if enabled == true then
	 	api.sendReply(msg, "✅ Plugin _"..blocks[3]..".lua_  *activado* exitosamente.", true)
	 	bot_init(true)
	 else
	 	api.sendReply(msg, "✅ El plugin _"..blocks[3]..".lua_  *ya fué activado* anteriormente ó *posiblemente no existe*.", true)
	 end
   end
 
   if blocks[2] == "disable" then
	 disabled = disable_plugin(msg, blocks)
	 if disabled == true then
	 	api.sendReply(msg, "❌ Plugin _"..blocks[3]..".lua_  *desactivado* exitosamente.", true)
	 	bot_init(true)
	 else
	 	api.sendReply(msg, "❌ El plugin _"..blocks[3]..".lua_ *ya fué desactivado* anteriormente.", true)
	 end
   end  
 end
end
end

return {
action = action,
triggers = {
	'^[/#!](plugins)$',
	'^[/#!](plugins) (enable) (.+)',
	'^[/#!](plugins) (disable) (.+)'
    }
}