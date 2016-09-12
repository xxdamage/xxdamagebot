local action = function(msg, matches, blocks, ln)
 if msg.reply then
  if roles.is_admin(msg) then
   api.editMessageText(msg.chat.id, msg.reply.message_id, matches[1])
else 
	api.sendReply(msg, '🚫 *no tienes poderes para hacer eso :)*', true)
	api.sendAudio(msg.chat.id, './archivos/audio/haha.ogg')
  end
 end
end
    
return {
 action = action,
 triggers = {
  '^[!#/]edit (.*)',
 }
}

--edita los mensajes del bot by reply
