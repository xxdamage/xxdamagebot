local function action(msg, blocks)
    if blocks[1] == 'pin' then
		if roles.is_admin(msg) then
		    if not blocks[2] then
		        local pin_id = db:get('chat:'..msg.chat.id..':pin')
		        if pin_id then
		            api.sendMessage(msg.chat.id, ('Ultimo mensaje generado por `/pin` ^'), true, pin_id)
		        end
		        return
		    end
			local res, code = api.sendMessage(msg.chat.id, blocks[2]:gsub('$rules', misc.deeplink_constructor(msg.chat.id, 'rules')), true)
			if not res then
				if code == 118 then
				    api.sendMessage(msg.chat.id, ("El texto es demasiado largo, no puedo enviarlo"))
			    else
					api.sendMessage(msg.chat.id, ("El texto rompe el markdown."), true)
		    	end
	    	else
	    		db:set('chat:'..msg.chat.id..':pin', res.result.message_id)
	    		api.sendMessage(msg.chat.id, ("Ahora puedes anclar este texto y usar `/editpin [texto]` para editarlo, sin tener que mandar un nuevo pin"), true, res.result.message_id)
	    	end
    	end
	end
	if blocks[1] == 'editpin' then
		if roles.is_admin(msg) then
			local pin_id = db:get('chat:'..msg.chat.id..':pin')
			if not pin_id then
				api.sendReply(msg, _("No tienes ningun mensaje pineado con `/pin [texto]`"), true)
			else
				local res, code = api.editMessageText(msg.chat.id, pin_id, blocks[2]:gsub('$rules', misc.deeplink_constructor(msg.chat.id, 'rules')), nil, true)
				if not res then
					if code == 118 then
				    	api.sendMessage(msg.chat.id, ("El texto es demasiado largo, no puedo enviarlo"))
				    elseif code == 116 then
				    	api.sendMessage(msg.chat.id, ("La vista previa del mensaje anclado que envié *ya no existe*. No puedo editarlo"), true)
				    elseif code == 111 then
				    	api.sendMessage(msg.chat.id, ("El texto no esta modificado"), true)
			    	else
						api.sendMessage(msg.chat.id, ("Ese texto rompe el markdown."), true)
		    		end
		    	else
		    		db:set('chat:'..msg.chat.id..':pin', res.result.message_id)
	    			api.sendMessage(msg.chat.id, ("Mensaje editado."), nil, pin_id)
	    		end
	    	end
    	end
    end
end

return {
    action = action,
    triggers = {
        config.cmd..'(pin)$',
        config.cmd..'(pin) (.*)$',
		config.cmd..'(editpin) (.*)$',
	}
}
