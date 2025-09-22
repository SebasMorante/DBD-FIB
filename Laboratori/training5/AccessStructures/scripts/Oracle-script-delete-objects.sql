Begin
for s in (select sequence_name from user_sequences) loop
execute immediate ('drop sequence '||s.sequence_name);
end loop;
for mv in (select mview_name from user_mviews) loop
execute immediate ('drop materialized view '||mv.mview_name);
end loop;
for t in (select table_name from user_tables) loop
execute immediate ('drop table '||t.table_name||' cascade constraints');
end loop;
for i in (select index_name from user_indexes) loop
execute immediate ('drop index '||i.index_name);
end loop;
for c in (select cluster_name from user_clusters) loop
execute immediate ('drop cluster '||c.cluster_name);
end loop;
execute immediate ('purge recyclebin');
End;