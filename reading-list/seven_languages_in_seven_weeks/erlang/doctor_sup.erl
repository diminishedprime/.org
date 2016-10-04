-module(doctor_sup).
-behaviour(supervisor).

-export([start/0]).
-export([init/1]).

start() ->
    supervisor:start_link({local, doctor}, doctor, []).

init(_Args) ->
    {ok, {{one_for_one, 1, 60},
          [{roulette, {roulette, start, []},
            permanent, brutal_kill, worker, [roulette]}]}}.
