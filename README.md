## 🧠 *muteGameBot*

> *"Um bot do Discord que dá poder de **mute** pra quem **farma** no servidor..."*  
> sim, a ideia é ruim, mas um maluco me pediu pra fazer — então tá aí 😅

Esse bot foi feito com **Lua + Luvit**, e tem um propósito:<br> 
dar **permissões administrativas de mute** para usuários que atingem certos **níveis de farming** dentro do servidor do Discord.

### 📦 O que ele faz?

- Conecta ao Discord via token.
- Monitora mensagens dos usuários.
- Aumenta um contador de "farm" por usuário.
- Quando alguém alcança um certo número de mensagens (`mutePowerLevel`), essa pessoa **ganha poder de silenciar outros membros** (através de um cargo específico).
- Esse cargo permite que ele use comandos como `!mute @alvo`, aplicando o `mutedRole` na vítima.
- Suporte a comando `!score` pra checar sua pontuação atual.

> **Nota:** ele não dá mute diretamente — ele **dá o poder de mutar**. Então, basicamente, o bot recompensa spam com opressão 🤖

### ⚙️ Como rodar (com Luvit)

Requisitos:

- [Luvit](https://luvit.io) instalado (`luvit` e `luvi` no PATH)
- Token do seu bot Discord
- E a seguinte dependências:

   ```bash
   lit install SinisterRectus/discordia
   ```

4. Rode com Luvit:

   ```bash
   luvit init.lua
   ```

---

### 🔐 Permissões

O bot precisa de permissões para:

- Gerenciar Cargos
- Ver Canais
- Ler e Enviar Mensagens

E o servidor precisa de um cargo que permita aplicar o mute (você define qual cargo no script).
