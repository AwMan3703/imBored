import discord
from discord.ext import commands
import python_aternos as pyat

#setup bot/client stuff
bot_intents = discord.Intents.default()
bot_intents.guilds = True
bot_intents.guild_messages = True
bot_intents.message_content = True
client = discord.Client(intents=bot_intents)
prefix = '-'

#setup python aternos stuff
aternos_data = {
    'username' : 'Aw_Man3703_ALT2',
    'password_hash' : '3d3caabe1b5553bb5050e96e6990ec65'
}
aternos = pyat.Client.from_hashed(aternos_data['username'], aternos_data['password_hash'])
server_list = aternos.list_servers()

#events response
@client.event
async def on_ready():
    print('Bot logged in as {0.user}'.format(client))

@client.event
async def on_message(message:discord.Message):
    print('> Message received:')
    print('   ', message.content)

    if message.author == client.user:
        print('    self message (ignored)')
        return

    if not message.content.startswith(prefix):
        print('    not a command')
        return

    print('    command recognized')
    words = message.content[1:].split(" ")
    words = list(filter(lambda x: x!="", words))
    command = words[0]
    args = words[1:]
    match command:
        case "hi":
            await message.reply('hello :D')
        case "start":
            if args == []:
                await message.reply('Please specify a server to start. (logged in as '+aternos_data['username']+')')
                return

            matching = list(filter(lambda x: x.subdomain==args[0], server_list))
            if matching == []:
                await message.reply('No matching server found. (logged in as '+aternos_data['username']+')')
                return

            server = matching[0]
            await message.reply('''Found matching server:
            Address: {d} (port {p})
            Software: {s} {v}
            Status: {c}
            '''.format(
                d = server.domain,
                p = server.port,
                s = server.software,
                v = server.version,
                c = server.status
            ))
            try:
                server.start(accepteula=True)
                await message.reply("[[ SERVER STARTING NOW ]]")
            except pyat.ServerStartError as err:
                await message.reply(err.MESSAGE)  # Server is already running
        case "info":
            pass
            #provide info on server
            

#start the thing
client.run("MTA4MjU2MzY2MzAzMTk3NTk3Ng.Gn8jZE.Ut_Ass2SkGqetl3D1FjOhsbFbFRDuOsrAYudgA")
