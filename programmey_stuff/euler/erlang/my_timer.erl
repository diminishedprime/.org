-module(my_timer).
-export([time_call/1]).

time_call(MyFn) ->
    StartTime = erlang:timestamp(),

    MyFn(),

    EndTime = erlang:timestamp(),
    TotalTime = timer:now_diff(EndTime, StartTime),
    io:format("It took: ~p microseconds~n", [TotalTime]).
