--enable o disable cosas como entrada de otros bots, antispam, aviso de mencion...

local action = function(msg, blocks, ln)

if roles.is_admin(msg) then

	if blocks[1] == 'bots' then

		if not blocks[2]:match('^(enable)$') and not blocks[2]:match('^(disable)$') then
			api.sendReply(msg, '*ERROR*\nDebe usarse de esta manera:\n`/bots enable|disable`', true)
			return
		end
		local status = blocks[2]
		local current = db:hget('chat:'..msg.chat.id..':settings', 'bots')
		if current == status then
			grep = status:gsub('^enable$', 'permitida'):gsub('^disable$', 'no permitida')
			api.sendMessage(msg.chat.id, 'La entrada de otros bots ya estaba *'..grep..'*', true)		
		else
			db:hset('chat:'..msg.chat.id..':settings', 'bots', status)
			grep = status:gsub('^enable$', 'permitida'):gsub('^disable$', 'no permitida')
			api.sendMessage(msg.chat.id, '_Ahora la entrada de otros bots estara_ : *'..grep..'*', true)
		end
	end

	if blocks[1] == 'mencion' then

		if not blocks[2]:match('^(enable)$') and not blocks[2]:match('^(disable)$') then
			api.sendReply(msg, '*ERROR*\nDebe usarse de esta manera:\n`/mencion enable|disable`', true)
			return
		end
		local status = blocks[2]
		local current = db:hget('chat:'..msg.chat.id..':settings', 'mencion')
		if current == status then
			grep = status:gsub('^enable$', 'activados'):gsub('^disable$', 'desactivados')
			api.sendMessage(msg.chat.id, 'Los avisos de mencion ya estaban *'..grep..'*', true)		
		else
			db:hset('chat:'..msg.chat.id..':settings', 'mencion', status)
			grep = status:gsub('^enable$', 'activados'):gsub('^disable$', 'desactivados')
			api.sendMessage(msg.chat.id, '_Ahora los avisos de mencion estaran_ : *'..grep..'*', true)
		end
	end
        
        if blocks[1] == 'referidos' then

		if not blocks[2]:match('^(enable)$') and not blocks[2]:match('^(disable)$') then
			api.sendReply(msg, '*ERROR*\nDebe usarse de esta manera:\n`/referidos enable|disable`', true)
			return
		end
		local status = blocks[2]
		local current = db:hget('chat:'..msg.chat.id..':settings', 'referidos')
		if current == status then
			grep = status:gsub('^enable$', 'permitidos'):gsub('^disable$', 'no permitidos')
			api.sendMessage(msg.chat.id, 'Los enlaces referidos ya estaban *'..grep..'*', true)		
		else
			db:hset('chat:'..msg.chat.id..':settings', 'referidos', status)
			grep = status:gsub('^enable$', 'permitidos'):gsub('^disable$', 'no permitidos')
			api.sendMessage(msg.chat.id, '_Ahora los enlaces referidos estaran_ : *'..grep..'*', true)
		end
	end

	if blocks[1] == 'spam' then

		if not blocks[2]:match('^(enable)$') and not blocks[2]:match('^(disable)$') then
			api.sendReply(msg, '*ERROR*\nDebe usarse de esta manera:\n`/spam enable|disable`', true)
			return
		end
		local status = blocks[2]
		local current = db:hget('chat:'..msg.chat.id..':settings', 'spam')
		if current == status then
			grep = status:gsub('^enable$', 'permitido'):gsub('^disable$', 'no permitido')
			api.sendMessage(msg.chat.id, 'El spam ya estaba *'..grep..'*', true)		
		else
			db:hset('chat:'..msg.chat.id..':settings', 'spam', status)
			grep = status:gsub('^enable$', 'permitido'):gsub('^disable$', 'no permitido')
			api.sendMessage(msg.chat.id, '_Ahora el spam estará_ : *'..grep..'*', true)
			end
		end
	end
end

	return {
	action = action,
	triggers = {
	'^[/!](bots) (%a+)$',
	'^[/!](say) (%a+)$',
	'^[/!](mencion) (%a+)$',
	'^[/!](spam) (%a+)$',
	'^[/!](referidos) (%a+)$',
	}
}
