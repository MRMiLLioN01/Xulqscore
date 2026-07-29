-- Item metadata required by the server-side adaptive router.
create table if not exists public.scoring_meta (
  item_id  text primary key,
  dim      text not null,
  style    text not null,
  role     text not null,
  measured text[] not null
);
alter table public.scoring_meta enable row level security;
-- no policies: reachable only by SECURITY DEFINER functions

truncate public.scoring_meta;
insert into public.scoring_meta (item_id,dim,style,role,measured) values
('S001','INT','Case study','Probe',ARRAY['CON','INT','SC','LOC','MON','PLN']::text[]),
('S002','PLN','Case study','Probe',ARRAY['SC','LOC','MON','PLN']::text[]),
('S003','INT','Case study','Probe',ARRAY['INT','SC','LOC','MON','PLN']::text[]),
('S003b','SC','Case study','Probe',ARRAY['INT','SC','LOC','MON','PLN']::text[]),
('S004','PLN','Case study','Probe',ARRAY['INT','SC','LOC','MON','PLN']::text[]),
('S005','PLN','Forced choice','Screener',ARRAY['CON','SC','LOC','MON','PLN']::text[]),
('S006','INT','Case study','Probe',ARRAY['SC','LOC','MON','PLN']::text[]),
('S007','LOC','Indirect (attribution)','Probe',ARRAY['INT','LOC','PLN']::text[]),
('S008','SC','Case study','Probe',ARRAY['INT','SC','MON','PLN']::text[]),
('S009','INT','Case study','Probe',ARRAY['INT','SC','LOC','MON']::text[]),
('S010','INT','Forced choice','Screener',ARRAY['INT','LOC','MON']::text[]),
('S011','INT','Case study','Probe',ARRAY['CON','INT','SC','LOC','MON','PLN']::text[]),
('S012','INT','Case study','Probe',ARRAY['INT','LOC','MON','PLN']::text[]),
('S013','INT','Forced choice','Screener',ARRAY['CON','INT','LOC','MON']::text[]),
('S014','PLN','Case study','Probe',ARRAY['CON','INT','SC','LOC','MON','PLN']::text[]),
('S015','INT','Case study','Probe',ARRAY['INT','LOC','MON','PLN']::text[]),
('S016','INT','Indirect (attribution)','Probe',ARRAY['INT','LOC','MON','PLN']::text[]),
('S017','PLN','Case study','Probe',ARRAY['CON','INT','SC','LOC','MON','PLN']::text[]),
('S018','INT','Case study','Probe',ARRAY['INT','SC','LOC','MON','PLN']::text[]),
('S019','MON','Forced choice','Screener',ARRAY['INT','SC','LOC','MON','PLN']::text[]),
('S020','INT','Case study','Probe',ARRAY['CON','INT','SC','MON','PLN']::text[]),
('S021','SC','Case study','Probe',ARRAY['SC','LOC','MON','PLN']::text[]),
('S022','SC','Case study','Probe',ARRAY['SC','LOC','MON','PLN']::text[]),
('S023','SC','Forced choice','Screener',ARRAY['SC','LOC','MON','PLN']::text[]),
('S024','SC','Case study','Probe',ARRAY['SC','LOC','MON','PLN']::text[]),
('S025','SC','Case study','Probe',ARRAY['SC','LOC','MON','PLN']::text[]),
('S026','SC','Indirect (attribution)','Probe',ARRAY['SC','LOC','MON','PLN']::text[]),
('S027','SC','Case study','Probe',ARRAY['SC','LOC','PLN']::text[]),
('S028','SC','Forced choice','Screener',ARRAY['CON','SC','LOC','PLN']::text[]),
('S029','SC','Case study','Probe',ARRAY['SC','MON','PLN']::text[]),
('S030','SC','Case study','Probe',ARRAY['INT','SC','LOC','MON','PLN']::text[]),
('S031','SC','Case study','Probe',ARRAY['SC','LOC','MON','PLN']::text[]),
('S032','LOC','Case study','Probe',ARRAY['INT','SC','LOC','PLN']::text[]),
('S033','LOC','Indirect (attribution)','Probe',ARRAY['LOC','PLN']::text[]),
('S034','LOC','Case study','Probe',ARRAY['INT','LOC','MON','PLN']::text[]),
('S035','LOC','Case study','Probe',ARRAY['SC','LOC','PLN']::text[]),
('S036','INT','Case study','Probe',ARRAY['INT','LOC','MON','PLN']::text[]),
('S037','LOC','Forced choice','Screener',ARRAY['LOC','PLN']::text[]),
('S038','LOC','Case study','Probe',ARRAY['SC','LOC','PLN']::text[]),
('S039','PLN','Case study','Probe',ARRAY['CON','INT','SC','LOC','MON','PLN']::text[]),
('S040','LOC','Indirect (attribution)','Probe',ARRAY['INT','LOC','PLN']::text[]),
('S041','LOC','Case study','Probe',ARRAY['SC','LOC','PLN']::text[]),
('S042','PLN','Case study','Probe',ARRAY['CON','MON','PLN']::text[]),
('S043','PLN','Case study','Probe',ARRAY['SC','LOC','MON','PLN']::text[]),
('S044','PLN','Forced choice','Screener',ARRAY['CON','LOC','PLN']::text[]),
('S045','PLN','Case study','Probe',ARRAY['SC','LOC','PLN']::text[]),
('S046','PLN','Case study','Probe',ARRAY['CON','INT','LOC','MON','PLN']::text[]),
('S047','PLN','Case study','Probe',ARRAY['LOC','MON','PLN']::text[]),
('S048','PLN','Case study','Probe',ARRAY['SC','MON','PLN']::text[]),
('S049','PLN','Indirect (attribution)','Probe',ARRAY['SC','LOC','MON','PLN']::text[]),
('S050','PLN','Case study','Probe',ARRAY['CON','MON','PLN']::text[]),
('S051','PLN','Case study','Probe',ARRAY['CON','SC','PLN']::text[]),
('S052','INT','Case study','Probe',ARRAY['INT','LOC','MON','PLN']::text[]),
('S053','INT','Case study','Probe',ARRAY['INT','LOC','MON','PLN']::text[]),
('S054','INT','Indirect (attribution)','Probe',ARRAY['INT','MON','PLN']::text[]),
('S055','INT','Case study','Probe',ARRAY['INT','LOC','MON','PLN']::text[]),
('S056','INT','Case study','Probe',ARRAY['INT','SC','MON','PLN']::text[]),
('S057','INT','Forced choice','Screener',ARRAY['INT','LOC']::text[]),
('S058','INT','Case study','Probe',ARRAY['CON','INT','LOC','MON','PLN']::text[]),
('S059','INT','Case study','Probe',ARRAY['INT','SC','LOC','PLN']::text[]),
('S060','INT','Indirect (attribution)','Probe',ARRAY['INT','LOC','MON','PLN']::text[]),
('S061','INT','Case study','Probe',ARRAY['INT','MON','PLN']::text[]),
('S062','CON','Case study','Probe',ARRAY['CON','INT','SC','LOC']::text[]),
('S063','CON','Case study','Probe',ARRAY['CON','INT','MON','PLN']::text[]),
('S064','CON','Forced choice','Screener',ARRAY['CON','INT','LOC']::text[]),
('S065','CON','Case study','Probe',ARRAY['CON','INT','SC','LOC']::text[]),
('S066','CON','Indirect (attribution)','Probe',ARRAY['CON','INT','LOC','PLN']::text[]),
('S067','CON','Case study','Probe',ARRAY['CON','INT','SC','LOC']::text[]),
('S068','CON','Case study','Probe',ARRAY['CON','SC','LOC','PLN']::text[]),
('S069','CON','Forced choice','Screener',ARRAY['CON','INT','LOC','PLN']::text[]),
('S070','SC','Forced choice','Screener',ARRAY['SC','LOC','PLN']::text[]),
('S071','PLN','Forced choice','Screener',ARRAY['CON','LOC','PLN']::text[]),
('S072','INT','Forced choice','Screener',ARRAY['CON','INT','LOC']::text[]),
('S073','MON','Forced choice','Screener',ARRAY['LOC','MON','PLN']::text[]),
('S074','CON','Forced choice','Screener',ARRAY['CON','SC','LOC','PLN']::text[]),
('S075','INT','Forced choice','Screener',ARRAY['CON','INT','MON','PLN']::text[]),
('S076','PLN','Forced choice','Screener',ARRAY['CON','SC','MON','PLN']::text[]),
('S077','LOC','Forced choice','Screener',ARRAY['CON','INT','SC','LOC']::text[]),
('S078','MON','Forced choice','Screener',ARRAY['SC','LOC','MON','PLN']::text[]),
('S079','INT','Forced choice','Screener',ARRAY['CON','INT','LOC','PLN']::text[]),
('S080','SC','Forced choice','Screener',ARRAY['SC','LOC','MON']::text[]),
('S081','CON','Forced choice','Screener',ARRAY['CON','SC','LOC']::text[]),
('S082','INT','Forced choice','Screener',ARRAY['CON','INT','SC','LOC']::text[]),
('S083','PLN','Forced choice','Screener',ARRAY['CON','MON','PLN']::text[]),
('S084','SC','Indirect (norm)','Probe',ARRAY['SC','MON','PLN']::text[]),
('S085','INT','Indirect (conditional reasoning)','Probe',ARRAY['INT','LOC','MON','PLN']::text[]),
('S086','PLN','Indirect (norm)','Probe',ARRAY['LOC','PLN']::text[]),
('S087','CON','Indirect (conditional reasoning)','Probe',ARRAY['CON','INT','PLN']::text[]),
('S088','SC','Indirect (conditional reasoning)','Probe',ARRAY['INT','SC','LOC','MON','PLN']::text[]),
('S089','LOC','Indirect (norm)','Probe',ARRAY['INT','SC','LOC','PLN']::text[]),
('S090','INT','Indirect (norm)','Probe',ARRAY['INT','MON']::text[]),
('S091','MON','Indirect (conditional reasoning)','Probe',ARRAY['SC','LOC','MON','PLN']::text[]),
('S092','SC','Indirect (norm)','Probe',ARRAY['SC','MON','PLN']::text[]),
('S093','LOC','Indirect (norm)','Probe',ARRAY['LOC','MON','PLN']::text[]),
('S094','INT','Indirect (conditional reasoning)','Probe',ARRAY['CON','INT','LOC']::text[]),
('S095','PLN','Indirect (norm)','Probe',ARRAY['LOC','MON','PLN']::text[]),
('S096','SC','Indirect (conditional reasoning)','Probe',ARRAY['SC','LOC','MON','PLN']::text[]),
('S097','INT','Indirect (norm)','Probe',ARRAY['CON','INT','MON']::text[]),
('S098','CON','Indirect (conditional reasoning)','Probe',ARRAY['CON','SC','LOC']::text[]),
('S099','PLN','Indirect (norm)','Probe',ARRAY['LOC','MON','PLN']::text[]),
('N001','SC','Forced choice','Screener',ARRAY['SC','MON','PLN']::text[]),
('N002','SC','Forced choice','Screener',ARRAY['SC','MON']::text[]),
('N003','SC','Case study','Probe',ARRAY['SC','LOC','MON','PLN']::text[]),
('N004','SC','Case study','Probe',ARRAY['SC','LOC','MON','PLN']::text[]),
('N005','SC','Indirect (norm)','Probe',ARRAY['SC','LOC','MON','PLN']::text[]),
('N006','SC','Case study','Probe',ARRAY['SC','LOC','MON','PLN']::text[]),
('N007','SC','Forced choice','Screener',ARRAY['SC','LOC','PLN']::text[]),
('N008','SC','Indirect (conditional reasoning)','Probe',ARRAY['SC','LOC','PLN']::text[]),
('N009','SC','Case study','Probe',ARRAY['SC','LOC','MON','PLN']::text[]),
('N010','SC','Forced choice','Screener',ARRAY['SC','LOC','MON','PLN']::text[]),
('N011','SC','Case study','Probe',ARRAY['SC','LOC','MON','PLN']::text[]),
('N012','SC','Forced choice','Screener',ARRAY['CON','SC','LOC']::text[]),
('N013','SC','Indirect (norm)','Probe',ARRAY['SC','MON','PLN']::text[]),
('N014','SC','Case study','Probe',ARRAY['SC','LOC','MON','PLN']::text[]),
('N015','SC','Forced choice','Screener',ARRAY['SC','MON']::text[]),
('N016','SC','Case study','Probe',ARRAY['SC','LOC','PLN']::text[]),
('N017','SC','Indirect (conditional reasoning)','Probe',ARRAY['SC','LOC','MON','PLN']::text[]),
('N018','SC','Case study','Probe',ARRAY['SC','MON','PLN']::text[]),
('N019','SC','Forced choice','Screener',ARRAY['SC','LOC','MON']::text[]),
('N020','SC','Case study','Probe',ARRAY['SC','LOC','PLN']::text[]),
('N021','SC','Case study','Probe',ARRAY['SC','LOC','MON']::text[]),
('N022','SC','Forced choice','Screener',ARRAY['SC','LOC']::text[]),
('N023','SC','Indirect (norm)','Probe',ARRAY['SC','LOC','PLN']::text[]),
('N024','SC','Case study','Probe',ARRAY['SC','LOC','PLN']::text[]),
('N025','SC','Forced choice','Screener',ARRAY['SC','MON','PLN']::text[]),
('N026','SC','Case study','Probe',ARRAY['SC','LOC','MON','PLN']::text[]),
('N027','SC','Case study','Probe',ARRAY['SC','LOC','MON','PLN']::text[]),
('N028','SC','Forced choice','Screener',ARRAY['SC','LOC','MON']::text[]),
('N029','SC','Indirect (norm)','Probe',ARRAY['SC','LOC','MON','PLN']::text[]),
('N030','SC','Case study','Probe',ARRAY['SC','LOC','MON','PLN']::text[]),
('N031','SC','Indirect (conditional reasoning)','Probe',ARRAY['SC','LOC','MON','PLN']::text[]),
('N032','SC','Forced choice','Screener',ARRAY['SC','LOC','MON','PLN']::text[]),
('N033','SC','Case study','Probe',ARRAY['SC','LOC','MON','PLN']::text[]),
('N034','CON','Case study','Probe',ARRAY['CON','MON','PLN']::text[]),
('N035','CON','Forced choice','Screener',ARRAY['CON','LOC','PLN']::text[]),
('N036','CON','Case study','Probe',ARRAY['CON','INT','PLN']::text[]),
('N037','CON','Forced choice','Screener',ARRAY['CON','SC','LOC']::text[]),
('N038','CON','Case study','Probe',ARRAY['CON','INT','MON','PLN']::text[]),
('N039','CON','Indirect (conditional reasoning)','Probe',ARRAY['CON','SC','LOC','PLN']::text[]),
('N040','CON','Forced choice','Screener',ARRAY['CON','INT']::text[]),
('N041','CON','Case study','Probe',ARRAY['CON','MON','PLN']::text[]),
('N042','CON','Case study','Probe',ARRAY['CON','SC','LOC']::text[]),
('N043','CON','Forced choice','Screener',ARRAY['CON','SC','LOC']::text[]),
('N044','CON','Case study','Probe',ARRAY['CON','INT','SC','LOC']::text[]),
('N045','CON','Indirect (norm)','Probe',ARRAY['CON','INT','LOC','PLN']::text[]),
('N046','CON','Forced choice','Screener',ARRAY['CON','LOC','PLN']::text[]),
('N047','CON','Case study','Probe',ARRAY['CON','INT','SC','LOC']::text[]),
('N048','CON','Case study','Probe',ARRAY['CON','MON','PLN']::text[]),
('N049','CON','Forced choice','Screener',ARRAY['CON','SC','LOC']::text[]),
('N050','CON','Case study','Probe',ARRAY['CON','LOC','PLN']::text[]),
('N051','CON','Indirect (conditional reasoning)','Probe',ARRAY['CON','INT','LOC']::text[]),
('N052','CON','Forced choice','Screener',ARRAY['CON','MON']::text[]),
('N053','CON','Case study','Probe',ARRAY['CON','SC','PLN']::text[]),
('N054','CON','Forced choice','Screener',ARRAY['CON','INT','LOC','PLN']::text[]),
('N055','CON','Case study','Probe',ARRAY['CON','INT','PLN']::text[]),
('N056','CON','Indirect (norm)','Probe',ARRAY['CON','LOC','PLN']::text[]),
('N057','CON','Forced choice','Screener',ARRAY['CON','SC','LOC']::text[]),
('N058','CON','Case study','Probe',ARRAY['CON','MON','PLN']::text[]),
('N059','CON','Forced choice','Screener',ARRAY['CON','LOC','PLN']::text[]),
('N060','CON','Case study','Probe',ARRAY['CON','SC','LOC']::text[]),
('N061','CON','Indirect (conditional reasoning)','Probe',ARRAY['CON','INT','PLN']::text[]),
('N062','CON','Forced choice','Screener',ARRAY['CON','LOC','PLN']::text[]),
('N063','CON','Case study','Probe',ARRAY['CON','INT','LOC']::text[]),
('N064','CON','Forced choice','Screener',ARRAY['CON','LOC','PLN']::text[]),
('N065','CON','Case study','Probe',ARRAY['CON','INT','LOC','PLN']::text[]),
('N066','CON','Indirect (norm)','Probe',ARRAY['CON','INT','LOC']::text[]),
('N067','CON','Forced choice','Screener',ARRAY['CON','MON']::text[]),
('N068','CON','Case study','Probe',ARRAY['CON','SC','LOC','PLN']::text[]),
('N069','CON','Forced choice','Screener',ARRAY['CON','INT','SC','LOC']::text[]),
('N070','CON','Case study','Probe',ARRAY['CON','MON','PLN']::text[]),
('N071','CON','Forced choice','Screener',ARRAY['CON','LOC','PLN']::text[]),
('N072','CON','Case study','Probe',ARRAY['CON','INT','LOC']::text[]),
('N073','CON','Forced choice','Screener',ARRAY['CON','SC']::text[]),
('N074','CON','Case study','Probe',ARRAY['CON','MON','PLN']::text[]),
('N075','CON','Indirect (conditional reasoning)','Probe',ARRAY['CON','SC','LOC']::text[]),
('N076','CON','Forced choice','Screener',ARRAY['CON','SC','LOC']::text[]),
('N077','CON','Case study','Probe',ARRAY['CON','LOC','PLN']::text[]),
('N078','CON','Forced choice','Screener',ARRAY['CON','MON']::text[]),
('N079','CON','Case study','Probe',ARRAY['CON','INT','LOC']::text[]),
('N080','CON','Forced choice','Screener',ARRAY['CON','SC','LOC']::text[]),
('N081','INT','Case study','Probe',ARRAY['INT','LOC','MON','PLN']::text[]),
('N082','INT','Forced choice','Screener',ARRAY['INT','LOC','MON']::text[]),
('N083','INT','Case study','Probe',ARRAY['INT','LOC','MON','PLN']::text[]),
('N084','INT','Indirect (norm)','Probe',ARRAY['INT','MON']::text[]),
('N085','INT','Case study','Probe',ARRAY['INT','LOC','MON','PLN']::text[]),
('N086','INT','Forced choice','Screener',ARRAY['INT','LOC','MON']::text[]),
('N087','INT','Case study','Probe',ARRAY['INT','LOC','MON','PLN']::text[]),
('N088','INT','Indirect (attribution)','Probe',ARRAY['INT','LOC','MON','PLN']::text[]),
('N089','INT','Case study','Probe',ARRAY['INT','SC','MON','PLN']::text[]),
('N090','INT','Forced choice','Screener',ARRAY['INT','MON']::text[]),
('N091','INT','Case study','Probe',ARRAY['INT','LOC','MON','PLN']::text[]),
('N092','INT','Indirect (conditional reasoning)','Probe',ARRAY['INT','LOC','MON','PLN']::text[]),
('N093','INT','Forced choice','Screener',ARRAY['CON','INT','MON','PLN']::text[]),
('N094','INT','Case study','Probe',ARRAY['INT','LOC','MON','PLN']::text[]),
('N095','INT','Forced choice','Screener',ARRAY['INT','MON']::text[]),
('N096','INT','Case study','Probe',ARRAY['INT','SC','LOC','PLN']::text[]),
('N097','INT','Indirect (norm)','Probe',ARRAY['CON','INT','MON']::text[]),
('N098','INT','Case study','Probe',ARRAY['INT','SC','MON','PLN']::text[]),
('N099','INT','Forced choice','Screener',ARRAY['CON','INT','LOC']::text[]),
('N100','INT','Case study','Probe',ARRAY['INT','SC','MON']::text[]),
('N101','INT','Forced choice','Screener',ARRAY['INT','MON']::text[]),
('N102','INT','Case study','Probe',ARRAY['INT','LOC','MON','PLN']::text[]),
('N103','INT','Indirect (attribution)','Probe',ARRAY['INT','LOC','PLN']::text[]),
('N104','INT','Case study','Probe',ARRAY['INT','SC','MON','PLN']::text[]),
('N105','INT','Forced choice','Screener',ARRAY['INT','SC','MON']::text[]),
('N106','INT','Case study','Probe',ARRAY['INT','SC','LOC','MON','PLN']::text[]),
('N107','INT','Forced choice','Screener',ARRAY['INT','MON']::text[]),
('N108','INT','Case study','Probe',ARRAY['INT','LOC','MON','PLN']::text[]),
('N109','INT','Forced choice','Screener',ARRAY['CON','INT','LOC']::text[]),
('N110','INT','Case study','Probe',ARRAY['INT','SC','LOC','MON','PLN']::text[]),
('N111','INT','Indirect (norm)','Probe',ARRAY['INT','MON']::text[]),
('N112','INT','Forced choice','Screener',ARRAY['INT','PLN']::text[]),
('N113','INT','Case study','Probe',ARRAY['INT','SC','LOC','MON']::text[]),
('N114','INT','Forced choice','Screener',ARRAY['INT']::text[]),
('N115','INT','Case study','Probe',ARRAY['INT','SC','MON','PLN']::text[]),
('N116','INT','Forced choice','Screener',ARRAY['CON','INT','LOC','PLN']::text[]),
('N117','INT','Case study','Probe',ARRAY['INT','LOC','MON','PLN']::text[]),
('N118','INT','Forced choice','Screener',ARRAY['INT']::text[]),
('N119','INT','Case study','Probe',ARRAY['INT','LOC','MON','PLN']::text[]),
('N120','INT','Indirect (norm)','Probe',ARRAY['INT','LOC','MON','PLN']::text[]),
('N121','INT','Case study','Probe',ARRAY['INT','SC','LOC','PLN']::text[]),
('N122','INT','Forced choice','Screener',ARRAY['INT','MON']::text[]),
('N123','INT','Case study','Probe',ARRAY['INT','LOC','MON','PLN']::text[]),
('N124','INT','Forced choice','Screener',ARRAY['INT']::text[]),
('N125','INT','Case study','Probe',ARRAY['INT','MON','PLN']::text[]),
('N126','INT','Indirect (conditional reasoning)','Probe',ARRAY['CON','INT','SC','LOC','MON','PLN']::text[]),
('N127','INT','Forced choice','Screener',ARRAY['INT','LOC','MON']::text[]),
('N128','INT','Case study','Probe',ARRAY['INT','LOC','MON','PLN']::text[]),
('N129','INT','Forced choice','Screener',ARRAY['CON','INT','LOC']::text[]),
('N130','INT','Case study','Probe',ARRAY['INT','SC','MON','PLN']::text[]),
('N131','INT','Indirect (norm)','Probe',ARRAY['INT','LOC','PLN']::text[]),
('N132','INT','Forced choice','Screener',ARRAY['INT','MON']::text[]),
('N133','INT','Case study','Probe',ARRAY['INT','LOC','MON','PLN']::text[]),
('N134','INT','Case study','Probe',ARRAY['CON','INT','MON','PLN']::text[]),
('N135','INT','Forced choice','Screener',ARRAY['CON','INT']::text[]),
('N136','INT','Case study','Probe',ARRAY['INT','PLN']::text[]),
('N137','INT','Indirect (norm)','Probe',ARRAY['INT','LOC','PLN']::text[]),
('N138','INT','Forced choice','Screener',ARRAY['INT','LOC','PLN']::text[]),
('N139','INT','Case study','Probe',ARRAY['INT','LOC','PLN']::text[]),
('N140','INT','Forced choice','Screener',ARRAY['CON','INT','LOC']::text[]),
('N141','LOC','Indirect (attribution)','Probe',ARRAY['INT','LOC','PLN']::text[]),
('N142','LOC','Forced choice','Screener',ARRAY['LOC','PLN']::text[]),
('N143','LOC','Case study','Probe',ARRAY['INT','LOC','MON','PLN']::text[]),
('N144','LOC','Indirect (attribution)','Probe',ARRAY['LOC','PLN']::text[]),
('N145','LOC','Case study','Probe',ARRAY['SC','LOC','PLN']::text[]),
('N146','LOC','Forced choice','Screener',ARRAY['LOC','PLN']::text[]),
('N147','LOC','Indirect (attribution)','Probe',ARRAY['LOC','MON','PLN']::text[]),
('N148','LOC','Case study','Probe',ARRAY['INT','LOC','PLN']::text[]),
('N149','LOC','Forced choice','Screener',ARRAY['LOC','PLN']::text[]),
('N150','LOC','Indirect (attribution)','Probe',ARRAY['INT','LOC','MON','PLN']::text[]),
('N151','LOC','Case study','Probe',ARRAY['SC','LOC','PLN']::text[]),
('N152','LOC','Forced choice','Screener',ARRAY['SC','LOC']::text[]),
('N153','LOC','Indirect (conditional reasoning)','Probe',ARRAY['LOC','PLN']::text[]),
('N154','LOC','Case study','Probe',ARRAY['INT','LOC','PLN']::text[]),
('N155','LOC','Forced choice','Screener',ARRAY['LOC','PLN']::text[]),
('N156','LOC','Case study','Probe',ARRAY['SC','LOC','MON','PLN']::text[]),
('N157','LOC','Indirect (norm)','Probe',ARRAY['INT','SC','LOC','PLN']::text[]),
('N158','LOC','Case study','Probe',ARRAY['INT','SC','LOC','PLN']::text[]),
('N159','LOC','Forced choice','Screener',ARRAY['LOC','PLN']::text[]),
('N160','LOC','Case study','Probe',ARRAY['SC','LOC','PLN']::text[]),
('N161','LOC','Indirect (conditional reasoning)','Probe',ARRAY['SC','LOC','PLN']::text[]),
('N162','LOC','Forced choice','Screener',ARRAY['SC','LOC']::text[]),
('N163','LOC','Case study','Probe',ARRAY['SC','LOC','MON','PLN']::text[]),
('N164','LOC','Forced choice','Screener',ARRAY['LOC','PLN']::text[]),
('N165','LOC','Case study','Probe',ARRAY['INT','SC','LOC','MON','PLN']::text[]),
('N166','LOC','Indirect (norm)','Probe',ARRAY['LOC','PLN']::text[]),
('N167','PLN','Case study','Probe',ARRAY['SC','LOC','MON','PLN']::text[]),
('N168','PLN','Forced choice','Screener',ARRAY['LOC','PLN']::text[]),
('N169','PLN','Case study','Probe',ARRAY['LOC','MON','PLN']::text[]),
('N170','PLN','Case study','Probe',ARRAY['SC','MON','PLN']::text[]),
('N171','PLN','Forced choice','Screener',ARRAY['CON','MON','PLN']::text[]),
('N172','PLN','Case study','Probe',ARRAY['CON','MON','PLN']::text[]),
('N173','PLN','Indirect (norm)','Probe',ARRAY['LOC','MON','PLN']::text[]),
('N174','PLN','Forced choice','Screener',ARRAY['LOC','PLN']::text[]),
('N175','PLN','Case study','Probe',ARRAY['INT','LOC','MON','PLN']::text[]),
('N176','PLN','Case study','Probe',ARRAY['SC','LOC','MON','PLN']::text[]),
('N177','PLN','Forced choice','Screener',ARRAY['CON','LOC','PLN']::text[]),
('N178','PLN','Case study','Probe',ARRAY['SC','PLN']::text[]),
('N179','PLN','Indirect (conditional reasoning)','Probe',ARRAY['SC','LOC','PLN']::text[]),
('N180','PLN','Case study','Probe',ARRAY['INT','SC','LOC','MON','PLN']::text[]),
('N181','PLN','Forced choice','Screener',ARRAY['LOC','MON','PLN']::text[]),
('N182','PLN','Case study','Probe',ARRAY['SC','MON','PLN']::text[]),
('N183','PLN','Indirect (norm)','Probe',ARRAY['LOC','PLN']::text[]),
('N184','PLN','Case study','Probe',ARRAY['SC','MON','PLN']::text[]),
('N185','PLN','Forced choice','Screener',ARRAY['CON','LOC','PLN']::text[]),
('N186','PLN','Case study','Probe',ARRAY['SC','LOC','MON','PLN']::text[]),
('N187','PLN','Forced choice','Screener',ARRAY['MON','PLN']::text[]),
('N188','PLN','Case study','Probe',ARRAY['SC','LOC','MON','PLN']::text[]),
('N189','PLN','Indirect (conditional reasoning)','Probe',ARRAY['SC','LOC','MON','PLN']::text[]),
('N190','PLN','Forced choice','Screener',ARRAY['LOC','PLN']::text[]),
('N191','MON','Case study','Probe',ARRAY['CON','MON','PLN']::text[]),
('N192','MON','Forced choice','Screener',ARRAY['CON','MON']::text[]),
('N193','MON','Case study','Probe',ARRAY['MON','PLN']::text[]),
('N194','MON','Forced choice','Screener',ARRAY['MON','PLN']::text[]),
('N195','MON','Case study','Probe',ARRAY['CON','MON','PLN']::text[]),
('N196','MON','Forced choice','Screener',ARRAY['CON','MON','PLN']::text[]),
('N197','MON','Case study','Probe',ARRAY['SC','MON','PLN']::text[]),
('N198','MON','Indirect (norm)','Probe',ARRAY['SC','MON','PLN']::text[]),
('N199','MON','Forced choice','Screener',ARRAY['MON','PLN']::text[]),
('N200','MON','Case study','Probe',ARRAY['CON','MON','PLN']::text[]),
('N201','MON','Forced choice','Screener',ARRAY['SC','MON','PLN']::text[]),
('N202','MON','Case study','Probe',ARRAY['SC','MON','PLN']::text[]),
('N203','MON','Forced choice','Screener',ARRAY['SC','MON']::text[]),
('N204','MON','Case study','Probe',ARRAY['SC','LOC','MON','PLN']::text[]),
('N205','MON','Forced choice','Screener',ARRAY['SC','MON']::text[]),
('N206','MON','Indirect (norm)','Probe',ARRAY['SC','LOC','MON']::text[]),
('N207','MON','Case study','Probe',ARRAY['SC','MON','PLN']::text[]),
('N208','MON','Forced choice','Screener',ARRAY['MON','PLN']::text[]),
('N209','MON','Case study','Probe',ARRAY['SC','LOC','MON','PLN']::text[]),
('N210','MON','Forced choice','Screener',ARRAY['SC','MON']::text[]),
('N211','MON','Case study','Probe',ARRAY['INT','SC','LOC','MON','PLN']::text[]),
('N212','MON','Indirect (conditional reasoning)','Probe',ARRAY['SC','LOC','MON','PLN']::text[]),
('N213','MON','Forced choice','Screener',ARRAY['LOC','MON','PLN']::text[]),
('N214','MON','Case study','Probe',ARRAY['SC','LOC','MON','PLN']::text[]),
('N215','CON','Forced choice','Screener',ARRAY['CON','INT','LOC','PLN']::text[]),
('N216','SC','Forced choice','Screener',ARRAY['SC','LOC','PLN']::text[]),
('N217','PLN','Forced choice','Screener',ARRAY['CON','LOC','PLN']::text[]),
('N218','INT','Forced choice','Screener',ARRAY['INT','MON']::text[]),
('N219','MON','Forced choice','Screener',ARRAY['LOC','MON','PLN']::text[]),
('N220','CON','Forced choice','Screener',ARRAY['CON','SC','LOC','PLN']::text[]),
('N221','INT','Forced choice','Screener',ARRAY['CON','INT','MON','PLN']::text[]),
('N222','PLN','Forced choice','Screener',ARRAY['CON','SC','MON','PLN']::text[]),
('N223','CON','Forced choice','Screener',ARRAY['CON','SC','LOC']::text[]),
('N224','MON','Forced choice','Screener',ARRAY['SC','LOC','MON','PLN']::text[]),
('N225','INT','Forced choice','Screener',ARRAY['CON','INT','LOC','PLN']::text[]),
('N226','SC','Forced choice','Screener',ARRAY['SC','LOC','MON']::text[]),
('N227','CON','Forced choice','Screener',ARRAY['CON','SC','LOC']::text[]),
('N228','INT','Forced choice','Screener',ARRAY['CON','INT','SC','LOC']::text[]),
('N229','PLN','Forced choice','Screener',ARRAY['CON','MON','PLN']::text[]),
('N230','SC','Forced choice','Screener',ARRAY['SC','LOC']::text[]),
('N231','LOC','Forced choice','Screener',ARRAY['CON','LOC']::text[]),
('N232','MON','Forced choice','Screener',ARRAY['INT','LOC','MON']::text[]),
('N233','INT','Forced choice','Screener',ARRAY['CON','INT','SC','LOC']::text[]),
('N234','PLN','Forced choice','Screener',ARRAY['CON','SC','LOC','PLN']::text[]),
('N235','SC','Forced choice','Screener',ARRAY['SC','LOC','MON','PLN']::text[]),
('N236','CON','Forced choice','Screener',ARRAY['CON','LOC']::text[]),
('N237','INT','Forced choice','Screener',ARRAY['INT','MON']::text[]),
('N238','SC','Forced choice','Screener',ARRAY['SC','MON','PLN']::text[]),
('N239','LOC','Forced choice','Screener',ARRAY['SC','LOC','PLN']::text[]),
('N240','INT','Forced choice','Screener',ARRAY['CON','INT','LOC']::text[]),
('N241','MON','Forced choice','Screener',ARRAY['SC','LOC','MON']::text[]),
('N242','SC','Forced choice','Screener',ARRAY['CON','SC','LOC']::text[]),
('N243','PLN','Forced choice','Screener',ARRAY['CON','INT','LOC','PLN']::text[]),
('N244','CON','Forced choice','Screener',ARRAY['CON','SC','LOC']::text[]),
('N245','INT','Forced choice','Screener',ARRAY['CON','INT','LOC']::text[]),
('N246','MON','Forced choice','Screener',ARRAY['SC','LOC','MON','PLN']::text[]),
('N247','LOC','Forced choice','Screener',ARRAY['CON','LOC','PLN']::text[]),
('N248','INT','Forced choice','Screener',ARRAY['INT','LOC','MON']::text[]),
('N249','SC','Forced choice','Screener',ARRAY['SC','LOC','MON']::text[]),
('N250','CON','Forced choice','Screener',ARRAY['CON','INT','LOC']::text[]),
('N251','PLN','Forced choice','Screener',ARRAY['SC','LOC','MON','PLN']::text[]),
('N252','LOC','Forced choice','Screener',ARRAY['INT','LOC']::text[]),
('N253','MON','Forced choice','Screener',ARRAY['CON','MON','PLN']::text[]),
('N254','SC','Forced choice','Screener',ARRAY['SC','LOC']::text[]),
('N255','SC','Indirect (norm)','Probe',ARRAY['SC','MON','PLN']::text[]),
('N256','INT','Indirect (conditional reasoning)','Probe',ARRAY['INT','LOC','MON']::text[]),
('N257','LOC','Indirect (norm)','Probe',ARRAY['LOC','PLN']::text[]),
('N258','CON','Indirect (norm)','Probe',ARRAY['CON','INT','LOC','PLN']::text[]),
('N259','SC','Indirect (conditional reasoning)','Probe',ARRAY['SC','MON']::text[]),
('N260','INT','Indirect (norm)','Probe',ARRAY['INT','LOC','MON']::text[]),
('N261','PLN','Indirect (norm)','Probe',ARRAY['LOC','MON','PLN']::text[]),
('N262','LOC','Indirect (norm)','Probe',ARRAY['INT','LOC','MON','PLN']::text[]),
('N263','SC','Indirect (conditional reasoning)','Probe',ARRAY['CON','SC','LOC','PLN']::text[]),
('N264','CON','Indirect (norm)','Probe',ARRAY['CON','LOC','PLN']::text[]),
('N265','MON','Indirect (norm)','Probe',ARRAY['SC','MON','PLN']::text[]),
('N266','LOC','Indirect (norm)','Probe',ARRAY['LOC','MON','PLN']::text[]),
('N267','INT','Indirect (norm)','Probe',ARRAY['INT','MON']::text[]),
('N268','SC','Indirect (norm)','Probe',ARRAY['SC','LOC','PLN']::text[]),
('N269','PLN','Indirect (norm)','Probe',ARRAY['LOC','PLN']::text[]),
('N270','INT','Indirect (conditional reasoning)','Probe',ARRAY['CON','INT','LOC']::text[]),
('N271','SC','Indirect (norm)','Probe',ARRAY['SC','LOC','MON','PLN']::text[]),
('N272','LOC','Indirect (norm)','Probe',ARRAY['INT','SC','LOC','PLN']::text[]),
('N273','MON','Indirect (conditional reasoning)','Probe',ARRAY['SC','LOC','MON','PLN']::text[]),
('N274','SC','Indirect (conditional reasoning)','Probe',ARRAY['INT','SC','LOC','MON','PLN']::text[]),
('N275','INT','Indirect (norm)','Probe',ARRAY['CON','INT','MON']::text[]),
('N276','LOC','Indirect (norm)','Probe',ARRAY['LOC','PLN']::text[]),
('N277','CON','Indirect (conditional reasoning)','Probe',ARRAY['CON','SC','LOC']::text[]),
('N278','MON','Indirect (norm)','Probe',ARRAY['SC','LOC','MON']::text[]),
('N279','INT','Indirect (norm)','Probe',ARRAY['INT','LOC','PLN']::text[]),
('N280','PLN','Indirect (conditional reasoning)','Probe',ARRAY['SC','LOC','MON','PLN']::text[]),
('N281','SC','Indirect (conditional reasoning)','Probe',ARRAY['SC','LOC','MON','PLN']::text[]),
('N282','INT','Indirect (norm)','Probe',ARRAY['INT','MON']::text[]),
('N283','CON','Indirect (conditional reasoning)','Probe',ARRAY['CON','SC','LOC','PLN']::text[]),
('N284','LOC','Indirect (norm)','Probe',ARRAY['SC','LOC','PLN']::text[]),
('N285','INT','Case study','Probe',ARRAY['INT','LOC','MON','PLN']::text[]),
('N286','MON','Case study','Probe',ARRAY['INT','MON','PLN']::text[]),
('N287','SC','Forced choice','Screener',ARRAY['LOC','MON','PLN']::text[]),
('N288','PLN','Case study','Probe',ARRAY['SC','MON','PLN']::text[]),
('N289','INT','Case study','Probe',ARRAY['CON','INT','LOC','PLN']::text[]),
('N290','INT','Forced choice','Screener',ARRAY['CON','INT','LOC']::text[]),
('N291','LOC','Case study','Probe',ARRAY['CON','LOC','MON','PLN']::text[]),
('N292','SC','Case study','Probe',ARRAY['INT','SC','LOC','MON','PLN']::text[]),
('N293','CON','Forced choice','Screener',ARRAY['CON','LOC','PLN']::text[]),
('N294','INT','Case study','Probe',ARRAY['INT','LOC','MON','PLN']::text[]),
('N295','PLN','Case study','Probe',ARRAY['SC','MON','PLN']::text[]),
('N296','LOC','Forced choice','Screener',ARRAY['SC','LOC','PLN']::text[]),
('N297','INT','Case study','Probe',ARRAY['INT','LOC','MON','PLN']::text[]),
('N298','SC','Forced choice','Screener',ARRAY['CON','SC','LOC']::text[]),
('N299','INT','Case study','Probe',ARRAY['CON','INT','LOC']::text[]),
('N300','MON','Case study','Probe',ARRAY['SC','LOC','MON','PLN']::text[]),
('N301','INT','Forced choice','Screener',ARRAY['CON','INT','SC','LOC']::text[]),
('N302','LOC','Case study','Probe',ARRAY['INT','LOC','PLN']::text[]),
('N303','SC','Case study','Probe',ARRAY['SC','LOC','MON','PLN']::text[]),
('N304','CON','Forced choice','Screener',ARRAY['CON','INT']::text[]),
('N305','INT','Case study','Probe',ARRAY['CON','INT','MON','PLN']::text[]),
('N306','PLN','Forced choice','Screener',ARRAY['CON','MON','PLN']::text[]),
('N307','LOC','Case study','Probe',ARRAY['INT','SC','LOC','MON','PLN']::text[]),
('N308','MON','Forced choice','Screener',ARRAY['SC','LOC','MON']::text[]),
('N309','INT','Case study','Probe',ARRAY['INT','SC','LOC','MON','PLN']::text[]),
('N310','SC','Forced choice','Screener',ARRAY['SC','LOC','MON']::text[]),
('N311','CON','Case study','Probe',ARRAY['CON','INT','PLN']::text[]),
('N312','LOC','Case study','Probe',ARRAY['SC','LOC','PLN']::text[]),
('N313','INT','Forced choice','Screener',ARRAY['CON','INT','LOC']::text[]),
('N314','MON','Case study','Probe',ARRAY['LOC','MON','PLN']::text[]),
('N315','LOC','Forced choice','Screener',ARRAY['CON','INT','LOC','PLN']::text[]),
('N316','MON','Forced choice','Screener',ARRAY['LOC','MON','PLN']::text[]),
('N317','INT','Forced choice','Screener',ARRAY['CON','INT']::text[]),
('N318','SC','Forced choice','Screener',ARRAY['SC','LOC','PLN']::text[]),
('N319','LOC','Forced choice','Screener',ARRAY['PLN']::text[]),
('N320','INT','Forced choice','Screener',ARRAY['INT','MON']::text[]),
('N321','CON','Forced choice','Screener',ARRAY['CON','SC','LOC']::text[]),
('N322','PLN','Forced choice','Screener',ARRAY['SC','MON','PLN']::text[]),
('N323','INT','Forced choice','Screener',ARRAY['INT']::text[]),
('N324','SC','Forced choice','Screener',ARRAY['SC','LOC','PLN']::text[]),
('N325','MON','Forced choice','Screener',ARRAY['CON','MON']::text[]),
('N326','LOC','Forced choice','Screener',ARRAY['INT','LOC']::text[]),
('N327','PLN','Forced choice','Screener',ARRAY['SC','MON','PLN']::text[]),
('N328','INT','Forced choice','Screener',ARRAY['CON','INT','PLN']::text[]),
('N329','SC','Forced choice','Screener',ARRAY['SC','MON']::text[]),
('N330','CON','Forced choice','Screener',ARRAY['CON','LOC','PLN']::text[]),
('N331','LOC','Forced choice','Screener',ARRAY['SC','LOC','PLN']::text[]),
('N332','MON','Forced choice','Screener',ARRAY['SC','LOC','MON']::text[]),
('N333','INT','Forced choice','Screener',ARRAY['CON','INT','LOC']::text[]),
('N334','PLN','Forced choice','Screener',ARRAY['CON','LOC','PLN']::text[]),
('N335','SC','Forced choice','Screener',ARRAY['SC','MON']::text[]),
('N336','INT','Forced choice','Screener',ARRAY['CON','INT','LOC']::text[]),
('N337','CON','Forced choice','Screener',ARRAY['CON','MON']::text[]),
('N338','LOC','Forced choice','Screener',ARRAY['INT','LOC']::text[]),
('N339','MON','Forced choice','Screener',ARRAY['SC','MON']::text[]),
('N340','INT','Forced choice','Screener',ARRAY['INT','LOC','PLN']::text[]),
('N341','SC','Forced choice','Screener',ARRAY['SC','LOC','PLN']::text[]),
('N342','CON','Forced choice','Screener',ARRAY['CON','INT','PLN']::text[]),
('N343','PLN','Forced choice','Screener',ARRAY['CON','LOC','PLN']::text[]),
('N344','LOC','Forced choice','Screener',ARRAY['INT','LOC','PLN']::text[]),
('N345','SC','Forced choice','Screener',ARRAY['SC','MON']::text[]),
('N346','INT','Forced choice','Screener',ARRAY['INT','MON']::text[]),
('N347','CON','Forced choice','Screener',ARRAY['CON','LOC','PLN']::text[]),
('N348','MON','Forced choice','Screener',ARRAY['SC','MON','PLN']::text[]),
('N349','PLN','Forced choice','Screener',ARRAY['SC','LOC','PLN']::text[]),
('N350','INT','Forced choice','Screener',ARRAY['INT']::text[]),
('N351','SC','Forced choice','Screener',ARRAY['SC','PLN']::text[]),
('N352','LOC','Forced choice','Screener',ARRAY['INT','LOC']::text[]),
('N353','MON','Forced choice','Screener',ARRAY['MON','PLN']::text[]),
('N354','CON','Forced choice','Screener',ARRAY['CON','SC']::text[]),
('N355','INT','Forced choice','Screener',ARRAY['INT','SC','MON']::text[]),
('N356','PLN','Forced choice','Screener',ARRAY['LOC','PLN']::text[]),
('N357','SC','Forced choice','Screener',ARRAY['SC','MON']::text[]),
('N358','INT','Forced choice','Screener',ARRAY['CON','INT','LOC']::text[]),
('N359','LOC','Forced choice','Screener',ARRAY['LOC','PLN']::text[]),
('N360','MON','Forced choice','Screener',ARRAY['SC','MON']::text[]),
('N361','CON','Forced choice','Screener',ARRAY['CON','MON','PLN']::text[]),
('N362','INT','Forced choice','Screener',ARRAY['CON','INT','LOC']::text[]),
('N363','SC','Forced choice','Screener',ARRAY['SC','LOC']::text[]),
('N364','PLN','Forced choice','Screener',ARRAY['LOC','MON','PLN']::text[]),
('N365','INT','Forced choice','Screener',ARRAY['INT','MON']::text[]),
('N366','CON','Forced choice','Screener',ARRAY['CON','SC','LOC']::text[]),
('N367','MON','Forced choice','Screener',ARRAY['MON','PLN']::text[]),
('N368','LOC','Forced choice','Screener',ARRAY['SC','LOC']::text[]),
('N369','INT','Forced choice','Screener',ARRAY['INT','PLN']::text[]),
('N370','SC','Forced choice','Screener',ARRAY['SC','MON']::text[]),
('N371','CON','Forced choice','Screener',ARRAY['CON','INT']::text[]),
('N372','PLN','Forced choice','Screener',ARRAY['MON','PLN']::text[]),
('N373','LOC','Forced choice','Screener',ARRAY['LOC','PLN']::text[]),
('N374','MON','Forced choice','Screener',ARRAY['SC','MON']::text[]),
('N375','INT','Forced choice','Screener',ARRAY['CON','INT']::text[]),
('N376','SC','Forced choice','Screener',ARRAY['SC','MON']::text[]),
('N377','LOC','Forced choice','Screener',ARRAY['INT','LOC']::text[]),
('N378','CON','Forced choice','Screener',ARRAY['CON','LOC','PLN']::text[]),
('N379','MON','Forced choice','Screener',ARRAY['LOC','MON','PLN']::text[]),
('N380','INT','Forced choice','Screener',ARRAY['INT','LOC','MON']::text[]),
('N381','SC','Forced choice','Screener',ARRAY['SC','LOC','PLN']::text[]),
('N382','PLN','Forced choice','Screener',ARRAY['CON','PLN']::text[]),
('N383','LOC','Forced choice','Screener',ARRAY['SC','LOC']::text[]),
('N384','MON','Forced choice','Screener',ARRAY['SC','MON']::text[]),
('N385','INT','Forced choice','Screener',ARRAY['INT','LOC','MON']::text[]),
('N386','CON','Forced choice','Screener',ARRAY['CON','SC','LOC']::text[]),
('N387','PLN','Forced choice','Screener',ARRAY['CON','LOC','PLN']::text[]),
('N388','SC','Forced choice','Screener',ARRAY['SC','MON']::text[]),
('N389','INT','Forced choice','Screener',ARRAY['INT','SC','LOC']::text[]),
('N390','MON','Forced choice','Screener',ARRAY['LOC','MON','PLN']::text[]),
('N391','LOC','Forced choice','Screener',ARRAY['CON','LOC']::text[]),
('N392','SC','Forced choice','Screener',ARRAY['SC','MON']::text[]),
('N393','INT','Forced choice','Screener',ARRAY['CON','INT']::text[]),
('N394','PLN','Forced choice','Screener',ARRAY['MON','PLN']::text[]),
('N395','LOC','Forced choice','Screener',ARRAY['SC','LOC']::text[]),
('N396','MON','Forced choice','Screener',ARRAY['INT','MON']::text[]),
('N397','INT','Forced choice','Screener',ARRAY['INT','SC','MON']::text[]),
('N398','PLN','Forced choice','Screener',ARRAY['SC','MON','PLN']::text[]),
('N399','CON','Forced choice','Screener',ARRAY['CON','SC','LOC']::text[]),
('N400','LOC','Forced choice','Screener',ARRAY['LOC','PLN']::text[]);

