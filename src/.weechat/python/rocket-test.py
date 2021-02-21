#!/home/mmnanz/.pyenv/versions/wee-rocketchat/bin/python
import json
import asyncio
import requests
import websockets
import weechat

rhost = ""
ruser = ""
rpass = ""
session = ""
rooms   = ""
authToken = ""

weechat.register(
      "wee-rocketchat"
    , "Max Audron"
    , "0.1.0"
    , "MIT"
    , "weechat client for rocketchat"
    , ""
    , "")

async def login(websocket):
    loginmsg = json.dumps(
        { "msg": "method" 
        , "method": "login"
        , "id":"12074"
        , "params": [{ "resume": authToken }]
        })
    await websocket.send(loginmsg)

async def getRooms(websocket):
    await websocket.send(json.dumps(
        { "msg": "method"
        , "method": "rooms/get"
        , "id": "42"
        , "params": [ { "$date": 1480377601 } ]
        }))

async def subscribeRoom(websocket, roomId):
    await websocket.send(json.dumps(
        { "msg": "sub"
        , "id": roomId
        , "name": "stream-room-messages"
        , "params":[ roomId, False ]
        }
        ))

async def main():
    rhost = ""
    ruser = ""
    rpass = ""
    session = ""
    rooms   = ""
    authToken = ""

    if weechat.config_is_set_plugin("host"):
        rhost = weechat.config_get_plugin("host")
    else:
        no_conf()
    if weechat.config_is_set_plugin("authToken"):
        authToken = weechat.config_get_plugin("authToken")
    else:
        no_conf()

    if rhost is not "" and authToken is not "":
        # create buffer
        rbuffer = weechat.buffer_new(rhost if rhost is not "" else "rocketchat", "", "", "", "")

        # set title
        weechat.buffer_set(rbuffer, "title", "Rocket.Chat main buffer")

        # disable logging, by setting local variable "no_log" to "1"
        weechat.buffer_set(rbuffer, "localvar_set_no_log", "1")

        print(rhost, authToken)
        async with websockets.connect( 'wss://' + rhost + "/websocket", ssl=True ) as websocket:
            connmsg = json.dumps({ "msg": "connect" , "version": "1" , "support": ["1"] })

            await websocket.send(connmsg)
            weechat.prnt("", f"> {connmsg}")
            #greeting = await websocket.recv()
            #weechat.prnt(f"< {greeting}")

            loginmsg = json.dumps(
                    { "msg": "method" 
                    , "method": "login"
                    , "id":"12074"
                    , "params": [{ "resume": auth }]
                    })

            await websocket.send(loginmsg)
            weechat.prnt("", f"> {loginmsg}")
            async for message in websocket:
                weechat.prnt("", message)
                jmsg = json.loads(message)
                if 'server_id' in jmsg:
                    connmsg = json.dumps({ "msg": "connect" , "version": "1" , "support": ["1"] })

                if 'msg' in jmsg:
                    if jmsg['msg'] == 'ping':
                        await websocket.send(json.dumps({"msg": "pong"}))
                    if jmsg['msg'] == 'connected':
                        session = jmsg['session']
                        await login(websocket)
                        await getRooms(websocket)
                    if 'id' in jmsg and jmsg['id'] == "42":
                        rooms = jmsg['result']['update']
                        for i in rooms:
                            await subscribeRoom(websocket, i['_id'])
    else:
        no_conf()

def init():
    if weechat.config_is_set_plugin("host"):
        rhost = weechat.config_get_plugin("host")
    else:
        no_conf()
    if weechat.config_is_set_plugin("authToken"):
        authToken = weechat.config_get_plugin("authToken")
    else:
        no_conf()

    # create buffer
    rbuffer = weechat.buffer_new(rhost if rhost is not "" else "rocketchat", "", "", "", "")

    # set title
    weechat.buffer_set(rbuffer, "title", "Rocket.Chat main buffer")

    # disable logging, by setting local variable "no_log" to "1"
    weechat.buffer_set(rbuffer, "localvar_set_no_log", "1")


def no_conf():
    weechat.prnt("", "rocketchat is not set up please set up now using /rocket [host] [user] [password]. The user and password will not be stored but an api key will so you may want to not include plugins.conf in any git repos or so.")

def rocket_command(data, buffer, r):
    weechat.prnt("", r)
    cmds = r.split()
    weechat.prnt("", str(cmds))
    if cmds[0] == "login":
        weechat.prnt("", "logging in...")
        authToken = getLoginToken(cmds[1], cmds[2], cmds[3])
        weechat.config_set_plugin("host", cmds[1])
        weechat.config_set_plugin("authToken", authToken)
        weechat.prnt("", "login successfull")
        init()
    else:
        weechat.prnt("", "command not found")
    return weechat.WEECHAT_RC_OK

hook = weechat.hook_command("rocket", "command to change settings for rocketchat",
    "[list] | [enable|disable|toggle [name]] | [add name plugin.buffer tags regex] | [del name|-all]",
    "description of arguments...",
    "list"
    " || login %(filters_names)",
    "rocket_command", "")

def getLoginToken(host, user, passw):
    res = requests.post( 'https://' + host + '/api/v1/login'
                       , data={'user': user, 'password': passw}
                       )
    
    if res.json()['status'] == 'success':
        return res.json()['data']['authToken']
    else:
        weechat.prnt("", "couldn't login")


asyncio.get_event_loop().run_until_complete(main())
