local action = function(msg, matches, ln)
	if msg.reply then
    api.sendMessage(msg.chat.id, matches[1], 1, msg.reply.message_id)
	else 
	api.sendMessage(msg.chat.id, matches[1], 1)
	end
end

return {
	action = action,
	triggers = {
		'^[!#/][Dd]i (.*)$'
	}
}