-- ============ server-side adaptive session ============
create table if not exists public.assessment_sessions (
  id           uuid primary key default gen_random_uuid(),
  user_id      uuid not null references auth.users(id) on delete cascade,
  user_type    text not null default 'ind',
  scores       jsonb not null,
  counts       jsonb not null,
  lastchg      jsonb not null default '{}'::jsonb,
  primw        jsonb not null,
  asked        text[] not null default '{}',
  recent       text[] not null default '{}',
  seed_order   text[] not null default '{}',
  choice_hist  text[] not null default '{}',
  times        numeric[] not null default '{}',
  desirable    int not null default 0,
  n            int not null default 0,
  pending      text,
  path_len     int not null default 0,
  ui_prog      numeric not null default 0.05,
  current_item text,
  finished_at  timestamptz,
  created_at   timestamptz not null default now()
);
alter table public.assessment_sessions enable row level security;
drop policy if exists "own sessions read" on public.assessment_sessions;
create policy "own sessions read" on public.assessment_sessions
  for select using (auth.uid() = user_id);
create index if not exists sessions_user_idx on public.assessment_sessions(user_id, created_at desc);

-- pick an unasked item, optionally within one dimension, preferring probes,
-- avoiding a repeated question style
create or replace function public._pick_item(
  p_asked text[], p_dim text, p_prefer_probe boolean, p_avoid_style text)
