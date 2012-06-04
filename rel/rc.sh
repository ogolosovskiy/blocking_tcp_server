#!/bin/sh
cd .. && rebar compile && cd rel && rebar generate -f && ./udp_tunnel/bin/udp_tunnel console
