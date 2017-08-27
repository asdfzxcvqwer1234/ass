-- Start TabchiBot
local sudomsg = 282958812 -- put your id here 
local function reload_plugins( )
  plugins = {}
  load_plugins()
end

function save_config( )
  serialize_to_file(_config, './data/config.lua')
  print ('saved config into ./data/config.lua')
end

local function parsed_url(link)
  local parsed_link = URL.parse(link)
  local parsed_path = URL.parse_path(parsed_link.path)
  return parsed_path[2]
end


function sleep(n)
  os.execute("sleep" .. tonumber(n))
end

    if msg.media.caption:match("(https://telegram.me/joinchat/%S+)") and redis:get("bot:autojoin") == "on" then
      local link = {msg.media.caption:match("(https://telegram.me/joinchat/%S+)")} 
      if string.len(link[1]) == 51 then
        redis:sadd("selfbot:links",link[1])
        import_chat_link(parsed_url(link[1]),ok_cb,false)
      end
    end
	if msg.media.caption:match("(https://t.me/joinchat/%S+)") and redis:get("bot:autojoin") == "on" then
      local link = {msg.media.caption:match("(https://t.me/joinchat/%S+)")}
      if string.len(link[1]) == 44 then
        redis:sadd("selfbot:links",link[1])
        import_chat_link(parsed_url(link[1]),ok_cb,false)
      end
    end
	if msg.media.caption:match("(https://telegram.dog/joinchat/%S+)") and redis:get("bot:autojoin") == "on" then
      local link = {msg.media.caption:match("(https://telegram.dog/joinchat/%S+)")}
      if string.len(link[1]) == 52 then
        redis:sadd("selfbot:links",link[1])
        import_chat_link(parsed_url(link[1]),ok_cb,false)
      end
    end
  end
end

function reset_stats()
  redis:set("pv:msgs",0)
  redis:set("gp:msgs",0)
  redis:set("supergp:msgs",0)
  redis:del("selfbot:groups")
  redis:del("selfbot:users")
  redis:del("selfbot:supergroups")
end

function broad_cast(text)
local gps = redis:smembers("selfbot:groups")
local sgps = redis:smembers("selfbot:supergroups")
local users = redis:smembers("selfbot:users")
  for i=1, #gps do
    send_large_msg(gps[i],text,ok_cb,false)
  end
  for i=1, #sgps do
    send_large_msg(sgps[i],text,ok_cb,false)
  end
  for i=1, #users do
    send_large_msg(users[i],text,ok_cb,false)
  end
end

function broad_castpv(text)
local users = redis:smembers("selfbot:users")
for i=1, #users do
    send_large_msg(users[i],text,ok_cb,false)
  end
end

function broad_castgp(text)
local gps = redis:smembers("selfbot:groups")
for i=1, #gps do
    send_large_msg(gps[i],text,ok_cb,false)
  end
end
function broad_castsgp(text)
local sgps = redis:smembers("selfbot:supergroups")
 for i=1, #sgps do
    send_large_msg(sgps[i],text,ok_cb,false)
  end
end

function run_bash(str)
  local cmd = io.popen(str)
  local result = cmd:read('*all')
  cmd:close()
  return result
end

