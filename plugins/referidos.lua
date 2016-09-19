local action = function(msg, matches, blocks, ln)
    
if not(msg.chat.type == 'private') and not roles.is_admin(msg) then         

    if db:hget('chat:'..msg.chat.id..':settings', 'referidos') == 'disable' then
    local id = msg.from.id
    local name = msg.from.first_name
    if msg.from.username then
        name = name..' @'..msg.from.username
end
     action_sucess = api.banUser(msg.chat.id, msg.from.id)
     if action_sucess then
     api.sendMessage(msg.chat.id, name.. ' ('..id.. ') ha sido *banead@* por hacer enviar referidos de compra 🔨\n\n🔸 `Informe enviado al administrador` ', true)
     misc.forwardToAdmins(msg.chat.id, msg.message_id)
     misc.sendMessageToAdmins(msg.chat.id, '👆 REFERIDO en el grupo: ➡️ *'..msg.chat.title..'*')
            end
        end
    end
end


 return {
    action = action,
    triggers = {
                "[Aa][Mm][Zz][Nn]%.[Tt][Oo]"
                }
}
