/**/
--- Tabela de Redes
  select *
          from IM_REDEENT
         where tipo_ent = 0
           and cod_ent in
               (SELECT cod_med
                  from im_med a
                 where a.odonto in ('T', 'K', 'X', 'B'))
           and cod_rede not in (5) and
         order by cod_ent;


--- Cursor Insert
declare
  cursor c1 is
    select DISTINCT A.COD_MED
      from temp_rede_18_03_2021 a left join im_med b
      on a.cod_med = b.cod_med
     where 1 = 1
       and ASSISTENCIA_ODONTOLOGICA = 'SIM'
       and COD_HOSP_CORPO_CLINICO is not null
       and b.cancelado = 'F'
       and exists
     (select count(1)
              from im_hosp cz, temp_rede_18_03_2021 a
             where cz.cod_hosp = '0'||a.cod_hosp_corpo_clinico)
             AND A.COD_MED NOT IN ('03154','04998','05819','05016','11169','05148','05398','02789','06157','10909','10185','06344','03435','05697','06189','03408','03679','03540','02694','03380','03144','04975','05490','03208','06330','06523','10789','03509','03741','06248','03529','03222','02796','03323','03399','03701','02776','03611','03507','05861','03207','02935','06082','03699','04993','04993','05213','06429','03387','06217','11221','02741','05098','05207','06369','05121','06354','05119','03036','03268','03205','06374','03641','03193','02800','03739','05766','03579','02987','06558','06706','10785','02959','10840','04995','11278','05217','03194','02867','06599','03731','06301','05340','11098','11167','05101','03295','06044','02874','03251','05737','06256','05546','03278','05327','06692','06261','05966','02770','04969','03726','03358','03127','06456','05236','06625','10783','05145','03600','05504','03471','11082','03574','02977','03203','06236','06377','06745','05466','06605','03686','10788','06691','03155','05001','03368','05051','11240','05004','03386','03356','03115','06693','03644','03397','03515','05442','05956','03138','05104','05553','05553','05083','03133','03382','04903','02732','05686','03566','02847','02945','05907','05381','03300','06311','05006','02718','02774','10796','03597','03060','06074','02843','06451','06228','02809','10808','05263','06534','10801','06448','06527','06297','02869','02999','05446','05076','10208','02996','03298','02751','06231','06015','06351','03655','03004','05471','03753','10828','03631','10170','03068','06571','03202','03545','02904','10716','02888','03598','11095','03375','03264','03314','05313','06055','02711','05974','05480','05503','03698','03400','02875','03284','02984','05240','11254','11189','03640','10767','05206','06624','11100','03162','05165','03151','06019','02877','03289','03617','02833','05011','03152','03080','05754','05948','03646','05013','02721','02721','11270','05399','05064','03181','03232','06463','10824','05451','03722','03009','03703','02797','11099','02916','03355','03145','03665','06387','05755','04960','10997','03615','06329','03599','05218','11054','03580','06080','05461','09880','03674','03607','03733','03008','06670','11256','03040','05616','03645','06108','06519','11032','03737','11012','03150','03406');
begin
  for regc1 in c1 loop
    begin
      INSERT INTO IM_REDEENT
      VALUES
        (5, regc1.cod_med, 0, 'F', null, 'F', null, null);
    end;
  end loop;
end;

---
/*
create table temp_rede_18_03_2021 as
  select COD_MED,
         NOME    as NOME_COMPLETO,
         N_CRM   AS CODIGO_GRUPO,
         ODONTO  AS ASSISTENCIA_ODONTOLOGICA,
         COD_MED AS COD_HOSP_CORPO_CLINICO
    from im_med
   where 1 = 0;
*/
   
--- Criação 01
create table temp_rede_18_03_2021(COD_MED varchar2(5), 
       NOME_COMPLETO varchar2(80), 
       CODIGO_GRUPO varchar2(3), 
       ASSISTENCIA_ODONTOLOGICA varchar2(3), 
       COD_HOSP_CORPO_CLINICO varchar2(5))

--- Verificação de Registros Importados 02
  select count(*)
    from temp_rede_18_03_2021 a, im_med b
   where ASSISTENCIA_ODONTOLOGICA = 'SIM'
     and COD_HOSP_CORPO_CLINICO is not null
     and b.cod_med(+) = a.cod_med
     and b.cancelado = 'F' 
  -- = 2190 / Base: 1803
   alter table temp_rede_18_03_2021 modify ASSISTENCIA_ODONTOLOGICA
   varchar2(3)
  
--- Chamadas Base
    select * from temp_rede_18_03_2021 c DROP TABLE temp_rede_18_03_2021
    select * from im_hosp where cod_hosp = 5404
            
-- Conferência Resultados
select *
  from im_redeent b
  left join temp_rede_18_03_2021 a
    on B.cod_ent = a.cod_med
    WHERE B.TIPO_ENT = 0
    AND COD_REDE = 5
    AND B.COD_ENT IN(SELECT DISTINCT(COD_MED) FROM temp_rede_18_03_2021)

SELECT COD_ENT, COUNT(1) FROM IM_REDEENT WHERE COD_REDE = 5 AND TIPO_ENT = 0 HAVING COUNT(COD_ENT) > 1 GROUP BY COD_ENT