%%%----------------------------------------------------------------------
%%% File    : mod_stanza_ack.erl
%%% Author  : Kay Tsar <kay@mingism.com>
%%% Purpose : Message Receipts XEP-0184 0.5
%%% Created : 25 May 2013 by Kay Tsar <kay@mingism.com>
%%% Usage   : Add the following line in modules section of ejabberd.cfg:
%%%              {mod_stanza_ack,  [{host, "zilan"}]}
%%%
%%%
%%% Copyright (C) 2013-The End of Time   Mingism
%%%
%%% This program is free software; you can redistribute it and/or
%%% modify it under the terms of the GNU General Public License as
%%% published by the Free Software Foundation; either version 2 of the
%%% License, or (at your option) any later version.
%%%
%%% This program is distributed in the hope that it will be useful,
%%% but WITHOUT ANY WARRANTY; without even the implied warranty of
%%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
%%% General Public License for more details.
%%%
%%% You should have received a copy of the GNU General Public License
%%% along with this program; if not, write to the Free Software
%%% Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
%%% 02111-1307 USA
%%%
%%%----------------------------------------------------------------------

-module(mod_stanza_ack).

-behaviour(gen_mod).


-include("logger.hrl").
-include("ejabberd.hrl").
-include("jlib.hrl").

-type host()    :: string().
-type name()    :: string().
-type value()   :: string().
-type opts()    :: [{name(), value()}, ...].

-define(NS_RECEIPTS, <<"urn:xmpp:receipts">>).
-define(EJABBERD_DEBUG, true).

%% ====================================================================
%% API functions
%% ====================================================================
-export([start/2, stop/1]).
-export([on_user_send_packet/4, send_ack_response/5, should_acknowledge/1]).

-spec start(host(), opts()) -> ok.
start(Host, Opts) ->
	mod_disco:register_feature(Host, ?NS_RECEIPTS),
	ejabberd_hooks:add(user_send_packet, Host, ?MODULE, on_user_send_packet, 10),
	ok.

-spec stop(host()) -> ok.
stop(Host) ->
	ejabberd_hooks:delete(user_send_packet, Host, ?MODULE, on_user_send_packet, 10),
	ok.

%% ====================================================================
%% Internal functions
%% ====================================================================

on_user_send_packet(Packet, _C2SState, From, To) ->
    RegisterFromJid = <<"dev@mm.io">>, %used in ack stanza

    case should_acknowledge(Packet) of 
        S when (S==true) ->
            RegisterToJid = From, %used in ack stanza
            send_ack_response(From, To, Packet, RegisterFromJid, RegisterToJid);
        false ->
            ok
    end,
    Packet.

should_acknowledge(#xmlel{name = <<"message">>} = Packet) ->
    case {xml:get_attr_s(<<"type">>, Packet#xmlel.attrs),
          xml:get_subtag_cdata(Packet, <<"body">>)} of
        {<<"error">>, _} ->
            false;
        {_, <<>>} ->
            %% Empty body
            false;
        _ ->
            true
    end;
should_acknowledge(#xmlel{}) ->
    false.

send_ack_response(From, To, Packet, RegisterFromJid, RegisterToJid) ->
    ReceiptId = xml:get_tag_attr_s(<<"id">>, Packet),
    SentTo = jlib:jid_to_string(To),
    XmlBody = #xmlel{name = <<"message">>,
              		    attrs = [{<<"from">>, From}, {<<"to">>, To}],
              		    children =
              			[#xmlel{name = <<"received">>,
              				attrs = [{<<"xmlns">>, ?NS_RECEIPTS}, {<<"id">>, ReceiptId}, {<<"sent_to">>, SentTo}],
              				children = []}]},
    ejabberd_router:route(jlib:string_to_jid(RegisterFromJid), RegisterToJid, XmlBody).