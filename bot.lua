--encoding:utf-8
--必须使用 UTF8 不带 BOM 头的编码

Info={}
Info.name="AccBot"
Info.author="lxfly2000"
Info.version="1.0"
Info.description="AccBot (Github: https://github.com/lxfly2000/AccBot"

--获得bot对象
dofile("account.lua")
bot = Bot(qq,password,{protocol="ANDROID_PHONE",fileBasedDeviceInfo="device.json"})

--登录bot
bot:login()

at_reg="%[mirai:at:"..bot.id..",@.*%]"--注意Lua中的正则转义字符是'%'而不是'\'

function is_at_me(msg)
	return msg:match(at_reg)~=nil
end

function remove_at_me(msg)
	local remove_at_reg=at_reg.." ?"
	return msg:gsub(remove_at_reg,"")
end

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

function process_msg_ip(msg, group, sender)
	if is_at_me(msg) then
		msg=remove_at_me(msg)
	end
	local protocol=msg:sub(4,-1)
	protocol=protocol:gsub(" .*","")
	if group==nil then
		sender:sendMessage(get_local_ip(protocol))
	else
		bot:getFriend(sender.id):sendMessage(get_local_ip(protocol))
	end
end

function process_msg_echo(msg, group, sender)
	if is_at_me(msg) then
		msg=remove_at_me(msg)
	end
	if msg=="echo" then
		(group or sender):sendMessage("echo 命令：\necho <消息>")
	else
		(group or sender):sendMessage(msg:sub(6,-1))
	end
end

function process_msg_atme(msg, group, sender)
	(group or sender):sendMessage("可用命令：\nip\necho")
end

function process_msg(msg, group, sender)
	local flag_is_at_me=is_at_me(msg)
	if flag_is_at_me then
		msg=remove_at_me(msg)
	end
	if msg=="ip" or msg:sub(1,3)=="ip " then
		process_msg_ip(msg, group, sender)
	elseif msg=="echo" or msg:sub(1,5)=="echo " then
		process_msg_echo(msg, group, sender)
	elseif flag_is_at_me then
		process_msg_atme(msg, group, sender)
	end
end

-- 订阅好友消息并回复相同的内容
bot:subscribe("FriendMessageEvent",function(event)
	process_msg(event.message, nil, event.sender)
end)

bot:subscribe("GroupMessageEvent",function(event)
	process_msg(event.message, event.group, event.sender)
end)
