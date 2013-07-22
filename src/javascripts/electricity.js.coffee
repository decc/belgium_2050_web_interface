class Electricity

  setup: () ->
    target = $('#results')
    target.append("<div id='demand_chart' class='chart'></div>")
      .append("<div id='supply_chart' class='chart'></div>")
      .append("<div id='emissions_chart' class='chart'></div>")

    @demand_chart = new Highcharts.Chart({
      chart: { renderTo: 'demand_chart' },
      title: { text: 'Belgian electricity demand' },
      subtitle: { text: "TWh/yr of electricity"},
      yAxis: { title: null, min: 0, max: 700 },
      series: []
    })
    @supply_chart = new Highcharts.Chart({
      chart: { renderTo: 'supply_chart' },
      title: { text: 'Belgian electricity supply' },
      subtitle: { text: "TWh/yr of electricity"},
      yAxis: { title: null, min: 0, max: 700 },
      series: []
    })
    @emissions_chart = new Highcharts.Chart({
      chart: { renderTo: 'emissions_chart' },
      title: { text: 'Belgian greenhouse gas emissions from electricity' },
      subtitle: { text: "MtCO<sub>2</sub>e/yr"},
      yAxis: { title: null, min: -50, max: 200 },
      tooltip: {
        formatter: () ->
          "<b>#{this.series.name}</b><br/>#{this.x}: #{Highcharts.numberFormat(this.y, 0, ',')} MtCO2e/yr"
      },
      series: []
    })

  teardown: () ->
    $('#results').empty()
    @final_energy_chart = null
    @primary_energy_chart = null
    @emissions_chart = null
    
  updateResults: (@pathway) ->
    @setup() unless @emissions_chart? && @demand_chart? && @supply_chart?

    # Emissions from electricity
    titles = ["Fuel Combustion", "Bioenergy credit", "Carbon capture"]
    i = 0
    for name in titles
      data = @pathway['electricity']['emissions'][name]
      if @emissions_chart.series[i]?
        @emissions_chart.series[i].setData(data,false)
      else
        @emissions_chart.addSeries({name:name,data:data},false)
      i++

    # Set this in the context of Belgian total
    data = @pathway['ghg']["Total net of biomass excl. Int'l aviation"]
    if @emissions_chart.series[i]?
      @emissions_chart.series[i].setData(data,false)
    else
      @emissions_chart.addSeries({type: 'line', name: 'Total emissions from all sources',data:data, lineColor: '#000', color: '#000',lineWidth:2,dashStyle:'Dot', shadow: false},false)
    i++

    # Add a total for electricity emissions
    data = @pathway['electricity']['emissions']["Total"]
    if @emissions_chart.series[i]?
      @emissions_chart.series[i].setData(data,false)
    else
      @emissions_chart.addSeries({type: 'line', name: 'Total net emissions from electricity',data:data, lineColor: '#000', color: '#000',lineWidth:2, shadow: true},false)
    i++
      
    # Demand for electricity
    titles = ['Industry','Transport','Heating','Lighting and appliances']
    i = 0
    for name in titles
      data = @pathway['electricity']['demand'][name]
      if @demand_chart.series[i]?
        @demand_chart.series[i].setData(data,false)
      else
        @demand_chart.addSeries({name:name,data:data},false)
      i++
    
    # Set this in the context of Belgian total
    data = @pathway['final_energy_demand']['Total final energy demand']
    if @demand_chart.series[i]?
      @demand_chart.series[i].setData(data,false)
    else
      @demand_chart.addSeries({type: 'line', name: 'Total demand for all forms of energy',data:data, lineColor: '#000', color: '#000',lineWidth:2,dashStyle:'Dot', shadow: false},false)
    i++
    
    # Supply of electricity
    titles = ["Coal+Gas+Oil power stations", "Biomass power stations", "Carbon Capture Storage (CCS)", "Nuclear power", "Onshore wind", "Offshore wind", "Solar PV", "Geothermal electricity", "Hydroelectric power stations", "Imports of decarbonized electricity", "Industry CHP"]
    i = 0
    for name in titles
      data = @pathway['electricity']['supply'][name]
      if @supply_chart.series[i]?
        @supply_chart.series[i].setData(data,false)
      else
        @supply_chart.addSeries({name:name,data:data},false)
      i++

    # Set this in the context of Belgian total
    data = @pathway['final_energy_demand']['Total Use']
    if @supply_chart.series[i]?
      @supply_chart.series[i].setData(data,false)
    else
      @supply_chart.addSeries({type: 'line', name: 'Total demand for all forms of energy',data:data, lineColor: '#000', color: '#000',lineWidth:2,dashStyle:'Dot', shadow: false},false)
    i++
    
    @emissions_chart.redraw()
    @demand_chart.redraw()
    @supply_chart.redraw()
    
window.twentyfifty.views['electricity'] = new Electricity
