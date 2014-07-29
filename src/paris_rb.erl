-module(paris_rb).

-export([
  type/0,
  call/3
  ]).

type() -> controller.

call(Controller, Fun, Params) when is_atom(Controller), is_atom(Fun), is_list(Params) ->
  ok = application:ensure_started(paris_rb),
  case get_controller_file(Controller) of
    {ok, ControllerFile} ->
      [_|ExtWithoutDot] = string:to_lower(filename:extension(ControllerFile)),
      case ExtWithoutDot of
        "rb" -> execute_ruby_template(ControllerFile, Fun, Params);
        _ -> {error, "Not a ruby file"}
      end;
    _ -> {error, "Controller not found"}
  end.

execute_ruby_template(ScriptFile, Fun, Params) ->
  ModuleName = filename:basename(ScriptFile, ".rb"),
  {ok, R} = ruby:start([{ruby_lib, get_ruby_lib(ScriptFile)}]),
  try
    CallResult = ruby:call(R, list_to_atom(ModuleName), Fun, Params),
    {ruby:stop(R), CallResult}
  catch
    _:{ruby, ExceptionClass, Message, _} -> 
      ruby:stop(R), 
      {error, {ruby, ExceptionClass, Message}}
  end.

get_ruby_lib(ScriptFile) ->
  PrivRuby = filename:join([paris:priv_dir(), "ruby"]),
  [
    filename:dirname(ScriptFile), 
    get_helper_path()
    ] ++ case filelib:is_dir(PrivRuby) of
    true -> [PrivRuby];
    false -> []
  end.

get_controller_file(Controller) ->
  ControllerMatch = efile:normalize_path(
      filename:join(
        [paris:priv_dir(), "..", "src", "controllers", atom_to_list(Controller) ++ ".*"])),
  case filelib:wildcard(ControllerMatch) of
    [ControllerFile|_] -> {ok, ControllerFile};
    _ -> {error, not_found}
  end.

get_helper_path() ->
  PrivDir = case code:priv_dir(paris_rb) of
    {error, bad_name} ->
      Ebin = filename:dirname(code:which(?MODULE)),
      filename:join(filename:dirname(Ebin), "priv");
    Path -> Path
  end,
  filename:join([PrivDir, "helpers"]).

