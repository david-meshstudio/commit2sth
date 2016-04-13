-module(area_server).
-behaviour(gen_server).
-export([start/0, area/1]).
-export([init/1, handle_event/2, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-compile(export_all).
-define(SERVER, ?MODULE).

start() -> gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

area(Thing) ->
	gen_server:call(?MODULE, {area, Thing}).

init([]) ->
	process_flag(trap_exit, true),
	io:format("~p starting~n", [?MODULE]),
	{ok, 0}.

handle_event(_Event, State) -> {reply, State}.

handle_call({area, Thing}, _From, N) -> {reply, compute_area(Thing), N + 1}.

handle_cast(_Msg, State) -> {noreply, State}.

handle_info(_Info, State) -> {noreply, State}.

terminate(_Reason, _State) ->
	io:format("~p stopping~n", [?MODULE]),
	ok.

code_change(_OldVsn, State, _Extra) -> {ok, State}.

compute_area({square, X}) -> X * X;
compute_area({rectongle, X, Y}) -> X * Y.