returns text language plpgsql stable security definer set search_path = public as $fn$
declare v text;
begin
  -- preferred: right dimension, different style, probe if requested
  select m.item_id into v from public.scoring_meta m
   where (p_dim is null or m.dim = p_dim)
     and not (m.item_id = any(coalesce(p_asked,'{}'::text[])))
     and (p_avoid_style is null or m.style <> p_avoid_style)
     and (not p_prefer_probe or m.role = 'Probe')
   order by random() limit 1;
  if v is not null then return v; end if;

  -- relax the probe preference
  select m.item_id into v from public.scoring_meta m
   where (p_dim is null or m.dim = p_dim)
     and not (m.item_id = any(coalesce(p_asked,'{}'::text[])))
     and (p_avoid_style is null or m.style <> p_avoid_style)
   order by random() limit 1;
  if v is not null then return v; end if;

  -- relax the style constraint
  select m.item_id into v from public.scoring_meta m
   where (p_dim is null or m.dim = p_dim)
     and not (m.item_id = any(coalesce(p_asked,'{}'::text[])))
   order by random() limit 1;
  return v;
end $fn$;

-- choose the next item for a session
create or replace function public._next_item(p_id uuid)
returns text language plpgsql security definer set search_path = public as $fn$
declare
  s public.assessment_sessions;
  dims text[] := array['CON','INT','SC','LOC','MON','PLN'];
  v_item text; v_avoid text; d text; best numeric; cur numeric; bestd text; rl int;
