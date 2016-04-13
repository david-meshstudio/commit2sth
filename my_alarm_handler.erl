-module(my_alarm_handler).
-behaviour(gen_server).
-export([start/0]).
-export([init/1, handle_event/2, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-compile(export_all).
-define(SERVER, ?MODULE).

start() -> gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

init(Args) -> 
	io:format("*** my_alarm_handler init:~p~n",[Args]),
	{ok, 0}.

handle_event({set_alarm, tooHot}, N) ->
	error_logger:error_msg("*** Tell the Engineer to trun on the fan~n"),
	{ok, N + 1};
handle_event({clear_alarm, tooHot}, N) ->
	error_logger:error_msg("*** Danger over. Turn off the fan~n"),
	{ok, N};
handle_event(Event, N) ->
	io:format("*** unmatched event:~p~n", [Event]),
	{ok, N}.

handle_call(_Request, _From, N) ->
	Reply = N,
	{reply, Reply, N}.

handle_cast(_Msg, State) -> {noreply, State}.

handle_info(_Info, State) -> {noreply, State}.

terminate(_Reason, _State) -> ok.

code_change(_OldVsn, State, _Extra) -> {ok, State}.