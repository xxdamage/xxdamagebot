local function do_keybaord_credits()
	local keyboard = {}
    keyboard.inline_keyboard = {
    	{
    		{text = 'Channel', url = 'https://telegram.me/'..config.channel:gsub('@', '')},
    		{text = 'GitHub', url = 'https://github.com/RememberTheAir/GroupButler'},
    		{text = 'Rate me!', url = 'https://telegram.me/storebot?start='..bot.username},
		}
	}
	return keyboard
end

local function res_usuario(msg, blocks)
	local dec = msg:gsub(' ', ''):gsub('\t', ''):gsub('\n', '')
	local url = 'https://api.pwrtelegram.xyz/bot'..config.bot_api_key..'/getChat?chat_id='..dec
--	local url2 = 'https://api.telegram.org/bot' .. config.bot_api_key..'/getChat?chat_id='..dec
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

local function do_keyboard_cache(chat_id)
	local keyboard = {inline_keyboard = {{{text = '🔄️ Refresh cache', callback_data = 'cc:rel:'..chat_id}}}}
	return keyboard
end

local function get_time_remaining(seconds)
	local final = ''
	local hours = math.floor(seconds/3600)
	seconds = seconds - (hours*60*60)
	local min = math.floor(seconds/60)
	seconds = seconds - (min*60)
	
	if hours and hours > 0 then
		final = final..hours..'h '
	end
	if min and min > 0 then
		final = final..min..'m '
	end
	if seconds and seconds > 0 then
		final = final..seconds..'s'
	end
	
	return final
end

local function get_user_id(msg, blocks)
	if msg.reply then
		print('reply')
		return msg.reply.from.id
	elseif blocks[2] then
		if blocks[2]:match('@[%w_]+$') then --by username
			local user_id = misc.res_user_group(blocks[2], msg.chat.id)
			if not user_id then
				print('username (not found)')
				return false
			else
				print('username (found)')
				return user_id
			end
		elseif blocks[2]:match('%d+$') then --by id
			print('id')
			return blocks[2]
		elseif msg.mention_id then --by text mention
			print('text mention')
			return msg.mention_id
		else
			return false
		end
	end
end

local function get_name_getban(msg, blocks, user_id)
	if blocks[2] then
		return blocks[2]..' ('..user_id..')'
	else
		return msg.reply.from.first_name..' ('..user_id..')'
	end
end

local function get_ban_info(user_id, chat_id, ln)
	local hash = 'ban:'..user_id
	local ban_info = db:hgetall(hash)
	local text
	if not next(ban_info) then
		text = lang[ln].getban.nothing..'\n'
	else
		local ban_index = {
			['kick'] = lang[ln].getban.kick,
			['ban'] = lang[ln].getban.ban,
			['tempban'] = lang[ln].getban.tempban,
			['flood'] = lang[ln].getban.flood,
			['media'] = lang[ln].getban.media,
			['warn'] = lang[ln].getban.warn,
			['arab'] = lang[ln].getban.arab,
			['rtl'] = lang[ln].getban.rtl,
		}
		text = ''
		for type,n in pairs(ban_info) do
			text = text..'`'..ban_index[type]..'`'..'*'..n..'*\n'
		end
		if text == '' then
			return lang[ln].getban.nothing
		end
	end
	local warns = (db:hget('chat:'..chat_id..':warns', user_id)) or 0
	local media_warns = (db:hget('chat:'..chat_id..':mediawarn', user_id)) or 0
	text = text..'\n`Warns`: '..warns..'\n`Media warns`: '..media_warns
	return text
end

local function do_keyboard_userinfo(user_id, ln)
  local keyboard = {
    inline_keyboard = {
         {
        {text ='🔨 Ban', callback_data = 'userbutton:banuser:'..user_id},
          {text ='✅ UnBan', callback_data = 'userbutton:unbanuser:'..user_id}
       },

       {
        {text ='🔒 Block', callback_data = 'userbutton:blockuser:'..user_id},
          {text ='🔓 UnBlock', callback_data = 'userbutton:unblockuser:'..user_id}
       },
    
         {
        {text ='🔥 Global Ban', callback_data = 'userbutton:gbanuser:'..user_id},
          {text ='✅ Global UnBan', callback_data = 'userbutton:ungbanuser:'..user_id}
       },
        {{text ='‼️ '..lang[ln].userinfo.remwarns_kb..'', callback_data = 'userbutton:remwarns:'..user_id}},
      {{text ='🔠 Resolver Usuario', callback_data = 'userbutton:resolver:'..user_id}},
      }
  }
  
  return keyboard
end


local function get_userinfo(user_id, chat_id, ln)
	return lang[ln].userinfo.header_1..get_ban_info(user_id, chat_id, ln)