begin
  select * into s from public.assessment_sessions where id = p_id;
  if s is null then return null; end if;

  rl := coalesce(array_length(s.recent,1),0);
  if rl >= 2 and s.recent[rl] = s.recent[rl-1] then v_avoid := s.recent[rl]; end if;

  -- 1) opening questions: one light touch per dimension
  if s.path_len < coalesce(array_length(s.seed_order,1),0) then
    v_item := s.seed_order[s.path_len + 1];
    if v_item is not null and not (v_item = any(s.asked)) then return v_item; end if;
  end if;

  -- 2) red-flag follow-up
  if s.pending is not null then
    v_item := public._pick_item(s.asked, s.pending, true, v_avoid);
    if v_item is not null then return v_item; end if;
  end if;

  -- 3) consistency re-check every 7 answers, on the most extreme dimension
  if s.path_len > 0 and s.path_len % 7 = 0 then
    best := null; bestd := null;
    foreach d in array dims loop
      if coalesce((s.counts->>d)::int,0) >= 2 then
        cur := abs(coalesce((s.scores->>d)::numeric,50) - 50);
        if best is null or cur > best then best := cur; bestd := d; end if;
      end if;
    end loop;
    if bestd is not null then
      v_item := public._pick_item(s.asked, bestd, false, v_avoid);
      if v_item is not null then return v_item; end if;
    end if;
  end if;

  -- 4) the dimension we know least about
  for d in
    select x from unnest(dims) x
     order by greatest(0, 6 - coalesce((s.counts->>x)::numeric,0))/6
            + (1 - abs(coalesce((s.scores->>x)::numeric,50) - 50)/50) desc
  loop
    v_item := public._pick_item(s.asked, d, false, v_avoid);
    if v_item is not null then return v_item; end if;
  end loop;

  -- 5) anything not yet asked
  return public._pick_item(s.asked, null, false, null);
