local discordia = require 'discordia'
local client = discordia.Client()
local powerID = 'IDcargo' --coloque o id do cargo do MUTADOR aqui
local modID = 'modID' --coloque algum cargo de adm aqui, para que ele possa alterar o poder dos outros
local token = "tokenBOT"

local g = client:getGuild 'IDservidor' --coloque o id do servidor aqui

local p = {}
local c = {
  fortalecer = {'user', ('dá força para uma pessoa do cargo <@&%s>'):format(powerID), 
    function(m, id)
      local id = id
      if id:find('%<%@%d+%>') then
        id = id:gsub('%<%@', ''):gsub('%>', '')
      end
      if m.guild:getMember(id):hasRole(powerID) and (m.guild:getMember(m.author.id):hasRole(modID) or m.guild:getMember(m.author.id):hasRole(powerID)) then
        p[id] = (p[id] or 0)+1
        m:reply {
          embed = {
            description = ('Você ganhou mais força, <@%s>. Sua força agora é de %s pontos!'):format(id, p[id]),
            author = {
              name = m.guild:getMember(id).username,
              icon_url = m.guild:getMember(id).avatarURL
            },
            color = 0xDC143C
          }
        }
      elseif m.guild:getMember(id):hasRole(powerID) then
        m:reply('Esse golpe você não sabe usar, caçador!')
      else
        m:reply(':wolf: Você está tentando dar força para quem não é um caçador?')
      end
    end
  },
  golpe = {'vezes user', 'usa sua força para mutar uma pessoa',
    function(m, n, id)
      local id = id
      local n = n
      local z = m.author.id
      if n:find('%<%@%d+%>') then
        id = n:gsub('%<%@', ''):gsub('%>', '')
        n = p[z]
      end
      if m.guild:getMember(id) == nil then
        m:reply('Quê?! Quem você vai atacar? :crossed_swords:')
        return
      end
      if id:find('%<%@%d+%>') then
        id = id:gsub('%<%@', ''):gsub('%>', '')
      end
      if p[z] and (p[z] >= tonumber(n) and p[z] >= 1) then
        m:reply {
          embed = {
            description = ('Você atacou o <@%s> %s vez(es)! Ele não podera falar por %s hora(s)!'):format(id, n, n),
            author = {
              name = m.guild:getMember(z).username,
              icon_url = m.guild:getMember(z).avatarURL
            },
            color = 0xDC143C
          }
        }
        m.guild:getMember(id):timeoutFor(3600*n)
        p[z] = (p[z] or 1)-n
      elseif p[z] then
        m:reply {
          embed = {
            description = ('Você não está forte o bastante para atacar o <@%s>.'):format(id),
            author = {
              name = m.guild:getMember(z).username,
              icon_url = m.guild:getMember(z).avatarURL
            },
            color = 0xDC143C
          }
        }
      else
        m:reply {
          embed = {
            description = ('Você não tem força nenhuma, <@%s>.'):format(z),
            author = {
              name = m.guild:getMember(z).username,
              icon_url = m.guild:getMember(z).avatarURL
            },
            color = 0xDC143C
          }
        }
      end
    end
  },
  pontos = {'', 'verifica a quantidades de pontos que você tem',
    function(m)
      m:reply {
        embed = {
          description = ('Você pode atacar %s vezes.'):format(p[m.author.id] or 0),
          author = {
            name = m.guild:getMember(m.author.id).username,
            icon_url = m.guild:getMember(m.author.id).avatarURL
          },
          color = 0xDC143C
        }
      }
    end 
  }
}

local h = '✪ **Ajuda** ✪\nTodos os comandos começam com `$`\n'

for k, v in next, c do
  h = h..'\n'..k..(v[1]=='' and '' or ' `'..v[1]..'`')..' ➳ '..v[2]
end


setmetatable(c, {__index = function(x)
   return {1, 1, function(x) x:reply('Caçador? Esse comando nem existe. Use `$help` para ver os que existem.') end}
end})

local normalizeC = function(s)
  local t = {}
  local tc
  for w in s:gmatch("%S+") do
    if not tc then
      tc = w:gsub('%$', '')
    else
      t[#t+1] = w
    end
  end
  return tc, t
end

client:on('messageCreate', function(message)
  local m = message.content
  if m == '$help' then
    message:reply {
      embed = {
        description = h,
        author = {
          name = message.guild:getMember(message.author.id).username,
          icon_url = message.guild:getMember(message.author.id).avatarURL
        },
        color = 0xDC143C
      }
    }
  elseif m:sub(1, 1) == '$' then
    local x, d = normalizeC(m)
    x = x:lower()
    local s, r = pcall(function() c[x][3](message, table.unpack(d)) end)
    if not s then
      message:reply(('Querido caçador, você encontrou um bug! O código: `%s`'):format(r))
    end
  end
end)

client:run("Bot "..token)
