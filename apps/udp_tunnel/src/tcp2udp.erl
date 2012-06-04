-module(tcp2udp).
-export([start_link/4, init/4]).
-include("constants.hrl").

start_link(ListenerPid, Socket, Transport, Opts) ->
	Pid = spawn_link(?MODULE, init, [ListenerPid, Socket, Transport, Opts]),
	{ok, Pid}.

-record(state, 
        { 
          tcp_local_socket,
          transport %% can be ssl or tcp
        }).

init(ListenerPid, Socket, Transport, _Opts = []) ->
    lager:info("Echo listener init, PID Socket: ~p ~p", [ListenerPid, Socket]),
    ok = ranch:accept_ack(ListenerPid),
    ok = inet:setopts(Socket, [{active,false}]), 
    ok = inet:setopts(Socket, [{packet, ?SIZE_FIELD_BYTES}]), 

    loop(#state{
            tcp_local_socket = Socket, 
            transport = Transport}).

loop(State) ->

    Socket = State#state.tcp_local_socket,
    Transport = State#state.transport,
    Data = Transport:recv(Socket, 0, 5000),
    lager:info("Receive data: ~p", [Data]),

    case Data of
        {ok, <<PacketType:?PACKET_TYPE_FIELD_BITS, Other/binary>>} ->
            lager:info("Packet type: ~p Data: ~p", [PacketType, Other]),
            loop(State);
        _ ->
            ok = Transport:close(Socket)
    end.
