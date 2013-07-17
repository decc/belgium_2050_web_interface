class PrimaryEnergy

  constructor: () ->

  setup: () ->
    target = $('#results')
    target.append("<div id='demand_chart' class='chart'></div>")
    target.append("<div id='supply_chart' class='chart'></div>")
    target.append("<div id='emissions_chart' class='chart'></div>")

    @final_energy_chart = new Highcharts.Chart({
      chart: { renderTo: 'demand_chart' },
      title: { text: 'Belgian energy demand' },
      subtitle: { text: "TWh/yr of final energy"},
      yAxis: { title: null, min: 0, max: 700 },
      series: []
    })
    @primary_energy_chart = new Highcharts.Chart({
      chart: { renderTo: 'supply_chart' },
      title: { text: 'Belgian energy supply' },
      subtitle: { text: "TWh/yr of primary energy"},
      yAxis: { title: null, min: 0, max: 700 },
      series: []
    })
    @emissions_chart = new Highcharts.Chart({
      chart: {
        renderTo: 'emissions_chart'
        events:
          load: () ->
            @renderer.text("Targets" ,380,170).css({fill: '#fff', 'font-size': '0.8em'}).attr({zIndex:10, transform:'rotate(13 380 170)'}).add()
      },
      title: { text: 'Belgian greenhouse gas emissions' },
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
    @setup() unless @emissions_chart? && @final_energy_chart? && @primary_energy_chart?
    titles = ['Bioenergy credit','Carbon capture','International Aviation and Shipping','Industrial Processes','Solvent and Other Product Use','Agriculture','Land-Use, Land-Use Change and Forestry','Waste','Other','Fuel Combustion']
    i = 0
    for name in titles
      data = @pathway['ghg'][name]
      if @emissions_chart.series[i]?
        @emissions_chart.series[i].setData(data,false)
      else
        @emissions_chart.addSeries({name:name,data:data},false)
      i++
     
    # Emissions target line
    data = @pathway['ghg']["TARGETS"]
    if @emissions_chart.series[i]?
      @emissions_chart.series[i].setData(data,false)
    else
      @emissions_chart.addSeries({type: 'line', name: 'Targets', data: data, lineColor:'#fff', color:'#fff',dashStyle:'Dot', lineWidth:2},false)
    i++

    # Net emissions line
    data = @pathway['ghg']["Total net of biomass excl. Int'l aviation"]
    if @emissions_chart.series[i]?
      @emissions_chart.series[i].setData(data,false)
    else
      @emissions_chart.addSeries({type: 'line', name: "Total net emissions excl. Int'l aviation",data:data, lineColor: '#000', color: '#000',lineWidth:2, shadow: true},false)
    i++

    titles = ['Industry','Transport','Buildings']
    i = 0
    for name in titles
      data = @pathway['final_energy_demand'][name]
      if @final_energy_chart.series[i]?
        @final_energy_chart.series[i].setData(data,false)
      else
        @final_energy_chart.addSeries({name:name,data:data},false)
      i++
    titles = ["Nuclear fission", "Solar", "Wind", "Tidal", "Wave", "Geothermal", "Hydro", "Electricity imports (exports)", "Environmental heat", "Total Biomass", "Coal", "Oil and petroleum products", "Natural gas"]
    i = 0
    for name in titles
      data = @pathway['primary_energy_supply'][name]
      if @primary_energy_chart.series[i]?
        @primary_energy_chart.series[i].setData(data,false)
      else
        @primary_energy_chart.addSeries({name:name,data:data},false)
      i++

    @emissions_chart.redraw()
    @final_energy_chart.redraw()
    @primary_energy_chart.redraw()

window.twentyfifty.views['primary_energy_chart'] = new PrimaryEnergy