end $fn$;

-- has the session gathered enough evidence?
create or replace function public._is_done(p_id uuid)
returns boolean language plpgsql security definer set search_path = public as $fn$
declare s public.assessment_sessions; dims text[] := array['CON','INT','SC','LOC','MON','PLN'];
        d text; sc numeric; ct int; lc numeric;
begin
  select * into s from public.assessment_sessions where id = p_id;
  if s.path_len >= 55 then return true; end if;
  if s.path_len < 25 then return false; end if;
  foreach d in array dims loop
    ct := coalesce((s.counts->>d)::int,0);
    sc := coalesce((s.scores->>d)::numeric,50);
    lc := coalesce((s.lastchg->>d)::numeric,99);
    if ct < 6 then return false; end if;
    if not (sc >= 72 or sc <= 28 or lc < 1.2) then return false; end if;
  end loop;
  return true;
end $fn$;

-- ============ public API ============
create or replace function public.assessment_start(p_type text default 'ind')
returns jsonb language plpgsql security definer set search_path = public as $fn$
declare v_uid uuid := auth.uid(); v_id uuid; v_seed text[]; v_item text;
        dims text[] := array['CON','INT','SC','LOC','MON','PLN']; d text;
        v_sc jsonb := '{}'::jsonb; v_ct jsonb := '{}'::jsonb; v_pw jsonb := '{}'::jsonb;
        v_last timestamptz;
