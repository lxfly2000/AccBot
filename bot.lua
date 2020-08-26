--encoding:utf-8
--必须使用 UTF8 不带 BOM 头的编码

Info={}
Info.name="AccBot"
Info.author="lxfly2000"
Info.version="1.0"
Info.description="AccBot (Github: https://github.com/lxfly2000/AccBot"

--获得bot对象
dofile("account.lua")
bot = Bot(qq,password)

--登录bot
bot:login()

--参数：http https ftp 或空
function get_local_ip(protocol)
	local nis=luajava.bindClass("java.net.NetworkInterface"):getNetworkInterfaces()
	local ips="本机IP:"
	while nis:hasMoreElements() do
		local ni=nis:nextElement()
		local addr=ni:getInetAddresses()
		while addr:hasMoreElements() do
			local ip=addr:nextElement()
			local ip_str=ip:getHostAddress()
			if protocol~=nil and protocol~="" then
				local per_mark=ip_str:find("%%")
				if per_mark~=nil then
					ip_str=ip_str:sub(1,per_mark-1)
				end
				if ip_str:find(":")~=nil then--IPv6
					ip_str="["..ip_str.."]"
				end
				ip_str=protocol.."://"..ip_str
			end
			ips=ips.."\n"..ip_str
		end
	end
	return ips
end

function process_msg_ip(msg, sender)
	local protocol=msg:sub(4,-1)
	protocol=protocol:sub(1,(protocol:find(" ")or 0)-1)
	sender:sendMsg(get_local_ip(protocol))
end

function process_msg_echo(msg, sender)
	if msg=="echo" then
		sender:sendMsg("echo 命令：\necho <消息>")
	else
		sender:sendMsg(msg:sub(6,-1))
	end
end

function process_msg_atme(msg,sender)
	sender:sendMsg(At(sender).."可用命令：\nip\necho")
end

function process_msg(msg, sender)
	if msg=="ip" or msg:sub(1,3)=="ip " then
		process_msg_ip(msg,sender)
	elseif msg=="echo" or msg:sub(1,5)=="echo " then
		process_msg_echo(msg,sender)
	elseif msg==At(bot.selfQQ) then
		process_msg_atme(msg,sender)
	end
end

-- 订阅好友消息并回复相同的内容
bot:subscribeFriendMsg(function(bot, msg, sender)
	process_msg(msg,sender)
end)

bot:subscribeGroupMsg(function(bot, msg, group, sender)
	process_msg(msg,group)
end)