
-module(tests).

-include("constants.hrl").

%% API
-export([
         send_packet/0
        ]).
                               

         
send_packet() ->
    
    {ok, Socket} = gen_tcp:connect("localhost", ?TCP_LISTEN_PORT, [binary, {active, false}, {packet, raw}]),
    lager:info("Connected, socket: ~p", [Socket]),

    UdpAddr = "127.0.0.1:35000",
    Len = length(UdpAddr),

    Header = <<Len:?SIZE_FIELD_BITS, ?DEST_ADDR_TYPE:?PACKET_TYPE_FIELD_BITS>>,
    Data =  list_to_binary(UdpAddr),

    lager:info("Header:~p Data:~p", [Header, Data]),
    Packet = <<Header/binary, Data/binary>>,

    ok = gen_tcp:send(Socket, Packet),
    lager:info("Has sended string: ~p", [Packet]),

    gen_tcp:close(Socket),
    {error, closed} = gen_tcp:recv(Socket, 0, 1000),
    ok.

