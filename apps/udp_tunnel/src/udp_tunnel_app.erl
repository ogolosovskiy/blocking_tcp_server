-module(udp_tunnel_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

-include("constants.hrl").

%% ===================================================================
%% Application callbacks
%% ===================================================================

start(_StartType, _StartArgs) ->
    {ok, PidId} = ranch:start_listener(tcp_acceptor, 1, ranch_tcp, [{port, ?TCP_LISTEN_PORT}], tcp2udp, []),
    lager:info("Listener is ran, PID: ~p", [PidId]),
    udp_tunnel_sup:start_link().

stop(_State) ->
    ranch:stop_listener(tcp_echo).
