#!/home/mmnanz/.pyenv/versions/wee-rocketchat/bin/python
import json
import requests
import websocket
from threading import Thread
import time
import weechat

rhost = ""
ruser = ""
rpass = ""
rbuffer = ""
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

def no_conf():
    weechat.prnt("", "rocketchat is not set up please set up now using /rocket [host] [user] [password]. The user and password will not be stored but an api key will so you may want to not include plugins.conf in any git repos or so.")

def Login(ws):
    ws.send(json.dumps(
        { "msg": "method" 
        , "method": "login"
        , "id":"12074"
        , "params": [{ "resume": authToken }]
        }))

def getRooms(ws):
    ws.send(json.dumps(
        { "msg": "method"
        , "method": "rooms/get"
        , "id": "42"
        , "params": [ { "$date": 1480377601 } ]
        }))

def subscribeRoom(ws, roomId):
    ws.send(json.dumps(
        { "msg": "sub"
        , "id": roomId
        , "name": "stream-room-messages"
        , "params":[ roomId, False ]
        }
        ))

def on_message(ws, message):
    jmsg = json.loads(message)
    #weechat.prnt(rbuffer, str(jmsg))
    if 'msg' in jmsg:
        if jmsg['msg'] == 'ping':
           ws.send(json.dumps({"msg": "pong"}))
        if jmsg['msg'] == 'connected':
           session = jmsg['session']
           login(ws)
           getRooms(ws)
        if 'id' in jmsg and jmsg['id'] == "42":
           rooms = jmsg['result']['update']
           for i in rooms:
               subscribeRoom(ws, i['_id'])

def on_error(ws, error):
    print(error)

def on_close(ws):
    print("### closed ###")

def on_open(ws):
    def run (*args):
        ws.send(json.dumps({ "msg": "connect" , "version": "1" , "support": ["1"] }))
    Thread(target=run).start()

if __name__ == "__main__":
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

        #w.hook_fd(ws.sock._sock.fileno(), 1, 0, 0, "receive_ws_callback", self.get_team_hash())
        ws = websocket.WebSocketApp("wss://" + rhost + "/websocket",
                                  on_message = on_message,
                                  on_error = on_error,
                                  on_close = on_close)
        ws.on_open = on_open
        ws.run_forever()
    else:
        no_conf()


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