begin
  if v_uid is null then raise exception 'AUTH_REQUIRED'; end if;

  if not coalesce((select allow_retake from public.profiles where id = v_uid), false) then
    select max(created_at) into v_last from public.test_results where user_id = v_uid;
    if v_last is not null and v_last > now() - interval '90 days' then
      raise exception 'RETEST_LOCKED_UNTIL %', to_char(v_last + interval '90 days','YYYY-MM-DD');
    end if;
  end if;

  foreach d in array dims loop
    v_sc := jsonb_set(v_sc, array[d], to_jsonb(50::numeric));
    v_ct := jsonb_set(v_ct, array[d], to_jsonb(0));
    v_pw := jsonb_set(v_pw, array[d], '[]'::jsonb);
  end loop;

  select array_agg(item_id order by random()) into v_seed
    from (select distinct on (dim) item_id, dim
            from public.scoring_meta where style = 'Forced choice'
           order by dim, item_id) t;

  insert into public.assessment_sessions(user_id,user_type,scores,counts,primw,seed_order)
  values (v_uid, coalesce(p_type,'ind'), v_sc, v_ct, v_pw, coalesce(v_seed,'{}'))
  returning id into v_id;

  v_item := public._next_item(v_id);
  update public.assessment_sessions set current_item = v_item where id = v_id;

  return jsonb_build_object('session_id',v_id,'item_id',v_item,'done',false,
                            'progress',0.05,'stage',1,'asked',0);