end

local action = function(msg, blocks, matches)
    if blocks[1] == 'adminlist' then
    	if msg.chat.type == 'private' then return end
    	local out
        local creator, adminlist = misc.getAdminlist(msg.chat.id)
        out = lang[msg.ln].mod.modlist:compose(creator, adminlist)
        if not roles.is_admin_cached(msg) then
        	api.sendMessage(msg.from.id, out, true)
        else
            api.sendReply(msg, out, true)
        end
    end
    if blocks[1] == 'status' then
    	if msg.chat.type == 'private' then return end
    	if roles.is_admin_cached(msg) then
    		local user_id
    		if blocks[2]:match('%d+$') then
    			user_id = blocks[2]
    		else
    			user_id = misc.res_user_group(blocks[2], msg.chat.id)
    		end
    		if not user_id then
		 		api.sendReply(msg, lang[msg.ln].bonus.no_user, true)
		 	else
		 		local res = api.getChatMember(msg.chat.id, user_id)
		 		if not res then
		 			api.sendReply(msg, lang[msg.ln].status.unknown)
		 			return
		 		end
		 		local status = res.result.status
				local name = res.result.user.first_name
				if res.result.user.username then name = name..' (@'..res.result.user.username..')' end
				if msg.chat.type == 'group' and misc.is_banned(msg.chat.id, user_id) then
					status = 'kicked'
				end
		 		local text = make_text(lang[msg.ln].status[status], name)
		 		api.sendReply(msg, text)
		 	end
	 	end
 	end
 	if blocks[1] == 'id' then
 		if not(msg.chat.type == 'private') and not roles.is_admin_cached(msg) then return end
 		local id
 		if msg.reply then
 			id = msg.reply.from.id
 		else
 			id = msg.chat.id
 		end
 		api.sendReply(msg, '`'..id..'`', true)
 	end
    if blocks[1] == 'welcome' then
        
        if msg.chat.type == 'private' or not roles.is_admin_cached(msg) then return end
        
        local input = blocks[2]
        
        --ignore if not input text and not reply
        if not input and not msg.reply then
            api.sendReply(msg, make_text(lang[msg.ln].settings.welcome.no_input), false) return
        end
        
        local hash = 'chat:'..msg.chat.id..':welcome'
        
        if not input and msg.reply then
            local replied_to = misc.get_media_type(msg.reply)
            if replied_to == 'sticker' or replied_to == 'gif' then
                local file_id
                if replied_to == 'sticker' then
                    file_id = msg.reply.sticker.file_id
                else
                    file_id = msg.reply.document.file_id
                end
                db:hset(hash, 'type', 'media')
                db:hset(hash, 'content', file_id)
                api.sendReply(msg, lang[msg.ln].settings.welcome.media_setted..'`'..replied_to..'`', true)
            else
                api.sendReply(msg, lang[msg.ln].settings.welcome.reply_media, true)
            end
        else
            db:hset(hash, 'type', 'custom')
            db:hset(hash, 'content', input)
            local res, code = api.sendReply(msg, input, true)
            if not res then
                db:hset(hash, 'type', 'no') --if wrong markdown, remove 'custom' again
                db:hset(hash, 'content', 'no')
                if code == 118 then
				    api.sendMessage(msg.chat.id, lang[msg.ln].bonus.too_long)
			    else
				    api.sendMessage(msg.chat.id, lang[msg.ln].breaks_markdown, true)
			    end
            else
                local id = res.result.message_id
                api.editMessageText(msg.chat.id, id, lang[msg.ln].settings.welcome.custom_setted, false, true)
            end
        end
    end
	if blocks[1] == 'user' then
		if msg.chat.type == 'private' or not roles.is_admin_cached(msg) then return end
		
		if not msg.reply and (not blocks[2] or (not blocks[2]:match('@[%w_]+$') and not blocks[2]:match('%d+$') and not msg.mention_id)) then
			api.sendReply(msg, lang[msg.ln].userinfo.reply_or_mention) return
		end
		
		------------------ get user_id --------------------------
		local user_id = get_user_id(msg, blocks)
		
		if roles.is_bot_owner(msg.from.id) and msg.reply and not msg.cb then
			if msg.reply.forward_from then
				user_id = msg.reply.forward_from.id
			end
		end
		
		if not user_id then
			api.sendReply(msg, lang[msg.ln].bonus.no_user, true)
		 	return
		end
		-----------------------------------------------------------------------------
		
		local keyboard = do_keyboard_userinfo(user_id, msg.ln)
		
		local text = get_userinfo(user_id, msg.chat.id, msg.ln)
		
		api.sendKeyboard(msg.chat.id, text, keyboard, true)
	end
	if blocks[1] == 'banuser' then
		if not roles.is_admin_cached(msg) then
    		api.answerCallbackQuery(msg.cb_id, lang[msg.ln].not_mod:mEscape_hard())
    		return
		end
		
		local user_id = msg.target_id
		
		local res, text = api.banUser(msg.chat.id, user_id, msg.normal_group, msg.ln)
		if res then
			misc.saveBan(user_id, 'ban')
			local name = misc.getname_link(msg.from.first_name, msg.from.username) or msg.from.first_name:mEscape()
			text = lang[msg.ln].getban.banned..'\n(Admin: '..name..')'
		end
		api.editMessageText(msg.chat.id, msg.message_id, text, false, true)
	end
	if blocks[1] == 'unbanuser' then
		if not roles.is_admin_cached(msg) then
    		api.answerCallbackQuery(msg.cb_id, lang[msg.ln].not_mod:mEscape_hard())
    		return
		end
		
		local user_id = msg.target_id
		
		local res, text = api.unbanUser(msg.chat.id, user_id, msg.normal_group, msg.ln)
		if res then
			local name = misc.getname_link(msg.from.first_name, msg.from.username) or msg.from.first_name:mEscape()
			text = lang[msg.ln].getban.unbanned..'\n(Admin: '..name..')'
		end
		api.editMessageText(msg.chat.id, msg.message_id, text, false, true)
	end
	if blocks[1] == 'gbanuser' then
		local dev = msg.from.id == config.admin.owner
