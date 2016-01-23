// Compiled by ClojureScript 1.7.145 {}
goog.provide('cljs.repl');
goog.require('cljs.core');
cljs.repl.print_doc = (function cljs$repl$print_doc(m){
cljs.core.println.call(null,"-------------------------");

cljs.core.println.call(null,[cljs.core.str((function (){var temp__4425__auto__ = new cljs.core.Keyword(null,"ns","ns",441598760).cljs$core$IFn$_invoke$arity$1(m);
if(cljs.core.truth_(temp__4425__auto__)){
var ns = temp__4425__auto__;
return [cljs.core.str(ns),cljs.core.str("/")].join('');
} else {
return null;
}
})()),cljs.core.str(new cljs.core.Keyword(null,"name","name",1843675177).cljs$core$IFn$_invoke$arity$1(m))].join(''));

if(cljs.core.truth_(new cljs.core.Keyword(null,"protocol","protocol",652470118).cljs$core$IFn$_invoke$arity$1(m))){
cljs.core.println.call(null,"Protocol");
} else {
}

if(cljs.core.truth_(new cljs.core.Keyword(null,"forms","forms",2045992350).cljs$core$IFn$_invoke$arity$1(m))){
var seq__8158_8172 = cljs.core.seq.call(null,new cljs.core.Keyword(null,"forms","forms",2045992350).cljs$core$IFn$_invoke$arity$1(m));
var chunk__8159_8173 = null;
var count__8160_8174 = (0);
var i__8161_8175 = (0);
while(true){
if((i__8161_8175 < count__8160_8174)){
var f_8176 = cljs.core._nth.call(null,chunk__8159_8173,i__8161_8175);
cljs.core.println.call(null,"  ",f_8176);

var G__8177 = seq__8158_8172;
var G__8178 = chunk__8159_8173;
var G__8179 = count__8160_8174;
var G__8180 = (i__8161_8175 + (1));
seq__8158_8172 = G__8177;
chunk__8159_8173 = G__8178;
count__8160_8174 = G__8179;
i__8161_8175 = G__8180;
continue;
} else {
var temp__4425__auto___8181 = cljs.core.seq.call(null,seq__8158_8172);
if(temp__4425__auto___8181){
var seq__8158_8182__$1 = temp__4425__auto___8181;
if(cljs.core.chunked_seq_QMARK_.call(null,seq__8158_8182__$1)){
var c__5948__auto___8183 = cljs.core.chunk_first.call(null,seq__8158_8182__$1);
var G__8184 = cljs.core.chunk_rest.call(null,seq__8158_8182__$1);
var G__8185 = c__5948__auto___8183;
var G__8186 = cljs.core.count.call(null,c__5948__auto___8183);
var G__8187 = (0);
seq__8158_8172 = G__8184;
chunk__8159_8173 = G__8185;
count__8160_8174 = G__8186;
i__8161_8175 = G__8187;
continue;
} else {
var f_8188 = cljs.core.first.call(null,seq__8158_8182__$1);
cljs.core.println.call(null,"  ",f_8188);

var G__8189 = cljs.core.next.call(null,seq__8158_8182__$1);
var G__8190 = null;
var G__8191 = (0);
var G__8192 = (0);
seq__8158_8172 = G__8189;
chunk__8159_8173 = G__8190;
count__8160_8174 = G__8191;
i__8161_8175 = G__8192;
continue;
}
} else {
}
}
break;
}
} else {
if(cljs.core.truth_(new cljs.core.Keyword(null,"arglists","arglists",1661989754).cljs$core$IFn$_invoke$arity$1(m))){
var arglists_8193 = new cljs.core.Keyword(null,"arglists","arglists",1661989754).cljs$core$IFn$_invoke$arity$1(m);
if(cljs.core.truth_((function (){var or__5145__auto__ = new cljs.core.Keyword(null,"macro","macro",-867863404).cljs$core$IFn$_invoke$arity$1(m);
if(cljs.core.truth_(or__5145__auto__)){
return or__5145__auto__;
} else {
return new cljs.core.Keyword(null,"repl-special-function","repl-special-function",1262603725).cljs$core$IFn$_invoke$arity$1(m);
}
})())){
cljs.core.prn.call(null,arglists_8193);
} else {
cljs.core.prn.call(null,((cljs.core._EQ_.call(null,new cljs.core.Symbol(null,"quote","quote",1377916282,null),cljs.core.first.call(null,arglists_8193)))?cljs.core.second.call(null,arglists_8193):arglists_8193));
}
} else {
}
}

if(cljs.core.truth_(new cljs.core.Keyword(null,"special-form","special-form",-1326536374).cljs$core$IFn$_invoke$arity$1(m))){
cljs.core.println.call(null,"Special Form");

cljs.core.println.call(null," ",new cljs.core.Keyword(null,"doc","doc",1913296891).cljs$core$IFn$_invoke$arity$1(m));

if(cljs.core.contains_QMARK_.call(null,m,new cljs.core.Keyword(null,"url","url",276297046))){
if(cljs.core.truth_(new cljs.core.Keyword(null,"url","url",276297046).cljs$core$IFn$_invoke$arity$1(m))){
return cljs.core.println.call(null,[cljs.core.str("\n  Please see http://clojure.org/"),cljs.core.str(new cljs.core.Keyword(null,"url","url",276297046).cljs$core$IFn$_invoke$arity$1(m))].join(''));
} else {
return null;
}
} else {
return cljs.core.println.call(null,[cljs.core.str("\n  Please see http://clojure.org/special_forms#"),cljs.core.str(new cljs.core.Keyword(null,"name","name",1843675177).cljs$core$IFn$_invoke$arity$1(m))].join(''));
}
} else {
if(cljs.core.truth_(new cljs.core.Keyword(null,"macro","macro",-867863404).cljs$core$IFn$_invoke$arity$1(m))){
cljs.core.println.call(null,"Macro");
} else {
}

if(cljs.core.truth_(new cljs.core.Keyword(null,"repl-special-function","repl-special-function",1262603725).cljs$core$IFn$_invoke$arity$1(m))){
cljs.core.println.call(null,"REPL Special Function");
} else {
}

cljs.core.println.call(null," ",new cljs.core.Keyword(null,"doc","doc",1913296891).cljs$core$IFn$_invoke$arity$1(m));

if(cljs.core.truth_(new cljs.core.Keyword(null,"protocol","protocol",652470118).cljs$core$IFn$_invoke$arity$1(m))){
var seq__8162 = cljs.core.seq.call(null,new cljs.core.Keyword(null,"methods","methods",453930866).cljs$core$IFn$_invoke$arity$1(m));
var chunk__8163 = null;
var count__8164 = (0);
var i__8165 = (0);
while(true){
if((i__8165 < count__8164)){
var vec__8166 = cljs.core._nth.call(null,chunk__8163,i__8165);
var name = cljs.core.nth.call(null,vec__8166,(0),null);
var map__8167 = cljs.core.nth.call(null,vec__8166,(1),null);
var map__8167__$1 = ((((!((map__8167 == null)))?((((map__8167.cljs$lang$protocol_mask$partition0$ & (64))) || (map__8167.cljs$core$ISeq$))?true:false):false))?cljs.core.apply.call(null,cljs.core.hash_map,map__8167):map__8167);
var doc = cljs.core.get.call(null,map__8167__$1,new cljs.core.Keyword(null,"doc","doc",1913296891));
var arglists = cljs.core.get.call(null,map__8167__$1,new cljs.core.Keyword(null,"arglists","arglists",1661989754));
cljs.core.println.call(null);

cljs.core.println.call(null," ",name);

cljs.core.println.call(null," ",arglists);

if(cljs.core.truth_(doc)){
cljs.core.println.call(null," ",doc);
} else {
}

var G__8194 = seq__8162;
var G__8195 = chunk__8163;
var G__8196 = count__8164;
var G__8197 = (i__8165 + (1));
seq__8162 = G__8194;
chunk__8163 = G__8195;
count__8164 = G__8196;
i__8165 = G__8197;
continue;
} else {
var temp__4425__auto__ = cljs.core.seq.call(null,seq__8162);
if(temp__4425__auto__){
var seq__8162__$1 = temp__4425__auto__;
if(cljs.core.chunked_seq_QMARK_.call(null,seq__8162__$1)){
var c__5948__auto__ = cljs.core.chunk_first.call(null,seq__8162__$1);
var G__8198 = cljs.core.chunk_rest.call(null,seq__8162__$1);
var G__8199 = c__5948__auto__;
var G__8200 = cljs.core.count.call(null,c__5948__auto__);
var G__8201 = (0);
seq__8162 = G__8198;
chunk__8163 = G__8199;
count__8164 = G__8200;
i__8165 = G__8201;
continue;
} else {
var vec__8169 = cljs.core.first.call(null,seq__8162__$1);
var name = cljs.core.nth.call(null,vec__8169,(0),null);
var map__8170 = cljs.core.nth.call(null,vec__8169,(1),null);
var map__8170__$1 = ((((!((map__8170 == null)))?((((map__8170.cljs$lang$protocol_mask$partition0$ & (64))) || (map__8170.cljs$core$ISeq$))?true:false):false))?cljs.core.apply.call(null,cljs.core.hash_map,map__8170):map__8170);
var doc = cljs.core.get.call(null,map__8170__$1,new cljs.core.Keyword(null,"doc","doc",1913296891));
var arglists = cljs.core.get.call(null,map__8170__$1,new cljs.core.Keyword(null,"arglists","arglists",1661989754));
cljs.core.println.call(null);

cljs.core.println.call(null," ",name);

cljs.core.println.call(null," ",arglists);

if(cljs.core.truth_(doc)){
cljs.core.println.call(null," ",doc);
} else {
}

var G__8202 = cljs.core.next.call(null,seq__8162__$1);
var G__8203 = null;
var G__8204 = (0);
var G__8205 = (0);
seq__8162 = G__8202;
chunk__8163 = G__8203;
count__8164 = G__8204;
i__8165 = G__8205;
continue;
}
} else {
return null;
}
}
break;
}
} else {
return null;
}
}
});

//# sourceMappingURL=repl.js.map