end $fn$;
revoke all on function public.assessment_start(text) from public;
grant execute on function public.assessment_start(text) to authenticated;

create or replace function public.assessment_answer(
  p_session uuid, p_choice int, p_seconds numeric default null, p_pos text default null)
returns jsonb language plpgsql security definer set search_path = public as $fn$
declare
  K constant numeric := 0.06;
  s public.assessment_sessions; m public.scoring_meta;
  dims text[] := array['CON','INT','SC','LOC','MON','PLN']; d text;
  v_item text; v_n int; v_w numeric; v_mean numeric; v_cur numeric; v_nd numeric;
  v_flag text; v_best int; v_bestsum numeric; v_sum numeric;
  v_sc jsonb; v_ct jsonb; v_lc jsonb; v_pw jsonb;
  v_next text; v_done boolean; v_settled numeric := 0; v_est numeric; v_raw numeric; v_prog numeric; v_stage int;
begin
  select * into s from public.assessment_sessions where id = p_session;
  if s is null or s.user_id <> auth.uid() then raise exception 'BAD_SESSION'; end if;
  if s.finished_at is not null then raise exception 'SESSION_FINISHED'; end if;
  v_item := s.current_item;
  if v_item is null then raise exception 'NO_CURRENT_ITEM'; end if;

  select count(*) into v_n from public.scoring_items si where si.item_id = v_item;
  if p_choice < 0 or p_choice >= v_n then raise exception 'BAD_CHOICE'; end if;
  select * into m from public.scoring_meta where item_id = v_item;

  v_sc := s.scores; v_ct := s.counts; v_lc := s.lastchg; v_pw := s.primw;

  foreach d in array dims loop
    execute format('select avg(w_%s)::numeric from public.scoring_items where item_id=$1', lower(d))
      into v_mean using v_item;
    execute format('select w_%s::numeric from public.scoring_items where item_id=$1 and choice_idx=$2', lower(d))
      into v_w using v_item, p_choice;
    v_w := round(v_w - v_mean, 3);
    v_cur := coalesce((v_sc->>d)::numeric,50);
    if    v_w > 0 then v_nd := v_cur + K*v_w*(100-v_cur);
    elsif v_w < 0 then v_nd := v_cur + K*v_w*v_cur;
    else  v_nd := v_cur; end if;
    v_nd := greatest(0, least(100, v_nd));
    v_lc := jsonb_set(v_lc, array[d], to_jsonb(abs(v_nd - v_cur)));
    v_sc := jsonb_set(v_sc, array[d], to_jsonb(v_nd));
  end loop;

  foreach d in array m.measured loop
    v_ct := jsonb_set(v_ct, array[d], to_jsonb(coalesce((v_ct->>d)::int,0) + 1));
  end loop;

  -- desirability: the choice with the highest total weight
  select si.choice_idx into v_best from public.scoring_items si
   where si.item_id = v_item
   order by (si.w_con+si.w_int+si.w_sc+si.w_loc+si.w_mon+si.w_pln) desc, si.choice_idx asc
   limit 1;

  execute format('select w_%s::numeric from public.scoring_items where item_id=$1 and choice_idx=$2', lower(m.dim))
    into v_w using v_item, p_choice;
  v_pw := jsonb_set(v_pw, array[m.dim], (v_pw->m.dim) || to_jsonb(v_w));

  select flag into v_flag from public.scoring_items
   where item_id = v_item and choice_idx = p_choice;

  update public.assessment_sessions set
    scores = v_sc, counts = v_ct, lastchg = v_lc, primw = v_pw,
    asked = array_append(asked, v_item),
    recent = array_append(recent, m.style),
    choice_hist = case when p_pos is null then choice_hist else array_append(choice_hist, p_pos) end,
    times = case when p_seconds is null then times else array_append(times, p_seconds) end,
    desirable = desirable + case when v_best = p_choice then 1 else 0 end,
    n = n + 1,
    path_len = path_len + 1,
    pending = case when v_flag like 'RED:%' then split_part(v_flag,':',2) else null end
  where id = p_session;

  v_done := public._is_done(p_session);
  if v_done then
    v_next := null;
  else
    v_next := public._next_item(p_session);
    if v_next is null then v_done := true; end if;
  end if;

  select * into s from public.assessment_sessions where id = p_session;
  foreach d in array dims loop
    if coalesce((s.counts->>d)::int,0) >= 6
       and (coalesce((s.scores->>d)::numeric,50) >= 72
         or coalesce((s.scores->>d)::numeric,50) <= 28
         or coalesce((s.lastchg->>d)::numeric,99) < 1.2)
    then v_settled := v_settled + 1; end if;
  end loop;
  v_est  := 25 + (1 - v_settled/6) * 30;
  v_raw  := least(0.97, 0.05 + 0.95 * (s.path_len::numeric / greatest(v_est,1)));
  v_prog := greatest(s.ui_prog, v_raw);
  v_stage := case when v_prog >= 0.75 then 4 when v_prog >= 0.5 then 3
                  when v_prog >= 0.25 then 2 else 1 end;

  update public.assessment_sessions
     set current_item = v_next, ui_prog = v_prog
   where id = p_session;

  return jsonb_build_object('done',v_done,'item_id',v_next,
                            'progress',round(v_prog,3),'stage',v_stage,'asked',s.path_len);
end $fn$;
revoke all on function public.assessment_answer(uuid,int,numeric,text) from public;
grant execute on function public.assessment_answer(uuid,int,numeric,text) to authenticated;