if not dev then
    		api.answerCallbackQuery(msg.cb_id, lang[msg.ln].not_dev:mEscape_hard())
    		return
		end
		
		local user_id = msg.target_id
		local text, chat_id = lang[msg.ln].getban.gbanned..'\n`(Desarrollador: '..msg.from.first_name:mEscape()..')`'
		
		local res = os.execute('perl -pi -e "s[gbans = \\{][gbans = {\n\t'..user_id..',]g" data/gbans.lua')
		local action_sucess = api.kickUser(msg.chat.id, user_id)
		if res and action_sucess and text then
			misc.saveBan(user_id, 'ban')
			bot_init(true)
			end
		api.editMessageText(msg.chat.id, msg.message_id, text, false, true)
	end
	if blocks[1] == 'ungbanuser' then
		local dev = msg.from.id == config.admin.owner
if not dev then
    		api.answerCallbackQuery(msg.cb_id, lang[msg.ln].not_dev:mEscape_hard())
    		return
		end
		
		local user_id = msg.target_id
		local text, chat_id = lang[msg.ln].getban.ungbanned..'\n`(Desarrollador: '..msg.from.first_name:mEscape()..')`'
		
		local res = os.execute('sed -i "/' ..user_id.. '/d" ./data/gbans.lua')
		local action_sucess = api.unbanUser(msg.chat.id, user_id, msg.normal_group, msg.ln)
		if res and action_sucess then
		bot_init(true)
		end
		api.editMessageText(msg.chat.id, msg.message_id, text, false, true)
	end
	if blocks[1] == 'blockuser' then
		if not roles.is_admin_cached(msg) then
    		api.answerCallbackQuery(msg.cb_id, lang[msg.ln].not_mod:mEscape_hard())
    		return
		end
		local id
		if not blocks[2] then
			if not msg.reply then
				api.sendReply(msg, 'Este comando necesita respuesta o alias')
				return
			else
				id = msg.reply.from.id
			end
		else
			id = blocks[2]
		end
		local response = db:sadd('bot:blocked', id)
		local text
		if response == 1 then
			text = id..' ha sido bloqueado, no podra interactuar con el bot'
		else
			text = id..' ya estaba bloqueado'
		end
		api.editMessageText(msg.chat.id, msg.message_id, text, false, true)
	end
	if blocks[1] == 'unblockuser' then
		if not roles.is_admin_cached(msg) then
    		api.answerCallbackQuery(msg.cb_id, lang[msg.ln].not_mod:mEscape_hard())
    		return
		end
		local id
		local response
		if not blocks[2] then
			if not msg.reply then
				api.sendReply(msg, 'This command need a reply')
				return
			else
				id = msg.reply.from.id
			end
		else
			id = blocks[2]
		end
		local response = db:srem('bot:blocked', id)
		local text
		if response == 1 then
			text = id..' ha sido desbloqueado, ahora podra interactuar con el bot'
		else
			text = id..' ya estaba bloqueado'
		end
		api.editMessageText(msg.chat.id, msg.message_id, text, false, true)
	end

	if blocks[1] == 'resolver' then
		if not roles.is_admin_cached(msg) then
    		api.answerCallbackQuery(msg.cb_id, lang[msg.ln].not_mod:mEscape_hard())
    		return
		end
		local resolver = res_usuario(blocks[2], msg.chat.id)