end
if matches[1] == "autojoin" and is_sudo(msg) then
if matches[2] == "on" then
redis:set("bot:autojoin", "on")
return "جوین خودکار فعال شد"
end
if matches[2] == "off" then
redis:set("bot:autojoin", "off")
return "جوین خودکار غیرفعال شد"
end
end
if matches[1] == "addedmsg" and is_sudo(msg) then
if matches[2] == "on" then
redis:set("bot:addedmsg", "on")
return 'پیام اضافه شدن کانتکت فعال شد'
end
if matches[2] == "off" then
redis:set("bot:addedmsg", "off")
return'پیام اضافه شدن کانتکت غیرفعال شد'
end
if matches[1] == "addcontacts" and is_sudo(msg) then
if matches[2] == "on" then
redis:set("bot:addcontacts", "on")
return 'اضافه شدن کانتکت فعال شد'
end
end
if matches[1]== "help" and is_sudo(msg) then
local text =[[
➣➣TabchiHelp By @LuaError
<code>---------------------------------</code>
<b>─═हई Brodcast Help ईह═─</b>
<code>》!pm [Id] [Text]</code>
<i>ارسال پیام به ایدی موردنظر</i>
<code>》!bcpv [text]</code>
<i>ارسال پیغام همگانی به پیوی</i>
<code>》!bcgp [text]</code>
<i>ارسال پیغام همگانی به گروه ها</i>
<code>》!bcsgp [text]</code>
<i>ارسال پیغام همگانی به سوپرگروها</i>
<code>》!bc [text]</code>
<i>ارسال پیغام همگانی</i>
<code>》!fwdpv {reply on msg}</code>
<i>ارسال به پیوی کاربران</i>
<code>》!fwdgp {reply on msg}</code>
<i>ارسال به گروه ها</i>
<code>》!fwdsgp {reply on msg}</code>
<i>ارسال به سوپرگروها</i>
<code>》!fwdall {reply on msg}</code>
<i>فوروارد همگانی </i>
<code>---------------------------------</code>
<b>─═हई User Help ईह═─</b>
<code>》!block [Id]</code>
<i>بلاک کردن فرد مورد نظر</i>
<code>》!unblock [id]</code>
<i>انبلاک کردن فرد مور نظر</i>
<code>---------------------------------</code>
<b>─═हई Contacts Help  ईह═─</b>
<code>》!addcontact [phone] [FirstName][LastName]</code>
<i>اضافه کردن یک کانتکت</i>
<code>》!delcontact [phone] [FirstName][LastName]</code>
<i>حذف کردن یک کانتکت</i>
<code>》!sendcontact [phone] [FirstName][LastName]</code>
<i>ارسال یک کانتکت</i>
<code>》!contactlist</code>
<i>دریافت لیست کانتکت ها</i>
<code>---------------------------------</code>
<b>─═हई  Settings Help ईह═─</b>
<code>》!autojoin [on][off]</code> 
<i>خاموش و روشن شدن جوین دادن تبچی</i>
<code>》!addedmsg [on][off]</code>
<i>خاموش وروشن کردن پیام اد کانتکت</i>
<code>》!addcontacts [on][off]</code>
<i>خاموش و روشن کردن اد شدن اکانت</i>
<code>》!settext [text]</code>
<i>تنظیم پیام ادشدن کانتکت</i>
<code>---------------------------------</code>
<b>─═हई Sudo Help ईह═─</b>
<code>》!reload</code>
<i>ریلود کردن ربات</i>
<code>》!addsudo [id]</code>
<i>اضافه کردن سودو</i>
<code>》!remsudo [id]</code>
<i>اضافه کردن سودو</i>
<code>》!serverinfo</code>
<i>نمایش وضعیت سورس</i>
<code>---------------------------------</code>
<b>─═हई Robot Advanced Help ईह═─</b>
<code>》!markread [on]/[off]</code>
<i>روشن و خاموش کردن تیک مارک رید</i>
<code>》!setphoto {on reply photo}</code>
<i>ست کردن پروفایل ربات</i>
<code>》!stats</code>
<i>دریافت آمار ربات</i>
<code>》!addmember</code>
<i>اضافه کردن کانتکت های ربات به گروه</i>
<code>》!echo [text]</code>
<i>برگرداندن نوشته</i>
<code>》!export links</code>
<i>دریافت لینک های ذخیره شده</i>
<code>》!addtoall [id]</code>
<i>اضافه کردن مخاطب به گروها</i>
<code>》!reset stats</code>
<i>ریست کردن امار ربات</i>
<code>》!leave </code>
<i>لفت دادن ربات ازگروه جاری</i>
<code>》!leave [id]</code>
<i>لفت دادن ربات ازگروه موردنظر</i>
<code>》!leaveall</code>
<i>لفت دادن ربات ازتمامی گروها</i>
<code>》!myinfo</code>
<i>دریافت اطلاعات</i>
<code>---------------------------------</code>
PowerBy 》@LuaError 
]]
return text
end
  if matches[1] == "setphoto" and msg.reply_id and is_sudo(msg) then
   load_photo(msg.reply_id, set_bot_photo, receiver)
  end
  if matches[1] == "markread" then
    if matches[2] == "on" and is_sudo(msg) then
      redis:set("bot:markread", "on")
      return "Mark read > on"
    end
    if matches[2] == "off" and is_sudo(msg) then
      redis:del("bot:markread")
      return "Mark read > off"
    end
    return
  end
  if matches[1] == "lua" and is_sudo(msg) then
    return lua(matches[2])
  end
  if matches[1] == "echo" and is_sudo(msg) then
    return matches[2]
  end
  if msg.text:match("https://telegram.me/joinchat/%S+") and redis:get("bot:autojoin") == "on" then
    if string.len(matches[1]) == 51 and not redis:sismember("selfbot:links",matches[1]) then
      redis:sadd("selfbot:links",matches[1])
      import_chat_link(parsed_url(matches[1]),ok_cb,false)
    end
  end
  if  msg.text:match("https://t.me/joinchat/%S+") and redis:get("bot:autojoin") == "on" then
    if string.len(matches[1]) == 44 and not redis:sismember("selfbot:links",matches[1]) then
      redis:sadd("selfbot:links",matches[1])
      import_chat_link(parsed_url(matches[1]),ok_cb,false)
    end
  end
  if  msg.text:match("https://telegram.dog/joinchat/%S+") and  redis:get("bot:autojoin") == "on" then
    if string.len(matches[1]) == 52 and not redis:sismember("selfbot:links",matches[1]) then
      redis:sadd("selfbot:links",matches[1])
      import_chat_link(parsed_url(matches[1]),ok_cb,false)
    end
  end
  if matches[1] == 'addsudo' then
