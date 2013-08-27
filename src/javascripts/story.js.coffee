class Story

  constructor: () ->
    @ready = false
  
  setup: () ->
    $("#results").append("<div id='stories'><div id='demand_story' class='story'></div><div id='supply_story' class='story'></div><div id='ghg_story' class='story'></div><div class='clear'></div></div>")
    @ready = true
  
  teardown: () ->
    $("#results").empty()
    @ready = false
  
  updateResults: (@pathway) ->
    @setup() unless @ready
    @choices = twentyfifty.choices
    element = $('#demand_story')
    element.empty()

    @stories_for_choices element, "Homes in 2050", 14, 15, 16, 17, 18, 20, 21
    @heating_choice_table element, @pathway.heating.residential
  
    @stories_for_choices element, "Businesses in 2050", 23, 24, 25, 26, 28, 29
    @heating_choice_table element, @pathway.heating.commercial

    @stories_for_choices element, "Personal transport in 2050", 2, 3, 4, 5
    @stories_for_choices element, "Commercial transport in 2050", 7, 8, 9, 10, 11
  
    @stories_for_choices element, "Industry in 2050", 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 51

    element = $('#supply_story')
    element.empty()
    @stories_for_choices element, "Wind in 2050", 53, 54
    @stories_for_choices element, "Solar in 2050", 55, 60
    @stories_for_choices element, "Hydro in 2050", 56
    @stories_for_choices element, "Geothermal in 2050", 57
    @stories_for_choices element, "Bioenergy, farming and waste in 2050", 65, 70, 71, 72, 73, 74
    @stories_for_choices element, "Thermal power stations in 2050", 61
    @stories_for_choices element, "Carbon Capture Storage (CCS)", 63, 64
    @stories_for_choices element, "Imports in 2050", 67, 68, 77, 80
    
    element = $('#ghg_story')
    element.empty()
    @electricity_generation_capacity_table element
    element.append("<h4>Greenhouse gases</h4>")
    element.append("<p>2050 emissions will be #{@pathway.ghg.percent_reduction_from_1990}% below 1990 levels.</p>")
    element.append("<p>International aviation and shipping emissions are not included in the Belgium 2050 target but are included here to enable emissions from all sectors to be considered.</p>")
    element.append("<h4>Energy security</h4>")
    @security_tables element

    @stories_for_choices element, "Backgroup hypothesis", 0, 52
    
  stories_for_choices: (element,title,rows...) ->
    element.append("<h4>#{title}</h4>") if title?
    text = []
    for row in rows
      choice = choices[row] - 1
      if choice % 1 == 0.0
        text.push(window.twentyfifty.longDescriptions[row][choice])
      else
        text.push("Between #{window.twentyfifty.longDescriptions[row][Math.floor(choice)]} and #{window.twentyfifty.longDescriptions[row][Math.ceil(choice)]}")
      
    element.append("<p>#{text.join(". ")}.</p>")
  
  heating_choice_table: (element,heat) ->
    html = []
    html.push "<table class='heating_choice'>"
    html.push "<tr><th>Type of heater</th><th class='target'>2050 proportion of heating</th></tr>"
    values = []
    for own name, value of heat
      values.push({name:name,value:value})
    values.sort((a,b) -> b.value - a.value)
    for value in values
      if value.value > 0.01
        html.push "<tr><td>#{value.name}</td><td class='target'>#{Math.round(value.value*100)}%</td></tr>"
    html.push "</table>"
    element.append(html.join(''))

  security_tables: (element) ->
    data = @pathway.security
    html = []
    html.push "<table class='heating_choice'>"
    html.push "<tr><th></th><th class='target'>2010</th><th class='target'>2050</th></tr>"
    html.push "<tr><td>Imported energy (TWh)</td><td class='target'>#{Math.round(data.imports['2010'])}</td><td class='target'>#{Math.round(data.imports['2050'])}</td></tr>"
    html.push "<tr><td>% of total</td><td class='target'>#{Math.round(data.import_proportion['2010']*100)}%</td><td class='target'>#{Math.round(data.import_proportion['2050']*100)}%</td></tr>"
    html.push "<tr><td>Number of technologies to cover 85% of supply</td><td class='target'>#{Math.round(data.number_of_technologies_to_cover_eighty_five_percent['2010'])}</td><td class='target'>#{Math.round(data.number_of_technologies_to_cover_eighty_five_percent['2050'])}</td></tr>"
    html.push("</table>")
    element.append(html.join(''))

    
  electricity_generation_capacity_table: (element) ->
    html = []
    html.push "<table class='heating_choice'>"
    html.push "<tr><th>GW Capacity</th><th class='target'>2010</th><th class='target'>2050</th></tr>"
    values = []
    for own name, data of @pathway.electricity.capacity
      values.push({name:name,d2010:data[0],d2050:data[8]})
    values.sort((a,b) -> a.d2050 - b.d2050)
    for value in values
      unless (value.d2010+value.d2050) == 0.0
        html.push "<tr><td>#{value.name}</td><td class='target'>#{Math.round(value.d2010)}</td><td class='target'>#{Math.round(value.d2050)}</td></tr>"
    html.push "</table>"
    element.append(html.join(''))
      

window.twentyfifty.views['story'] = new Story
