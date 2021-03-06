class ig.Strom
  (@parentElement) ->
    data = d3.tsv.parse ig.data['rusko-popstrom'], (row) ->
      for i, d of row
        row[i] = parseInt d, 10
      row

    scale = d3.scale.linear!
      ..domain [0 1319896]
      ..range [0 50]

    f = ig.utils.formatNumber
    @lineHeight = 4px
    @startYear = 2010
    @element = @parentElement.append \div
      ..attr \class \tree
      ..selectAll \div.line .data data .enter!append \div
        ..attr \class "line"
        ..on \mouseover @~highlightYear
        ..on \touchstart @~highlightYear
        ..on \mouseout @~downlightYear
        ..append \div
          ..attr \class "muzi bar"
          ..style \width -> "#{scale it.muzi}%"
        ..append \div
          ..attr \class "zeny bar"
          ..style \width -> "#{scale it.zeny}%"
        ..append \div
          ..attr \class "muzi oppbar"
          ..style \left -> "#{50 + scale it.muzi}%"
    @popisky = @element.append \div
      ..attr \class \popisky
    @addPopisek do
      2010
      2010
      "Nejmladší děti – ročník 2010"
      "left"
    @addPopisek do
      1910
      1910
      "Nejstarší lidé – ročník 1910"
      "left"
    @addPopisek do
      1980
      1980
      "Kolem 30 let věku začnou převažovat ženy"
      "right"
    @addPopisek do
      1960
      1950
      "Žen po padesátce je o pětinu víc, než mužů"
      "right"
    @addPopisek do
      1940
      1930
      "Sedmdesátiletých mužů je poloviční počet, než žen"
      "right"
    @addPopisek do
      2000
      1990
      "Nenarozená generace 90. let"
      "right"
    @addPopisek do
      1945
      1942
      "Nenarozené děti 2. sv. války"
      "left"

  highlightYear: (line) ->
    @downlightYear!
    year = @startYear - line.vek
    ratio = line.zeny / line.muzi
    suff = if 0.95 < ratio < 1.05
      "<b>podobně</b> jako mužů"
    else if ratio > 1
      "<b>#{ig.utils.formatNumber ratio, 1} × více</b> než mužů"
    else
      "<b>#{ig.utils.formatNumber (1 / ratio), 1} × méně</b> než mužů"
    @popisek1 = @addPopisek year, year, "Ročník #{year}: <b>#{ig.utils.formatNumber line.muzi}</b> mužů", "left", yes
    @popisek2 = @addPopisek year, year, "<b>#{ig.utils.formatNumber line.zeny}</b> žen<br>(#suff)", "right", yes

  downlightYear: ->
    if @popisek1
      @popisek1.remove!
      @popisek1 = null
    if @popisek2
      @popisek2.remove!
      @popisek2 = null


  addPopisek: (fromYear, toYear, text, align="left", active=no) ->
    height = Math.max do
      Math.abs (fromYear - toYear) * @lineHeight
      1
    top = (@startYear - fromYear) * @lineHeight

    @popisky.append \div
      ..attr \class "popisek #align"
      ..classed \single-line height == 1
      ..classed \active active
      ..style \top "#{top}px"
      ..style \height "#{height}px"
      ..append \div
        ..style \top "#{height * 0.5}px"
        ..attr \class \content
        ..html text
