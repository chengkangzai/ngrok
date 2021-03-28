from core import Core, Postman

if __name__ == '__main__':
    if Core().isConnected():
        ngrokStatus = Core.getNgrok()
        vpnIp = Core().checkVpnIP()
        if ngrokStatus:
            Postman(ngrokStatus, 'HeartBeat') \
                .sendDiscord() \
                .sendWebServer(vpnIp) \
                # .sendEmail()
