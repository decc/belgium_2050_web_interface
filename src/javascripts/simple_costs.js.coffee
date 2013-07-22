class SimpleCosts

  setup: () ->
    target = $('#results')
    target.append("<div id='costs_by_sector_chart' class='chart'></div>")
      .append("<div id='costs_by_type_chart' class='chart'></div>")
      .append("<div id='emissions_chart' class='chart'></div>")

    @costs_by_sector_chart = new Highcharts.Chart({
      chart: { renderTo: 'costs_by_sector_chart' },
      title: { text: 'Belgian costs by sector' },
      subtitle: { text: "MEUR"},
      yAxis: { title: null, min: 0, max: 100000 },
      series: []
    })

    @costs_by_type_chart = new Highcharts.Chart({
      chart: { renderTo: 'costs_by_type_chart' },
      title: { text: 'Belgian costs by type' },
      subtitle: { text: "MEUR"},
      yAxis: { title: null, min: 0, max: 100000 },
      series: []
    })

  teardown: () ->
    $('#results').empty()
    @costs_by_sector_chart = null
    @costs_by_type_chart = null
    
  updateResults: (@pathway) ->
    @setup() unless @costs_by_sector_chart? && @costs_by_type_chart?

    # Costs by sector
    titles = ['Average TOTAL COSTS for Building', 'Average TOTAL COSTS for Transport', 'Average TOTAL COSTS for Industry', 'Average TOTAL COSTS for Energy']
    i = 0
    for name in titles
      data = @pathway['simple_costs']['sector'][name]
      if @costs_by_sector_chart.series[i]?
        @costs_by_sector_chart.series[i].setData(data,false)
      else
        @costs_by_sector_chart.addSeries({name:name,data:data},false)
      i++
    
    # Costs by type
    titles = ["Total average FUEL COSTS", "Total average O&M COSTS", "Total average INVESTMENTS"]
    i = 0
    for name in titles
      data = @pathway['simple_costs']['type'][name]
      if @costs_by_type_chart.series[i]?
        @costs_by_type_chart.series[i].setData(data,false)
      else
        @costs_by_type_chart.addSeries({name:name,data:data},false)
      i++

    @costs_by_sector_chart.redraw()
    @costs_by_type_chart.redraw()
    
window.twentyfifty.views['simple_costs'] = new SimpleCosts
