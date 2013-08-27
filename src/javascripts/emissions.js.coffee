class EmissionsCharts

  setup: () ->
    target = $('#results')
    target
      .append("<div id='emissions_by_sector' class='chart'></div>")
      .append("<div id='emissions_by_category' class='chart'></div>")
      .append("<div id='not_used' class='chart'></div>")


    @emissions_by_sector_chart = new Highcharts.Chart(
      chart:
        renderTo: 'emissions_by_sector'
      title: { text: 'Belgian greenhouse gas emissions by sector' },
      subtitle: { text: "MtCO<sub>2</sub>e/yr"},
      yAxis: { title: null, min: -50, max: 200 },
      series: []
    )

    @emissions_by_category_chart = new Highcharts.Chart(
      chart:
        renderTo: 'emissions_by_category'
      title: { text: 'Belgian greenhouse gas emissions by category' },
      subtitle: { text: "MtCO<sub>2</sub>e/yr"},
      yAxis: { title: null, min: -50, max: 200 },
      series: []
    )

  teardown: () ->
    $('#results').empty()
    @emissions_by_sector_chart = null
    @emissions_by_category_chart = null
    
  updateResults: (@pathway) ->
    @setup() unless @emissions_by_sector_chart? && @emissions_by_category_chart?

    # Emissions by sector
    titles = [
      "Hydrocarbon fuel power generation"
      "Nuclear power generation"
      "National renewable power generation"
      "Distributed renewable power generation"
      "Agriculture and waste"
      "Electricity distribution, storage, and balancing"
      "H2 Production"
      "Heating"
      "Lighting and appliances"
      "Industry"
      "Transport"
      "Food consumption [UNUSED]"
      "Geosequestration"
      "Fossil fuel production"
      "Transfers"
      "District heating"
    ]

    i = 0
    for name in titles
      data = @pathway['ghg_by_sector'][name]
      if @emissions_by_sector_chart.series[i]?
        @emissions_by_sector_chart.series[i].setData(data,false)
      else
        @emissions_by_sector_chart.addSeries({name:name,data:data},false)
        i++
        
    # Emissions target line
    data = @pathway['ghg']["TARGETS"]
    if @emissions_by_sector_chart.series[i]?
      @emissions_by_sector_chart.series[i].setData(data,false)
    else
      @emissions_by_sector_chart.addSeries({type: 'line', name: 'Targets', data: data, lineColor:'#fff', color:'#fff',dashStyle:'Dot', lineWidth:2},false)
      i++

    # Net emissions line
    data = @pathway['ghg']["Total net of biomass excl. Int'l aviation"]
    if @emissions_by_sector_chart.series[i]?
      @emissions_by_sector_chart.series[i].setData(data,false)
    else
      @emissions_by_sector_chart.addSeries({type: 'line', name: "Total net emissions excl. Int'l aviation",data:data, lineColor: '#000', color: '#000',lineWidth:2, shadow: true},false)
      i++

    # Emissions by category
    titles = ['Bioenergy credit','Carbon capture','International Aviation and Shipping','Industrial Processes','Solvent and Other Product Use','Agriculture','Land-Use, Land-Use Change and Forestry','Waste','Other','Fuel Combustion']
    i = 0
    for name in titles
      data = @pathway['ghg'][name]
      if @emissions_by_category_chart.series[i]?
        @emissions_by_category_chart.series[i].setData(data,false)
      else
        @emissions_by_category_chart.addSeries({name:name,data:data},false)
        i++

    # Emissions target line
    data = @pathway['ghg']["TARGETS"]
    if @emissions_by_category_chart.series[i]?
      @emissions_by_category_chart.series[i].setData(data,false)
    else
      @emissions_by_category_chart.addSeries({type: 'line', name: 'Targets', data: data, lineColor:'#fff', color:'#fff',dashStyle:'Dot', lineWidth:2},false)
      i++

    # Net emissions line
    data = @pathway['ghg']["Total net of biomass excl. Int'l aviation"]
    if @emissions_by_category_chart.series[i]?
      @emissions_by_category_chart.series[i].setData(data,false)
    else
      @emissions_by_category_chart.addSeries({type: 'line', name: "Total net emissions excl. Int'l aviation",data:data, lineColor: '#000', color: '#000',lineWidth:2, shadow: true},false)
      i++

    @emissions_by_sector_chart.redraw()
    @emissions_by_category_chart.redraw()
    
window.twentyfifty.views['emissions'] = new EmissionsCharts