--		local resolve = res_user_group(blocks[2], msg.chat.id)
		if not resolver then
			message = lang[ln].bonus.no_user
		else
			message = '*'..resolver..'*'
		end
		api.editMessageText(msg.chat.id, msg.message_id, message, false, true)
--		api.sendMessage(msg.chat.id, message, true)
	end
	if blocks[1] == 'remwarns' then
		if not roles.is_admin_cached(msg) then
    		api.answerCallbackQuery(msg.cb_id, lang[msg.ln].not_mod:mEscape_hard())
    		return
		end
		db:hdel('chat:'..msg.chat.id..':warns', msg.target_id)
		db:hdel('chat:'..msg.chat.id..':mediawarn', msg.target_id)
        
        local name = misc.getname_link(msg.from.first_name, msg.from.username) or msg.from.first_name:mEscape()
        api.editMessageText(msg.chat.id, msg.message_id, lang[msg.ln].warn.nowarn..'\n(Admin: '..name..')', false, true)
    end
    if blocks[1] == 'cache' then
    	if msg.chat.type == 'private' or not roles.is_admin_cached(msg) then return end
    	local text
    	local hash = 'cache:chat:'..msg.chat.id..':admins'
    	if db:exists(hash) then
    		local seconds = db:ttl(hash)
    		local cached_admins = db:smembers(hash)
    		text = '📌 Status: `CACHED`\n⌛ ️Remaining: `'..get_time_remaining(tonumber(seconds))..'`\n👥 Admins cached: `'..#cached_admins..'`'
    	else
    		text = 'Status: NOT CACHED'
    	end
    	local keyboard = do_keyboard_cache(msg.chat.id)
    	api.sendKeyboard(msg.chat.id, text, keyboard, true)
    end
    if blocks[1] == 'msglink' then
    	if roles.is_admin_cached(msg) and msg.reply and msg.chat.username then
    		api.sendReply(msg, '[msg n° '..msg.reply.message_id..'](https://telegram.me/'..msg.chat.username..'/'..msg.reply.message_id..')', true)
    	end
    end
    if blocks[1] == 'cc:rel' and msg.cb then
    	if not roles.is_admin_cached(msg) then
			api.answerCallbackQuery(msg.cb_id, lang[msg.ln].not_mod:mEscape_hard()) return
		end
		local missing_sec = tonumber(db:ttl('cache:chat:'..msg.target_id..':admins') or 0)
		if (config.bot_settings.cache_time.adminlist - missing_sec) < 3600 then
			api.answerCallbackQuery(msg.cb_id, 'The adminlist has just been updated. This button will be available in an hour after the last update', true)
		else
    		local res = misc.cache_adminlist(msg.target_id)
    		if res then
    			local cached_admins = db:smembers('cache:chat:'..msg.target_id..':admins')
    			local time = get_time_remaining(config.bot_settings.cache_time.adminlist)
    			local text = '📌 Status: `CACHED`\n⌛ ️Remaining: `'..time..'`\n👥 Admins cached: `'..#cached_admins..'`'
    			api.answerCallbackQuery(msg.cb_id, '✅ Updated. Next update in '..time)
    			api.editMessageText(msg.chat.id, msg.message_id, text, do_keyboard_cache(msg.target_id), true)
    			api.sendLog('#recache\nChat: '..msg.target_id..'\nFrom: '..msg.from.id)
    		end
    	end
    end
end

return {
	action = action,
	triggers = {
		config.cmd..'(id)$',
		config.cmd..'(adminlist)$',
		config.cmd..'(status) (@[%w_]+)$',
		config.cmd..'(status) (%d+)$',
		config.cmd..'(welcome) (.*)$',
		config.cmd..'(welcome)$',
		config.cmd..'(cache)$',
		config.cmd..'(msglink)$',
		config.cmd..'(user)$',
		config.cmd..'(user) (.*)',	
		'^###cb:userbutton:(blockuser):(%d+)$',
	    '^###cb:userbutton:(unblockuser):(%d+)$',	
		'^###cb:userbutton:(gbanuser):(%d+)$',
		'^###cb:userbutton:(banuser):(%d+)$',
		'^###cb:userbutton:(ungbanuser):(%d+)$',
		'^###cb:userbutton:(unbanuser):(%d+)$',
		'^###cb:userbutton:(resolver):(%d+)$',
		'^###cb:userbutton:(remwarns):(%d+)$',
		'^###cb:(cc:rel):'
	}
}
