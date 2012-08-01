if false
then
  (
    cd htmls; 
    for i in $(seq 0 29)
    do
      wget http://www.lequipe.fr/Jo/JoTableauMedailleE_$((1896 + $i * 4)).html
    done
  )
fi

if true
then
  (
    cd htmls
    for html in *.html
    do
      year=$(echo $html | sed -re 's,^.*E_(.*)\.html,\1,g')
      cat $html | tr -cd '[:print:]' | sed -nre '/TABLEAU/ p ; ' | sed -re 's,^.*Total</div></div>(.*)</div><div class="clear">.*$,\1,g' | sed -re 's#<div class="row rowp[^"]*"><div class="rang"><strong>([^<]*)</strong></div><div class="col-416"><span class="drapeau ([^<]*)"></span><strong><a[^>]*>([^<]*)</a></strong></div><div class="col-50 tar">([^<]*)</div><div class="col-50 tar">([^<]*)</div><div class="col-50 tar">([^<]*)</div><div class="col-50 tar">([^<]*)</div></div>#"\1","\2","\3","\4","\5","\6","\7"$#g' | perl -MHTML::Entities -ne 'print decode_entities($_)' | iconv -fiso8859-15 -tutf8 | xargs -d$ -n1 | sed -re 's#^(.*)$#[\1],#g' | xargs -d'\n' | sed -re 's#^(.*),$#['$year', [\1]],#g'
    done | xargs -d'\n' | sed -re 's#^(.*),$#[\1]#g' | python -mjson.tool > ../data.json
  )
fi