if msg.from.id and msg.from.id == tonumber(sudomsg) then
table.insert(_config.sudo_users,tonumber(matches[2]))
    print(matches[2]..' added to sudo users')
    save_config()
  reload_plugins(true)
  return "کاربر "..matches[2].."به لیست سودو ها اضافه شد"
  else
  return "خطا"
  end
  end
  
  if matches[1] == 'remsudo' then
if msg.from.id and msg.from.id == tonumber(sudomsg) then
 table.remove(_config.sudo_users, getindex( _config.sudo_users, tonumber(msg.to.id)))
    print(matches[2]..' remove to sudo users')
    save_config()
  reload_plugins(true)
  return "کاربر"..matches[2].."از لیست سودو ها خارج شد"
  else
  return "خطا"
  end
  end
if matches[1]== "serverinfo" and is_sudo(msg) then
local text = io.popen("sh ./data/cmd.sh"):read('*all')
  return text
end
  if matches[1]== "addtoall" and is_sudo(msg) then
  if redis:get("timeaddtoall:"..msg.to.id) then
    return "<i>این کار فقط هر روز یکبار ممکن میباشد بعد از یک روز دوباره امتحان کنید</i>"
    end
	redis:setex("timeaddtoall:"..msg.to.id,86400,true)
  local sgps = redis:smembers("selfbot:supergroups")
    for i=1, #sgps do
     channel_invite(sgps[i],matches[2],ok_cb,false)
    end
  return"کاربر "..matches[2].." به همه گروه های ربات اضافه شد\n SuperGroup Stats 》" ..#sgps.. "》"
  end 
  
end
return {
patterns = {
  "^[#!/](pm) (%d+) (.*)$",
  "^[#!/](unblock) (%d+)$",
  "^[#!/](block) (%d+)$",
  "^[#!/](markread) (on)$",
  "^[#!/](markread) (off)$",
  "^[#!/](setphoto)$",
  "^[#!/](contactlist)$",
  "^[#!/](addmember)$",
  "^[#!/](stats)$",
  "^[#!/](settings)$",
  "^[#!/](delcontact) (%d+)$",
  "^[#!/](addcontact) (.*) (.*) (.*)$", 
  "^[#!/](sendcontact) (.*) (.*) (.*)$",
  "^[#!/](echo) (.*)$",
  "^[#!/](export) (links)$",
  "^[#!/](bc) (.*)$",
  "^[#!/](bcpv) (.*)$",
  "^[#!/](bcgp) (.*)$",
  "^[#!/](bcsgp) (.*)$",
  "^[#!/](fwdall)$",
  "^[#!/](fwdpv)$",
  "^[#!/](fwdgp)$",
  "^[#!/](fwdsgp)$",
  "^[!/#](lua) (.*)$",
  "^[!/#](settext) (.*)$",
  "^[!/#](text)$",
  "^[!/#](help)$",
  "^[!/#](addsudo) (.*)$",
  "^[!/#](remsudo) (.*)$",
  "^[!/#](serverinfo)$",
  "^[!/#](addtoall) (.*)$",
  "^[!/#](leave) (.*)$",  
  "^[!/#](leave)$",  
  "^[!/#](myinfo)$",  
  "^[!/#](reset stats)$",
  "^[!/#](leaveall)$",
  "^[!/#](autojoin) (.*)$",
  "^[!/#](addedmsg) (.*)$",
  "^[!/#](addcontacts) (.*)$",  
  "(https://telegram.me/joinchat/%S+)",
  "(https://t.me/joinchat/%S+)",
  "(https://telegram.dog/joinchat/%S+)",
  "^[$](.*)$",
  "%[(photo)%]"
},
run = run,
pre_process = pre_process
}
--@LuaError
--@Tele_Sudo
