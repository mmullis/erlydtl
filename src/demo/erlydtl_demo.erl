%%%-------------------------------------------------------------------
%%% File:      erlydtl_demo.erl
%%% @author    Roberto Saccon <rsaccon@gmail.com> [http://rsaccon.com]
%%% @copyright 2007 Roberto Saccon
%%% @doc  
%%%
%%% @end  
%%%
%%% The MIT License
%%%
%%% Copyright (c) 2007 Roberto Saccon
%%%
%%% Permission is hereby granted, free of charge, to any person obtaining a copy
%%% of this software and associated documentation files (the "Software"), to deal
%%% in the Software without restriction, including without limitation the rights
%%% to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
%%% copies of the Software, and to permit persons to whom the Software is
%%% furnished to do so, subject to the following conditions:
%%%
%%% The above copyright notice and this permission notice shall be included in
%%% all copies or substantial portions of the Software.
%%%
%%% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
%%% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
%%% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
%%% AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
%%% LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
%%% OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
%%% THE SOFTWARE.
%%%
%%% @since 2007-11-17 by Roberto Saccon
%%%-------------------------------------------------------------------
-module(erlydtl_demo).
-author('rsaccon@gmail.com').

%% API
-export([compile_templates/0,
    render_html/0]).

%%====================================================================
%% API
%%====================================================================
%%--------------------------------------------------------------------
%% @spec () -> any()
%% @doc  compiles the templates to beam files
%% @end 
%%--------------------------------------------------------------------
compile_templates() ->
    DocRoot = filename:join([filename:dirname(code:which(?MODULE)),"..", "demo", "templates"]),
    filelib:fold_files(DocRoot,
        "\.html$",
        true,
        fun(Path, _Acc) ->
            Name = filename:rootname(filename:basename(Path)),
            erlydtl_api:compile(Path, Name, Name, DocRoot)
        end,
        []).
  
                       
%%--------------------------------------------------------------------
%% @spec () -> any()
%% @doc renders the templete to a file
%% @end 
%%--------------------------------------------------------------------
render_html() ->
    OutDir = filename:join([filename:dirname(code:which(?MODULE)),"..", "demo", "out"]),
    render(OutDir, test_variable, ".html", "foostring"),
    render(OutDir, test_extend, ".html", "blastring"),
    render(OutDir, test_comment, ".html").

              
%%====================================================================
%% Internal functions
%%====================================================================

render(OutDir, Name, Ext, Var) ->
    case catch Name:Name(Var) of
        {'EXIT', Reason} -> 
            io:format("TRACE ~p:~p ~p: rendering failure: ~n",[?MODULE, ?LINE, Reason]);
        Val -> 
            case file:open(filename:join([OutDir, lists:concat([Name, Ext])]), [write]) of
        		{ok, IoDev} ->
        		    file:write(IoDev, Val),
        		    file:close(IoDev),
        		    io:format("TRACE ~p:~p ~p: success~n",[?MODULE, ?LINE, Name]);
        		_ ->
        		    io:format("TRACE ~p:~p ~p: file write failure~n",[?MODULE, ?LINE, Name])
        	end
    end.
    
render(OutDir, Name, Ext) ->
    case catch Name:Name() of
        {'EXIT', Reason} -> 
            io:format("TRACE ~p:~p ~p: rendering failure: ~n",[?MODULE, ?LINE, Reason]);
        Val -> 
            case file:open(filename:join([OutDir, lists:concat([Name, Ext])]), [write]) of
        		{ok, IoDev} ->
        		    file:write(IoDev, Val),
        		    file:close(IoDev),
        		    io:format("TRACE ~p:~p ~p: success~n",[?MODULE, ?LINE, Name]);
        		_ ->
        		    io:format("TRACE ~p:~p ~p: file write failure~n",[?MODULE, ?LINE, Name])
        	end
    end.